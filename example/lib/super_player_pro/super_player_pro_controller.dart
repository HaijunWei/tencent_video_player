import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../super_player/super_player_controller.dart';
import 'models/mark_model.dart';
import 'widgets/mark.dart';

class SuperPlayerProController extends GetxController
    with SingleGetTickerProviderMixin {
  SuperPlayerProController({
    required this.controller,
  }) {
    controller.addListener(() {
      if (_showControls != controller.showVideoControls) {
        _showControls = controller.showVideoControls;
        if (!_showControls) {
          _hideMarkMenu();
        }
      }
    });
  }

  final SuperPlayerController controller;
  late TabController tabController;

  final marks = <MarkModel>[].obs;
  final showChat = true.obs;
  final tabIndex = 0.obs;
  final messageOptionVisible = false.obs;
  final onlyShowTeacherMessage = false.obs;

  GlobalKey markButtonKey = GlobalKey();

  bool _isShowedMarkMenu = false;
  bool _showControls = false;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(() {
      tabIndex.value = tabController.index;
      messageOptionVisible.value = false;
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void showOrHideMarkMenu() async {
    if (_isShowedMarkMenu) {
      _hideMarkMenu();
    } else {
      _isShowedMarkMenu = true;
      final renderBox =
          markButtonKey.currentContext?.findRenderObject() as RenderBox;
      final offset = renderBox.localToGlobal(const Offset(-110, 0));
      controller.insertOverlay(
        'MarkMenuView',
        MarkMenuView(
          offset: offset,
        ),
      );
      controller.cancelAutoHideControls();
    }
  }

  void _hideMarkMenu() {
    _isShowedMarkMenu = false;
    controller.removeOverlay('MarkMenuView');
  }

  /// 添加标记
  /// 0 = 疑问，1 = 重点，2 = 自定义
  void addMark(BuildContext context, int type) async {
    final position = controller.playerController.value.position.inSeconds;
    final index = marks.indexWhere((e) => e.position == position);
    if (index != -1) {
      controller.showToast('频繁标记不利于记录哦～');
      return;
    }
    final image = await controller.snapshot(context, onlyVideo: true);

    if (type == 2) {
      const textFiled = CustomMarkTextFiled();
      final content = await textFiled.show(context);
      if (content == null || content.isEmpty) return;
      marks.add(MarkModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: type,
        position: position,
        thumb: '',
      )..content.value = content);
    } else {
      marks.add(MarkModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: type,
        position: position,
        thumb: '',
      ));
    }
    marks.sort((a, b) => a.position.compareTo(b.position));
    controller.showToast('标记成功');
    controller.setProgressMarks(marks.map((e) => e.position * 1000).toList());
  }

  /// 删除标记
  void deleteMark(MarkModel model) {
    marks.remove(model);
    controller.setProgressMarks(marks.map((e) => e.position * 1000).toList());
  }

  /// 编辑标记
  void editMark(BuildContext context, MarkModel model) async {
    final textFiled = CustomMarkTextFiled(
      content: model.content.value,
    );
    final content = await textFiled.show(context);
    if (content == null || content.isEmpty) return;
    model.content.value = content;
  }

  void updateMessageOption({bool onlyTeacher = false}) {
    onlyShowTeacherMessage.value = onlyTeacher;
    // 过滤消息
  }
}
