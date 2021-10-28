export 'widgets/live_stop_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:provider/provider.dart';
import '../super_player/super_player.dart';
import 'super_player_pro_controller.dart';
import 'widgets/live_chat.dart';
import 'widgets/live_stop_widget.dart';
import 'widgets/player_bottom_action.dart';
import 'widgets/player_float_action.dart';
import 'widgets/player_top_action.dart';

class SuperPlayerPro extends StatelessWidget {
  const SuperPlayerPro({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SuperPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: SuperPlayer(
        controller: controller,
        videoBackgroundColor: const Color(0xFFF6F6F6),
        portraitControls: const PortraitControls(
          needTopBar: false,
        ),
        landscapeControls: const LandscapeControls(
          topAction: PlayerTopAction(),
          bottomAction: PlayerBottomAction(),
          floatAction: PlayerFloatAction(),
        ),
        rightWidget: const LiveChatContainer(),
        stopWidget: const LiveStopWidget(),
        builder: (context, child) {
          return GetBuilder<SuperPlayerProController>(
            init: SuperPlayerProController(controller: controller),
            builder: (_) => child!,
          );
        },
      ),
    );
  }
}
