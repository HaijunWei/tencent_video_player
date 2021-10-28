import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_video_player/video_player.dart';

import '../super_player_controller.dart';
import 'auto_hide_container.dart';
import 'full_screen_toggle.dart';
import 'play_toggle.dart';
import 'progress_bar.dart';
import 'video_duration.dart';
import 'video_position.dart';

class PortraitControls extends StatelessWidget {
  const PortraitControls({
    Key? key,
    this.needTopBar = true,
  }) : super(key: key);

  final bool needTopBar;

  @override
  Widget build(BuildContext context) {
    final type =
        context.select((HJVideoPlayerController controller) => controller.type);
    return Stack(
      children: [
        if (needTopBar)
          Positioned(
            left: 0,
            right: 0,
            height: 40,
            child: AutoHideContainer(
              child: Container(
                height: 100,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CupertinoButton(
                  onPressed: () {
                    final controller = context.read<SuperPlayerController>();
                    if (controller.isFullScreen) {
                      controller.isFullScreen = false;
                      return;
                    }
                    Navigator.of(context).maybePop();
                  },
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        Positioned.fill(
          child: AutoHideContainer(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const PlayToggle(),
                          const Expanded(child: VideoProgressBar()),
                          const SizedBox(width: 12),
                          DefaultTextStyle(
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'din',
                              fontSize: 12,
                            ),
                            child: Row(
                              children: <Widget>[
                                const VideoPosition(),
                                Offstage(
                                  offstage: type == PlayerType.live,
                                  child: Row(
                                    children: const [
                                      Text(' / '),
                                      VideoDuration(),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const FullScreenToggle(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
