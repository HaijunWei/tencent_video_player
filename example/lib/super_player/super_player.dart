export 'super_player_controller.dart';
export 'widgets/portrait_controls.dart';
export 'widgets/landscape_controls.dart';
export 'widgets/auto_hide_container.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:tencent_video_player/video_player.dart';
import 'super_player_controller.dart';
import 'widgets/landscape_controls.dart';
import 'widgets/loading_widget.dart';
import 'widgets/player_gesture_detector.dart';
import 'widgets/player_overlay.dart';
import 'widgets/portrait_controls.dart';

class SuperPlayer extends StatefulWidget {
  const SuperPlayer({
    Key? key,
    required this.controller,
    this.portraitControls = const PortraitControls(),
    this.landscapeControls = const LandscapeControls(),
    this.loadingWidget = const LoadingWidget(),
    this.systemUiMode = SystemUiMode.edgeToEdge,
    this.systemUiModeFullscreen = SystemUiMode.immersive,
    this.preferredDeviceOrientation = const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
    this.preferredDeviceOrientationFullscreen = const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ],
    this.stopWidget,
    this.videoBackgroundColor = Colors.transparent,
    this.leftWidget,
    this.rightWidget,
    this.builder,
  }) : super(key: key);

  final SuperPlayerController controller;
  final Widget loadingWidget;

  /// 视频停止播放状态显示自定义widget
  final Widget? stopWidget;

  final Widget portraitControls;
  final Widget landscapeControls;
  final SystemUiMode systemUiMode;
  final SystemUiMode systemUiModeFullscreen;
  final List<DeviceOrientation> preferredDeviceOrientation;
  final List<DeviceOrientation> preferredDeviceOrientationFullscreen;

  final TransitionBuilder? builder;

  /// 视频未占满父视图，空白区域背景色
  final Color videoBackgroundColor;

  /// 视频左边附加视图
  final Widget? leftWidget;

  /// 视频右边附加视图
  final Widget? rightWidget;

  @override
  _SuperPlayerState createState() => _SuperPlayerState();
}

class _SuperPlayerState extends State<SuperPlayer> {
  bool _isFullscreen = false;
  SuperPlayerController? _controller;

  _setPreferredOrientation() {
    if (_isFullscreen) {
      SystemChrome.setPreferredOrientations(
          widget.preferredDeviceOrientationFullscreen);
    } else {
      SystemChrome.setPreferredOrientations(widget.preferredDeviceOrientation);
    }
  }

  _setSystemUIOverlays() {
    if (_isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(widget.systemUiModeFullscreen);
    } else {
      SystemChrome.setEnabledSystemUIMode(widget.systemUiMode);
    }
  }

  _switchToFullscreen() {
    _isFullscreen = true;
    _setPreferredOrientation();
    _setSystemUIOverlays();
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        Widget child = Scaffold(
          resizeToAvoidBottomInset: false,
          body: _PlayerBuilder(
            controller: widget.controller,
            child: _SuperPlayerContainer(
              loadingWidget: widget.loadingWidget,
              controls: widget.landscapeControls,
              enabledGestureControl:
                  widget.controller.options.enabledLandscapeGestureControl,
              videoBackgroundColor: widget.videoBackgroundColor,
              stopWidget: widget.stopWidget,
              leftWidget: widget.leftWidget,
              rightWidget: widget.rightWidget,
              enabledSnapshot: true,
            ),
          ),
        );
        if (widget.builder != null) child = widget.builder!(context, child);
        return child;
      },
    );
  }

  _exitFullscreen() {
    _isFullscreen = false;
    Navigator.of(context).pop();
    _setPreferredOrientation();
    _setSystemUIOverlays();
  }

  void _listener() {
    final controller = widget.controller;
    if (_isFullscreen != controller.isFullScreen) {
      _isFullscreen = controller.isFullScreen;
      if (_isFullscreen) {
        _switchToFullscreen();
      } else {
        _exitFullscreen();
      }
    }
  }

  void _updateManager() {
    _controller = widget.controller;
    _controller?.addListener(_listener);
  }

  @override
  void initState() {
    super.initState();
    _updateManager();
  }

  @override
  void didUpdateWidget(SuperPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _updateManager();
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = _PlayerBuilder(
      controller: widget.controller,
      child: _SuperPlayerContainer(
        loadingWidget: widget.loadingWidget,
        controls: widget.portraitControls,
        enabledGestureControl:
            widget.controller.options.enabledPortraitGestureControl,
        videoBackgroundColor: widget.videoBackgroundColor,
        stopWidget: widget.stopWidget,
        leftWidget: widget.leftWidget,
        rightWidget: widget.rightWidget,
      ),
    );
    if (widget.builder != null) child = widget.builder!(context, child);
    return child;
  }
}

class _SuperPlayerContainer extends StatelessWidget {
  const _SuperPlayerContainer({
    Key? key,
    required this.loadingWidget,
    required this.controls,
    this.enabledGestureControl = true,
    this.stopWidget,
    this.videoBackgroundColor,
    this.leftWidget,
    this.rightWidget,
    this.enabledSnapshot = false,
  }) : super(key: key);

  final Widget loadingWidget;
  final Widget controls;
  final bool enabledGestureControl;
  final Widget? stopWidget;
  final Widget? leftWidget;
  final Widget? rightWidget;
  final Color? videoBackgroundColor;
  final bool enabledSnapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          SafeArea(
            top: false,
            bottom: false,
            child: _SnapshotContainer(
              enabled: enabledSnapshot,
              child: Row(
                children: [
                  if (leftWidget != null) leftWidget!,
                  Expanded(
                    child: Stack(
                      children: [
                        _VideoPlayer(
                          enabledSnapshot: enabledSnapshot,
                          videoBackgroundColor: videoBackgroundColor,
                        ),
                        loadingWidget,
                        PlayerGestureDetector(
                          enabledControl: enabledGestureControl,
                        ),
                      ],
                    ),
                  ),
                  if (rightWidget != null) rightWidget!,
                ],
              ),
            ),
          ),
          controls,
          const PlayerOverlay(),
          _StopContainer(
            stopWidget: stopWidget,
          ),
        ],
      ),
    );
  }
}

class _SnapshotContainer extends StatelessWidget {
  const _SnapshotContainer({
    Key? key,
    required this.child,
    this.enabled = false,
  }) : super(key: key);

  /// 用了globalKey，所以只能在横屏和竖屏启用一个
  /// 同时使用会导致横竖屏其中一个黑屏
  final bool enabled;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (enabled) {
      return Screenshot(
        controller: context.select((SuperPlayerController controller) =>
            controller.screenshotController),
        child: child,
      );
    }
    return child;
  }
}

class _PlayerBuilder extends StatelessWidget {
  const _PlayerBuilder({
    Key? key,
    required this.child,
    required this.controller,
  }) : super(key: key);

  final Widget child;
  final SuperPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: controller),
        ChangeNotifierProvider.value(value: controller.playerController),
      ],
      child: child,
    );
  }
}

class _VideoPlayer extends StatelessWidget {
  const _VideoPlayer({
    Key? key,
    this.enabledSnapshot = false,
    this.videoBackgroundColor,
  }) : super(key: key);

  final bool enabledSnapshot;
  final Color? videoBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final videoSize = context
        .select<HJVideoPlayerController, Size>((value) => value.value.size);
    final controller = context.watch<SuperPlayerController>();
    final videoPlayer = HJVideoPlayer(
      key: enabledSnapshot ? controller.videoPlayerKey : null,
      controller: controller.playerController,
    );

    double videoWidth = videoSize.width;
    double videoHeight = videoSize.height;
    double videoAspectRatio = videoWidth / videoHeight;

    return Container(
      color: context.select(
              (HJVideoPlayerController controller) => controller.value.isReady)
          ? videoBackgroundColor
          : null,
      alignment: Alignment.center,
      child: IgnorePointer(
        child: LayoutBuilder(builder: (context, size) {
          if (videoAspectRatio == 0 || videoAspectRatio.isNaN) {
            videoAspectRatio = size.maxWidth / size.maxHeight;
          }
          return AspectRatio(
            aspectRatio: videoAspectRatio,
            child: videoPlayer,
          );
        }),
      ),
    );
  }
}

class _StopContainer extends StatelessWidget {
  const _StopContainer({
    Key? key,
    required this.stopWidget,
  }) : super(key: key);

  final Widget? stopWidget;

  @override
  Widget build(BuildContext context) {
    final isStop = context.select(
        (HJVideoPlayerController controller) => controller.value.isStop);
    if (isStop && stopWidget != null) {
      return stopWidget!;
    }
    return const SizedBox();
  }
}
