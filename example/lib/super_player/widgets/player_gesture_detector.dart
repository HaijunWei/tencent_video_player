import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_video_player/video_player.dart';
import 'package:tencent_video_player_example/super_player/utils/format_utils.dart';
import '../super_player_controller.dart';
import 'slider.dart' as app;

class PlayerGestureDetector extends StatefulWidget {
  const PlayerGestureDetector({
    Key? key,
    this.enabledControl = true,
  }) : super(key: key);

  final bool enabledControl;

  @override
  _HJVideoPlayerGestureDetectorState createState() =>
      _HJVideoPlayerGestureDetectorState();
}

class _HJVideoPlayerGestureDetectorState extends State<PlayerGestureDetector> {
  late SuperPlayerController controller;
  late HJVideoPlayerController playerController;
  double _dragDistance = 0;
  double _volume = 0;
  double _brightness = 0;
  bool _isUpdateVolume = false;
  double _containerWidth = 0;

  void _handleTap(BuildContext context) {
    if (controller.showVideoControls) {
      controller.hideControls();
    } else {
      controller.showControls(autoHide: true);
    }
  }

  void _handleDoubleTap(BuildContext context) {
    if (controller.playerController.value.isPlaying) {
      controller.playerController.pause();
      controller.showToast('已暂停');
    } else {
      controller.playerController.resume();
    }
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    if (playerController.type == PlayerType.live) return;
    _dragDistance = 0;
    const entry = ProgressOverlay();
    controller.insertOverlay('ProgressOverlay', entry);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (playerController.type == PlayerType.live) return;
    _dragDistance += details.delta.dx;
    if (_dragDistance.abs() < 10) return;
    controller.draggingDuration =
        Duration(seconds: (_dragDistance * 0.1).toInt());
  }

  void _onHorizontalDragEnd() {
    if (playerController.type == PlayerType.live) return;
    controller.removeOverlay('ProgressOverlay');
    final duration = Duration(seconds: (_dragDistance.abs() * 0.1).toInt());
    if (_dragDistance < 0) {
      controller.seekBackward(duration);
    } else {
      controller.seekForward(duration);
    }
    _dragDistance = 0;
  }

  void _onHorizontalDragCancel() {
    controller.removeOverlay('ProgressOverlay');
    _dragDistance = 0;
  }

  void _onVerticalDragStart(DragStartDetails details) {
    if (details.localPosition.dx > _containerWidth * 0.5) {
      _isUpdateVolume = true;
      _volume = controller.volume;
      const entry = VolumeOverlay();
      controller.insertOverlay('VolumeOverlay', entry);
    } else {
      _isUpdateVolume = false;
      _brightness = controller.brightness;
      const entry = BrightnessOverlay();
      controller.insertOverlay('BrightnessOverlay', entry);
    }
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (_isUpdateVolume) {
      _volume += -details.delta.dy * 0.005;
      controller.setVolume(_volume.clamp(0.0, 1.0));
    } else {
      _brightness += -details.delta.dy * 0.005;
      controller.setScreenBrightness(_brightness.clamp(0.0, 1.0));
    }
  }

  void _onVerticalDragEnd() {
    if (_isUpdateVolume) {
      controller.removeOverlay('VolumeOverlay');
    } else {
      controller.removeOverlay('BrightnessOverlay');
    }
  }

  @override
  void initState() {
    super.initState();
    controller = context.read<SuperPlayerController>();
    playerController = context.read<HJVideoPlayerController>();
  }

  @override
  void didUpdateWidget(covariant PlayerGestureDetector oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller = context.read<SuperPlayerController>();
    playerController = context.read<HJVideoPlayerController>();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _handleTap(context),
      onDoubleTap: () => _handleDoubleTap(context),
      onHorizontalDragStart:
          widget.enabledControl ? _onHorizontalDragStart : null,
      onHorizontalDragUpdate:
          widget.enabledControl ? _onHorizontalDragUpdate : null,
      onHorizontalDragEnd:
          widget.enabledControl ? (_) => _onHorizontalDragEnd() : null,
      onHorizontalDragCancel:
          widget.enabledControl ? _onHorizontalDragCancel : null,
      onVerticalDragStart: widget.enabledControl ? _onVerticalDragStart : null,
      onVerticalDragUpdate:
          widget.enabledControl ? _onVerticalDragUpdate : null,
      onVerticalDragEnd:
          widget.enabledControl ? (_) => _onVerticalDragEnd() : null,
      onVerticalDragCancel: widget.enabledControl ? _onVerticalDragEnd : null,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          _containerWidth = constraints.maxWidth;
          return Container();
        },
      ),
    );
  }
}

class ProgressOverlay extends StatelessWidget {
  const ProgressOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SuperPlayerController>();
    final seconds = controller.draggingDuration.inSeconds;
    final duration = controller.playerController.value.duration.inSeconds;
    final position =
        controller.playerController.value.position.inSeconds + seconds;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: formatTime(position),
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'din',
                    color: Colors.white,
                  )),
              TextSpan(
                text: ' / ${formatTime(duration)}',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'din',
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VolumeOverlay extends StatelessWidget {
  const VolumeOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final volume =
        context.select((SuperPlayerController controller) => controller.volume);
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            width: 150,
            height: 150,
            color: const Color(0xFFEBEBEB).withOpacity(0.8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '声音',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                Icon(
                  Icons.volume_up_rounded,
                  size: 60,
                  color: Colors.black.withOpacity(0.5),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 100,
                  child: app.Slider(
                    value: volume,
                    inactiveColor: Colors.black.withOpacity(0.5),
                    needControl: false,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BrightnessOverlay extends StatelessWidget {
  const BrightnessOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = context
        .select((SuperPlayerController controller) => controller.brightness);
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            width: 150,
            height: 150,
            color: const Color(0xFFEBEBEB).withOpacity(0.8),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '亮度',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                Icon(
                  Icons.light_mode_outlined,
                  size: 60,
                  color: Colors.black.withOpacity(0.5),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 100,
                  child: app.Slider(
                    value: brightness,
                    inactiveColor: Colors.black.withOpacity(0.5),
                    needControl: false,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
