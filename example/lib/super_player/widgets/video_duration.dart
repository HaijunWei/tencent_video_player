import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_video_player/video_player.dart';
import '../utils/format_utils.dart';

class VideoDuration extends StatelessWidget {
  const VideoDuration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final seconds = context.select(
        (HJVideoPlayerController value) => value.value.duration.inSeconds);
    return Text(formatTime(seconds));
  }
}
