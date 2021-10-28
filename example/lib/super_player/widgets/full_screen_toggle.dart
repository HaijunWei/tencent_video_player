import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../super_player_controller.dart';

class FullScreenToggle extends StatelessWidget {
  const FullScreenToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFullScreen = context
        .select((SuperPlayerController controller) => controller.isFullScreen);
    return CupertinoButton(
      onPressed: () {
        context.read<SuperPlayerController>().isFullScreen = !isFullScreen;
      },
      padding: EdgeInsets.zero,
      child: Image.asset(
        'assets/images/ic_player_orientation.png',
        width: 20,
      ),
    );
  }
}
