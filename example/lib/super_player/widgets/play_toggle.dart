import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_video_player/video_player.dart';

class PlayToggle extends StatelessWidget {
  const PlayToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPlaying = context
        .select((HJVideoPlayerController value) => value.value.isPlaying);
    Widget playWidget = Image.asset(
      'assets/images/ic_player_play.png',
      width: 20,
    );
    Widget pauseWidget = Image.asset(
      'assets/images/ic_player_pause.png',
      width: 20,
    );
    return CupertinoButton(
      onPressed: () {
        final controller = context.read<HJVideoPlayerController>();
        if (controller.value.isStop) {
          controller.replay();
        } else {
          isPlaying ? controller.pause() : controller.resume();
        }
      },
      child: isPlaying ? pauseWidget : playWidget,
      padding: EdgeInsets.zero,
    );
  }
}
