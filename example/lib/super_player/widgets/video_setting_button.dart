import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_video_player/video_player.dart';
import '../super_player_controller.dart';
import 'slider.dart' as app;

class VideoSettingButton extends StatefulWidget {
  const VideoSettingButton({Key? key}) : super(key: key);

  @override
  _VideoSettingButtonState createState() => _VideoSettingButtonState();
}

class _VideoSettingButtonState extends State<VideoSettingButton>
    with TickerProviderStateMixin {
  void _handleSetting(BuildContext context) {
    final controller = context.read<SuperPlayerController>();
    if (controller.showVideoControls) controller.hideControls();

    final animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    final animation = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(animationController);
    final panel = SettingPanel(
      animation: animation,
      onClose: () async {
        await animationController.reverse();
        controller.removeOverlay('settingPanel');
      },
    );
    controller.insertOverlay('settingPanel', panel);
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () => _handleSetting(context),
      child: Image.asset(
        'assets/images/ic_player_more.png',
        width: 20,
      ),
    );
  }
}

class SettingPanel extends StatelessWidget {
  const SettingPanel({
    Key? key,
    required this.animation,
    required this.onClose,
  }) : super(key: key);

  final Animation<Offset> animation;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final volume =
        context.select((SuperPlayerController controller) => controller.volume);
    final brightness = context
        .select((SuperPlayerController controller) => controller.brightness);
    final type =
        context.select((HJVideoPlayerController controller) => controller.type);
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
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
              color: Colors.black.withOpacity(0.85),
              child: SafeArea(
                left: false,
                child: SizedBox(
                  width: 230,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.volume_up,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text('声音'),
                              ],
                            ),
                            const SizedBox(height: 10),
                            app.Slider(
                              value: volume,
                              onChanged: (value) {
                                context
                                    .read<SuperPlayerController>()
                                    .setVolume(value);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.light_mode,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text('亮度'),
                              ],
                            ),
                            const SizedBox(height: 10),
                            app.Slider(
                              value: brightness,
                              onChanged: (value) {
                                context
                                    .read<SuperPlayerController>()
                                    .setScreenBrightness(value);
                              },
                            ),
                          ],
                        ),
                        Offstage(
                          offstage: type == PlayerType.live,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.speed,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text('倍速'),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: DefaultTextStyle(
                                    style: const TextStyle(
                                      fontFamily: 'din',
                                    ),
                                    child: Wrap(
                                      spacing: 15,
                                      alignment: WrapAlignment.start,
                                      children: const [
                                        _SpeedTile(speed: 0.75),
                                        _SpeedTile(speed: 1),
                                        _SpeedTile(speed: 1.25),
                                        _SpeedTile(speed: 1.5),
                                        _SpeedTile(speed: 2),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
    final playerController = context.watch<HJVideoPlayerController>();
    String title = speed.toStringAsFixed(1);
    if (double.parse(title) != speed) title = speed.toStringAsFixed(2);
    return GestureDetector(
      onTap: () {
        context.read<SuperPlayerController>().setPlaybackSpeed(speed);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          '${title}X',
          style: TextStyle(
            color: playerController.value.playbackSpeed == speed
                ? Theme.of(context).primaryColor
                : null,
          ),
        ),
      ),
    );
  }
}
