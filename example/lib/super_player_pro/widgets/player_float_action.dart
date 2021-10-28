import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import '../../super_player/super_player.dart';
import '../super_player_pro_controller.dart';

class PlayerFloatAction extends StatelessWidget {
  const PlayerFloatAction({Key? key}) : super(key: key);

  void _snapshot(BuildContext context) async {
    final controller = context.read<SuperPlayerController>();
    controller.hideControls();
    final data = await context.read<SuperPlayerController>().snapshot(context);
    if (data == null) {
      // 截屏出错
      debugPrint('截屏出错');
      return;
    }
    controller.insertOverlay(
      'snapshot',
      SnapshotAnimationView(
        bytes: data,
        duration: const Duration(milliseconds: 500),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 500));
    controller.removeOverlay('snapshot');
    final result = await ImageGallerySaver.saveImage(data);
    if (result['isSuccess'] == true) {
      // 保存成功
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Image.asset(
                    'assets/images/ic_player_screenshot.png',
                    width: 30,
                  ),
                  onPressed: () => _snapshot(context),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                key: Get.find<SuperPlayerProController>().markButtonKey,
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Image.asset(
                    'assets/images/ic_player_mark.png',
                    width: 30,
                  ),
                  onPressed: () {
                    Get.find<SuperPlayerProController>().showOrHideMarkMenu();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SnapshotAnimationView extends StatefulWidget {
  const SnapshotAnimationView({
    Key? key,
    required this.bytes,
    required this.duration,
  }) : super(key: key);

  final Uint8List bytes;
  final Duration duration;

  @override
  _SnapshotAnimationViewState createState() => _SnapshotAnimationViewState();
}

class _SnapshotAnimationViewState extends State<SnapshotAnimationView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween(begin: 1.0, end: 0.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Image.memory(widget.bytes),
    );
  }
}
