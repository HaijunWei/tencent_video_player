import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_video_player/video_player.dart';
import '../super_player_controller.dart';
import 'full_screen_toggle.dart';
import 'auto_hide_container.dart';
import 'play_toggle.dart';
import 'progress_bar.dart';
import 'video_duration.dart';
import 'video_position.dart';
import 'video_setting_button.dart';
import 'video_speed_toggle.dart';
import 'video_title.dart';

class LandscapeControls extends StatelessWidget {
  const LandscapeControls({
    Key? key,
    this.topAction,
    this.floatAction,
    this.bottomAction,
  }) : super(key: key);

  final Widget? topAction;

  final Widget? floatAction;

  final Widget? bottomAction;

  @override
  Widget build(BuildContext context) {
    final type =
        context.select((HJVideoPlayerController controller) => controller.type);
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          height: 60,
          child: AutoHideContainer(
            child: Container(
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
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    CupertinoButton(
                      onPressed: () {
                        final controller =
                            context.read<SuperPlayerController>();
                        if (controller.isFullScreen) {
                          controller.isFullScreen = false;
                          return;
                        }
                        Navigator.of(context).maybePop();
                      },
                      padding: EdgeInsets.zero,
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const Expanded(child: VideoTitle()),
                    if (topAction != null) topAction!,
                    const VideoSettingButton(),
                  ],
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
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const PlayToggle(),
                          Expanded(
                            child: Offstage(
                              offstage: type == PlayerType.live,
                              child: const VideoProgressBar(),
                            ),
                          ),
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
                          const SizedBox(width: 12),
                          Offstage(
                            offstage: type == PlayerType.live,
                            child: const VideoSpeedToggle(),
                          ),
                          const FullScreenToggle(),
                          if (bottomAction != null) bottomAction!,
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (floatAction != null)
          Positioned.fill(
            child: AutoHideContainer(
              child: floatAction!,
            ),
          ),
      ],
    );
  }
}
