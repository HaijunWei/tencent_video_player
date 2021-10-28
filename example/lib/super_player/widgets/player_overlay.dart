import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../super_player_controller.dart';

class PlayerOverlay extends StatelessWidget {
  const PlayerOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SuperPlayerController>();
    List<Widget> children = [];
    controller.overlayEntries.forEach((key, value) {
      children.add(value);
    });
    return Stack(
      children: children,
    );
  }
}
