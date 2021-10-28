import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_video_player/video_player.dart';
import '../super_player_controller.dart';
import '../utils/format_utils.dart';
import 'slider.dart' as app;

class VideoProgressBar extends StatelessWidget {
  const VideoProgressBar({Key? key}) : super(key: key);

  void _beginDragProgress(BuildContext context) {
    final controller = context.read<SuperPlayerController>();
    if (controller.playerController.type == PlayerType.live) return;
    controller.beginDragProgress();
    const entry = ProgressOverlay();
    controller.insertOverlay('ProgressOverlay', entry);
  }

  void _onChanged(BuildContext context, double value) {
    final controller = context.read<SuperPlayerController>();
    if (controller.playerController.type == PlayerType.live) return;
    controller.draggingProgress = value;
  }

  void _endDragProgress(BuildContext context, double value) async {
    final controller = context.read<SuperPlayerController>();
    if (controller.playerController.type == PlayerType.live) return;
    controller.endDragProgress();
    final seconds =
        (controller.playerController.value.duration.inSeconds * value).toInt();
    await controller.playerController.seekTo(seconds);
    await controller.playerController.resume();
    controller.removeOverlay('ProgressOverlay');
  }

  @override
  Widget build(BuildContext context) {
    final isDragingProgress = context.select(
        (SuperPlayerController controller) => controller.isDragingProgress);
    final draggingProgress = context.select(
        (SuperPlayerController controller) => controller.draggingProgress);
    final markPositions = context
        .select((SuperPlayerController controller) => controller.markPositions);
    final duration = context
        .select(
            (HJVideoPlayerController controller) => controller.value.duration)
        .inMilliseconds;
    final position = context
        .select(
            (HJVideoPlayerController controller) => controller.value.position)
        .inMilliseconds;
    final buffered = context
        .select(
            (HJVideoPlayerController controller) => controller.value.buffered)
        .inMilliseconds;
    double value = 0;
    double bufferValue = 0;
    if (duration > 0) {
      value = (position / duration).clamp(0.0, 1.0);
      bufferValue = (buffered / duration).clamp(0.0, 1.0);
    }

    if (isDragingProgress) {
      value = draggingProgress;
    }

    return app.Slider(
      value: value,
      bufferValue: bufferValue,
      markValues:
          markPositions.map((e) => (e / duration).clamp(0.0, 1.0)).toList(),
      onChangeStart: (value) => _beginDragProgress(context),
      onChanged: (value) => _onChanged(context, value),
      onChangeEnd: (value) => _endDragProgress(context, value),
    );
  }
}

class ProgressOverlay extends StatelessWidget {
  const ProgressOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final draggingProgress = context.select(
        (SuperPlayerController controller) => controller.draggingProgress);
    final duration = context.select(
        (HJVideoPlayerController controller) => controller.value.duration);
    final seconds = (duration.inSeconds * draggingProgress).toInt();
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
                text: formatTime(seconds),
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'din',
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: ' / ${formatTime(duration.inSeconds)}',
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
