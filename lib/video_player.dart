import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'messages.dart';
import 'platform_video_player.dart';

export 'messages.dart';

final PlatformVideoPlayer _platformVideoPlayer = PlatformVideoPlayer.instance;

class HJVideoPlayerValue {
  HJVideoPlayerValue({
    this.isPlaying = false,
    this.isStop = false,
    this.isLoading = false,
    this.isReady = false,
    required this.duration,
    this.position = Duration.zero,
    this.buffered = Duration.zero,
    this.size = Size.zero,
    this.playbackSpeed = 1.0,
    this.errorDescription,
  });

  HJVideoPlayerValue.erroneous(String errorDescription)
      : this(
          duration: Duration.zero,
          isReady: false,
          errorDescription: errorDescription,
        );

  /// 是否播放中
  final bool isPlaying;

  /// 视频已停止播放
  final bool isStop;

  final bool isLoading;

  /// 视频是否已经加载成功，可以播放了
  final bool isReady;

  /// 视频时长
  final Duration duration;

  /// 视频已播放时长
  final Duration position;

  /// 视频缓冲长度
  final Duration buffered;

  /// 视频分辨率，直播此值为zero
  final Size size;

  /// 播放速度
  final double playbackSpeed;

  final String? errorDescription;

  bool get hasError => errorDescription != null;

  HJVideoPlayerValue copyWith({
    bool? isPlaying,
    bool? isStop,
    bool? isLoading,
    bool? isReady,
    Duration? duration,
    Duration? position,
    Duration? buffered,
    Size? size,
    double? playbackSpeed,
    String? errorDescription,
  }) {
    return HJVideoPlayerValue(
      isPlaying: isPlaying ?? this.isPlaying,
      isStop: isStop ?? this.isStop,
      isLoading: isLoading ?? this.isLoading,
      isReady: isReady ?? this.isReady,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      buffered: buffered ?? this.buffered,
      size: size ?? this.size,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      errorDescription: errorDescription ?? this.errorDescription,
    );
  }
}

class VideoDataSource {
  VideoDataSource({
    this.url,
    this.asset,
    this.packageName,
    this.liveType = LiveType.flv,
  });

  final String? url;
  final String? asset;
  final String? packageName;
  final LiveType liveType;
}

class HJVideoPlayerController extends ValueNotifier<HJVideoPlayerValue> {
  HJVideoPlayerController(
    this.type,
  ) : super(HJVideoPlayerValue(duration: Duration.zero));

  final PlayerType type;

  static const int kUninitializedTextureId = -1;
  int _textureId = kUninitializedTextureId;
  int get textureId => _textureId;

  Completer<void>? _creatingCompleter;
  StreamSubscription<dynamic>? _eventSubscription;

  bool _initialized = false;
  bool get initialized => _initialized;

  late _VideoAppLifeCycleObserver _lifeCycleObserver;

  bool _isDisposed = false;
  bool _autoPlay = false;
  Duration? _initializedPosition;

  VideoDataSource? _dataSource;

  Future<void> initialize() async {
    if (_initialized) return;
    if (_creatingCompleter != null) {
      await _creatingCompleter!.future;
      return;
    }
    _lifeCycleObserver = _VideoAppLifeCycleObserver(this);
    _lifeCycleObserver.initialize();
    _creatingCompleter = Completer<void>();

    _textureId =
        await _platformVideoPlayer.create(type) ?? kUninitializedTextureId;
    _creatingCompleter!.complete(null);

    void eventListener(VideoEvent event) async {
      if (_isDisposed) return;

      switch (event.eventType) {
        case VideoEventType.ready:
          // 卡顿后恢复播放也会调用此消息
          if (value.isReady) return;
          value = value.copyWith(
            isReady: true,
            isLoading: false,
          );
          if (_initializedPosition != null) {
            seekTo(_initializedPosition!.inSeconds);
          }
          if (_autoPlay) {
            resume();
          }
          break;
        case VideoEventType.resolutionUpdate:
          if (value.isStop) break;
          value = value.copyWith(
            size: event.size,
          );
          break;
        case VideoEventType.progressUpdate:
          if (value.isStop) break;
          value = value.copyWith(
            duration: event.duration,
            position: event.position,
            buffered: event.buffered,
          );
          break;
        case VideoEventType.ended:
          if (value.isStop) break;
          stop();
          break;
        case VideoEventType.unknown:
          break;
      }
    }

    void errorListener(Object obj) {
      final PlatformException e = obj as PlatformException;
      value = HJVideoPlayerValue.erroneous(e.message!);
    }

    _eventSubscription = _platformVideoPlayer
        .videoEventsFor(_textureId)
        .listen(eventListener, onError: errorListener);
    _initialized = true;
  }

  Future<void> play(
    VideoDataSource dataSource, {
    bool autoPlay = true,
    Duration? position,
  }) async {
    _autoPlay = autoPlay;
    _dataSource = dataSource;
    _initializedPosition = position;
    value = value.copyWith(
      isReady: false,
      isStop: false,
      isLoading: true,
    );
    await _platformVideoPlayer.play(
      textureId,
      uri: dataSource.url,
      asset: dataSource.asset,
      packageName: dataSource.packageName,
      liveType: dataSource.liveType,
    );
  }

  Future<void> replay() async {
    if (_dataSource == null) return;
    _initializedPosition = null;
    await _platformVideoPlayer.play(
      textureId,
      uri: _dataSource!.url,
      asset: _dataSource!.asset,
      packageName: _dataSource!.packageName,
      liveType: _dataSource!.liveType,
    );
    _autoPlay = true;
    value = value.copyWith(
      isReady: false,
      isStop: false,
      isLoading: true,
    );
  }

  Future<void> resume() async {
    await _platformVideoPlayer.resume(textureId);
    value = value.copyWith(
      isPlaying: true,
    );
  }

  Future<void> pause() async {
    await _platformVideoPlayer.pause(textureId);
    value = value.copyWith(
      isPlaying: false,
    );
  }

  Future<void> stop() async {
    await _platformVideoPlayer.stop(textureId);
    value = value.copyWith(
      isStop: true,
      isPlaying: false,
      isReady: false,
    );
  }

  Future<void> seekTo(int position) async {
    value = value.copyWith(
      position: Duration(seconds: position),
    );
    await _platformVideoPlayer.seekTo(textureId, position);
  }

  Future<void> setLooping(bool isLooping) async {
    await _platformVideoPlayer.setLooping(textureId, isLooping);
  }

  Future<void> setVolume(double volume) async {
    await _platformVideoPlayer.setVolume(textureId, volume);
  }

  Future<void> setPlaybackSpeed(double speed) async {
    await _platformVideoPlayer.setPlaybackSpeed(textureId, speed);
    value = value.copyWith(playbackSpeed: speed);
  }

  Future<String?> snapshot() {
    return _platformVideoPlayer.snapshot(textureId);
  }

  @override
  Future<void> dispose() async {
    if (_creatingCompleter != null) {
      await _creatingCompleter!.future;
      if (!_isDisposed) {
        _isDisposed = true;
        await _eventSubscription?.cancel();
        await _platformVideoPlayer.dispose(_textureId);
      }
      _lifeCycleObserver.dispose();
    }
    _isDisposed = true;
    super.dispose();
  }
}

class _VideoAppLifeCycleObserver extends Object with WidgetsBindingObserver {
  _VideoAppLifeCycleObserver(this._controller);

  bool _wasPlayingBeforePause = false;
  final HJVideoPlayerController _controller;

  void initialize() {
    _ambiguate(WidgetsBinding.instance)!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _wasPlayingBeforePause = _controller.value.isPlaying;
        _controller.pause();
        break;
      case AppLifecycleState.resumed:
        if (_wasPlayingBeforePause) {
          _controller.resume();
        }
        break;
      default:
    }
  }

  void dispose() {
    _ambiguate(WidgetsBinding.instance)!.removeObserver(this);
  }
}

class HJVideoPlayer extends StatefulWidget {
  const HJVideoPlayer({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final HJVideoPlayerController controller;

  @override
  State<HJVideoPlayer> createState() => _HJVideoPlayerState();
}

class _HJVideoPlayerState extends State<HJVideoPlayer> {
  _HJVideoPlayerState() {
    _listener = () {
      final int newTextureId = widget.controller.textureId;
      if (newTextureId != _textureId) {
        setState(() {
          _textureId = newTextureId;
        });
      }
      final bool newIsReady = widget.controller.value.isReady;
      if (newIsReady != _isReady) {
        setState(() {
          _isReady = newIsReady;
        });
      }
    };
  }

  late int _textureId;
  late bool _isReady;
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _isReady = widget.controller.value.isReady;
    _textureId = widget.controller.textureId;
    widget.controller.addListener(_listener);
  }

  @override
  void didUpdateWidget(covariant HJVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.controller.removeListener(_listener);
    _textureId = widget.controller.textureId;
    widget.controller.addListener(_listener);
  }

  @override
  void deactivate() {
    super.deactivate();
    widget.controller.removeListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    if (_textureId == HJVideoPlayerController.kUninitializedTextureId) {
      return Container();
    }

    return Texture(textureId: _textureId);
  }
}

/// This allows a value of type T or T? to be treated as a value of type T?.
///
/// We use this so that APIs that have become non-nullable can still be used
/// with `!` and `?` on the stable branch.
T? _ambiguate<T>(T? value) => value;
