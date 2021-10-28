import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_video_player/video_player.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<HJVideoPlayerController, bool>(
        (value) => value.value.isLoading);
    if (isLoading) {
      return Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Theme.of(context).primaryColor,
        ),
      );
    }
    return const SizedBox();
  }
}
