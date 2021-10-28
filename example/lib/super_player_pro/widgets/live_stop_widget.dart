import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tencent_video_player/video_player.dart';
import '../../super_player/super_player.dart';

class LiveStopWidget extends StatelessWidget {
  const LiveStopWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '讲师尚未连线，请稍后再试',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          CupertinoButton(
            minSize: 35,
            padding: EdgeInsets.zero,
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(5),
            child: Container(
              width: 120,
              height: 35,
              alignment: Alignment.center,
              child: const Text(
                '刷新',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            onPressed: () {
              context.read<HJVideoPlayerController>().replay();
            },
          ),
          const SizedBox(height: 8),
          CupertinoButton(
            minSize: 35,
            padding: EdgeInsets.zero,
            child: Container(
              width: 120,
              height: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                '返回',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            onPressed: () {
              final manager = context.read<SuperPlayerController>();
              if (manager.isFullScreen) {
                manager.isFullScreen = false;
                return;
              }
              Navigator.of(context).maybePop();
            },
          ),
        ],
      ),
    );
  }
}
