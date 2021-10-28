import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../super_player_controller.dart';

class VideoTitle extends StatelessWidget {
  const VideoTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title =
        context.select((SuperPlayerController controller) => controller.title);
    if (title == null) return const SizedBox();
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
    );
  }
}
