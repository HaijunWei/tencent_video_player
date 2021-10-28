import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tencent_video_player/video_player.dart';
import '../super_player_controller.dart';

class VideoSpeedToggle extends StatefulWidget {
  const VideoSpeedToggle({Key? key}) : super(key: key);

  @override
  _VideoSpeedToggleState createState() => _VideoSpeedToggleState();
}

class _VideoSpeedToggleState extends State<VideoSpeedToggle>
    with TickerProviderStateMixin {
  void _handleSpeed(BuildContext context) {
    final displayManager = context.read<SuperPlayerController>();
    if (displayManager.showVideoControls) displayManager.hideControls();

    final animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    final animation = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(animationController);
    final panel = SpeedPanel(
      animation: animation,
      onClose: () async {
        await animationController.reverse();
        displayManager.removeOverlay('settingPanel');
      },
    );
    displayManager.insertOverlay('settingPanel', panel);
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final speed = context.select(
        (HJVideoPlayerController controller) => controller.value.playbackSpeed);
    String title = speed.toStringAsFixed(1);
    if (double.parse(title) != speed) title = speed.toStringAsFixed(2);
    return CupertinoButton(
      onPressed: () => _handleSpeed(context),
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1.5),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          '${title}X',
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'din',
          ),
        ),
      ),
    );
  }
}

class SpeedPanel extends StatelessWidget {
  const SpeedPanel({
    Key? key,
    required this.animation,
    required this.onClose,
  }) : super(key: key);

  final Animation<Offset> animation;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.centerRight,
          child: SlideTransition(
            position: animation,
            child: Container(
              width: 200,
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              color: Colors.black.withOpacity(0.8),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  _SpeedTile(speed: 2),
                  _SpeedTile(speed: 1.5),
                  _SpeedTile(speed: 1.25),
                  _SpeedTile(speed: 1),
                  _SpeedTile(speed: 0.75),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpeedTile extends StatelessWidget {
  const _SpeedTile({
    Key? key,
    required this.speed,
  }) : super(key: key);

  final double speed;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HJVideoPlayerController>();
    String title = speed.toStringAsFixed(1);
    if (double.parse(title) != speed) title = speed.toStringAsFixed(2);
    return GestureDetector(
      onTap: () {
        context.read<SuperPlayerController>().setPlaybackSpeed(speed);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        child: Text(
          '${title}X',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'din',
            color: controller.value.playbackSpeed == speed
                ? Theme.of(context).primaryColor
                : null,
          ),
        ),
      ),
    );
  }
}
