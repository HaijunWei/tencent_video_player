import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../super_player_controller.dart';

class AutoHideContainer extends StatelessWidget {
  const AutoHideContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SuperPlayerController>();

    return IgnorePointer(
      ignoring: !controller.showVideoControls,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: controller.showVideoControls ? 1 : 0,
        child: child,
      ),
    );
  }
}
