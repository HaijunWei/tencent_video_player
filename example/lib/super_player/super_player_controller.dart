import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:native_kit/native_kit.dart';
import 'package:screenshot/screenshot.dart';
import 'package:wakelock/wakelock.dart';
import 'package:tencent_video_player/video_player.dart';

import 'widgets/toast.dart';

class SuperPlayerOptions {
  const SuperPlayerOptions({
    this.autoHideControlsDuration = const Duration(seconds: 5),
    this.enabledPortraitGestureControl = true,
    this.enabledLandscapeGestureControl = true,
    this.isFullScreen = true,
  });

  /// 自动隐藏控制面板时长
  final Duration autoHideControlsDuration;

  /// 小屏时是否启用手势控制
  final bool enabledPortraitGestureControl;

  /// 全屏时是否启用手势控制
  final bool enabledLandscapeGestureControl;

  /// 是否直接进入全屏状态
  final bool isFullScreen;
}

class SuperPlayerController extends ChangeNotifier {
  SuperPlayerController({
    this.title,
    required this.playerController,
    this.options = const SuperPlayerOptions(),
  }) {
    ScreenBrightnessControl.record();
    ScreenBrightnessControl.setEnabledAutoKeep(true);
    _isFullScreen = options.isFullScreen;
    _listener();
  }

  final String? title;
  final SuperPlayerOptions options;
  final HJVideoPlayerController playerController;

  /// 是否显示控制面板
  bool _showVideoControls = true;
  bool get showVideoControls => _showVideoControls;

  double _draggingProgress = 0;
  double get draggingProgress => _draggingProgress;
  set draggingProgress(value) {
    _draggingProgress = value;
    notifyListeners();
  }

  bool _isDragingProgress = false;
  bool get isDragingProgress => _isDragingProgress;

  Duration _draggingDuration = const Duration(milliseconds: 0);
  Duration get draggingDuration => _draggingDuration;
  set draggingDuration(Duration value) {
    _draggingDuration = value;
    notifyListeners();
  }

  bool _isFullScreen = false;
  bool get isFullScreen => _isFullScreen;
  set isFullScreen(value) {
    _isFullScreen = value;
    notifyListeners();
    cancelAutoHideControls();
    showControls(autoHide: true);
  }

  double _volume = 0;
  double get volume => _volume;
  set volume(value) {
    _volume = value;
    notifyListeners();
  }

  double _brightness = 0;
  double get brightness => _brightness;
  set brightness(value) {
    _brightness = value;
    notifyListeners();
  }

  List<int> _markPositions = [];
  List<int> get markPositions => _markPositions;

  /// 在播放器动态插入的视图层
  final Map<String, Widget> _overlayEntries = {};
  Map<String, Widget> get overlayEntries => _overlayEntries;

  StreamSubscription<double>? volumeSub;
  StreamSubscription<double>? brightnessSub;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  Timer? _hideControlsTimer;

  ScreenshotController screenshotController = ScreenshotController();

  final videoPlayerKey = GlobalKey();

  void showControls({bool autoHide = false}) {
    _showVideoControls = true;
    notifyListeners();
    if (autoHide && playerController.value.isPlaying) autoHideControls();
  }

  void hideControls() {
    _showVideoControls = false;
    notifyListeners();
    cancelAutoHideControls();
  }

  void autoHideControls() {
    _hideControlsTimer = Timer(options.autoHideControlsDuration, () {
      hideControls();
    });
  }

  void cancelAutoHideControls() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = null;
  }

  void resetAutoHideControls() {
    cancelAutoHideControls();
    autoHideControls();
  }

  void beginDragProgress() {
    _isDragingProgress = true;
    cancelAutoHideControls();
    notifyListeners();
  }

  void endDragProgress() {
    _isDragingProgress = false;
    autoHideControls();
    notifyListeners();
  }

  void insertOverlay(String name, Widget entry) {
    _overlayEntries[name] = entry;
    notifyListeners();
  }

  void removeOverlay(String name) {
    _overlayEntries.remove(name);
    notifyListeners();
  }

  Future<void> play(
    VideoDataSource dataSource, {
    Duration? position,
    bool autoPlay = true,
  }) async {
    if (!playerController.initialized) {
      await playerController.initialize();
    }
    await playerController.play(
      dataSource,
      autoPlay: autoPlay,
      position: position,
    );
  }

  void setVolume(double volume) {
    VolumeControl.hideUI(true);
    VolumeControl.setVolume(volume);
    this.volume = volume;
  }

  void setPlaybackSpeed(double speed) {
    playerController.setPlaybackSpeed(speed);
  }

  Future<void> seekForward(Duration videoSeekDuration) async {
    var duration = playerController.value.position + videoSeekDuration;
    if (duration > playerController.value.duration) {
      duration = playerController.value.duration;
    }
    if (playerController.value.isPlaying) await playerController.pause();
    await playerController.seekTo(duration.inSeconds);
    await playerController.resume();
  }

  Future<void> seekBackward(Duration videoSeekDuration) async {
    var duration = playerController.value.position - videoSeekDuration;
    if (duration < const Duration(seconds: 0)) {
      duration = const Duration(seconds: 0);
    }
    if (playerController.value.isPlaying) await playerController.pause();
    await playerController.seekTo(duration.inSeconds);
    await playerController.resume();
  }

  void setScreenBrightness(double brightness) {
    ScreenBrightnessControl.setBrightness(brightness);
    this.brightness = brightness;
  }

  Future<Uint8List?> snapshot(BuildContext context,
      {bool onlyVideo = false}) async {
    final path = await playerController.snapshot();
    if (path == null) return null;
    var videoImageBytes = File(path).readAsBytesSync();
    if (onlyVideo) return videoImageBytes;

    final recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final videoImage = await _getImage(videoImageBytes);
    final videoBorderImageBytes = await screenshotController.capture();
    final videoBorderImage = await _getImage(videoBorderImageBytes!);
    final paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;
    canvas.drawImage(videoBorderImage, Offset.zero, paint);
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final renderBox =
        videoPlayerKey.currentContext?.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    canvas.drawImageRect(
      videoImage,
      ui.Rect.fromLTRB(
          0, 0, videoImage.width.toDouble(), videoImage.height.toDouble()),
      ui.Rect.fromLTRB(
        0,
        offset.dy * pixelRatio,
        renderBox.size.width.toDouble() * pixelRatio,
        offset.dy * pixelRatio + renderBox.size.height.toDouble() * pixelRatio,
      ),
      paint,
    );
    var picture = recorder.endRecording();
    final image = await picture.toImage(
      videoBorderImage.width,
      videoBorderImage.height,
    );
    return (await image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }

  Future<ui.Image> _getImage(Uint8List bytes) async {
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  /// 展示一个提示文本
  void showToast(String value) async {
    final name = 'Toast_${DateTime.now().millisecondsSinceEpoch}';
    insertOverlay(
      name,
      Toast(
        key: ValueKey(name),
        value: value,
        didHide: () {
          print(name);
          removeOverlay(name);
        },
      ),
    );
  }

  /// 设置进度条标记，单位毫秒
  void setProgressMarks(List<int> positions) {
    _markPositions = positions;
    notifyListeners();
  }

  @override
  void dispose() {
    volumeSub?.cancel();
    brightnessSub?.cancel();
    playerController.dispose();
    _hideControlsTimer?.cancel();
    ScreenBrightnessControl.restore();
    ScreenBrightnessControl.setEnabledAutoKeep(false);
    super.dispose();
  }

  void _listener() async {
    volume = await VolumeControl.volume;
    brightness = await ScreenBrightnessControl.brightness;

    volumeSub = VolumeControl.stream.listen((volume) {
      this.volume = volume;
    });
    brightnessSub = ScreenBrightnessControl.stream.listen((brightness) {
      this.brightness = brightness;
    });

    playerController.addListener(() {
      if (_isPlaying != playerController.value.isPlaying) {
        _isPlaying = playerController.value.isPlaying;
        if (_isPlaying) {
          Wakelock.enable();
          autoHideControls();
        } else {
          Wakelock.disable();
          cancelAutoHideControls();
          showControls();
        }
      }
    });
  }
}
