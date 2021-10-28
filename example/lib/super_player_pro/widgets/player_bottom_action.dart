import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../super_player/super_player_controller.dart';
import '../super_player_pro_controller.dart';

class PlayerBottomAction extends StatelessWidget {
  const PlayerBottomAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<SuperPlayerProController>(builder: (controller) {
      return Row(
        children: [
          CupertinoButton(
            onPressed: () {
              context.read<SuperPlayerController>().resetAutoHideControls();
              controller.showChat.value = !controller.showChat.value;
            },
            padding: EdgeInsets.zero,
            child: Image.asset(
              controller.showChat.value
                  ? 'assets/images/ic_player_expand.png'
                  : 'assets/images/ic_player_shrink.png',
              width: 20,
            ),
          ),
        ],
      );
    });
  }
}
