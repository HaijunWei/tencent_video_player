import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../super_player/super_player.dart';
import '../super_player_pro_controller.dart';

class LiveChatContainer extends StatelessWidget {
  const LiveChatContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFullScreen = context
        .select((SuperPlayerController controller) => controller.isFullScreen);
    if (!isFullScreen) return const SizedBox();
    return GetX<SuperPlayerProController>(
      builder: (controller) {
        final showChat = controller.showChat.value;
        const chatWidth = 200.0;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: showChat ? chatWidth : 0,
          color: Colors.white,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                right: showChat ? 0 : -chatWidth,
                top: 0,
                bottom: 0,
                width: chatWidth,
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.speaker_notes,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  '魏老师',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                      ],
                    ),
                    const LiveChatTabBar(),
                    Expanded(
                      child: TabBarView(
                        controller:
                            Get.find<SuperPlayerProController>().tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          const LiveChatListView(),
                          Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class LiveChatTabBar extends StatelessWidget {
  const LiveChatTabBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: GetX<SuperPlayerProController>(builder: (controller) {
            final inChatList = controller.tabIndex.value == 0;
            final activeColor = Theme.of(context).primaryColor;
            final unactiveColor = Colors.grey;
            final boxShadow = [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                blurRadius: 1,
              )
            ];

            return TabBar(
              controller: controller.tabController,
              labelPadding: EdgeInsets.zero,
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 30),
              tabs: [
                GestureDetector(
                  onTap: inChatList
                      ? () {
                          controller.messageOptionVisible.toggle();
                        }
                      : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: inChatList ? boxShadow : null,
                        ),
                        child: Icon(
                          Icons.messenger,
                          color: inChatList ? activeColor : unactiveColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        controller.onlyShowTeacherMessage.value ? '老师' : '聊天',
                        style: TextStyle(
                          fontSize: 12,
                          color: inChatList ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Transform.rotate(
                        angle:
                            controller.messageOptionVisible.value ? math.pi : 0,
                        child: Icon(
                          Icons.arrow_drop_down_rounded,
                          size: 18,
                          color: inChatList ? activeColor : unactiveColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: !inChatList ? boxShadow : null,
                      ),
                      child: Icon(
                        Icons.message,
                        color: !inChatList ? activeColor : unactiveColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '发言',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: !inChatList ? activeColor : unactiveColor,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

class LiveChatListView extends StatelessWidget {
  const LiveChatListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 25,
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              alignment: Alignment.center,
              child: Text(
                '100人在线',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                padding: const EdgeInsets.only(top: 5),
                itemBuilder: (context, index) {
                  return LiveChatTile();
                },
              ),
            ),
          ],
        ),
        const _MessageOption(),
      ],
    );
  }
}

class _MessageOption extends StatelessWidget {
  const _MessageOption({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<SuperPlayerProController>(builder: (controller) {
      if (!controller.messageOptionVisible.value) return const SizedBox();
      final selectedColor = Theme.of(context).primaryColor;

      return GestureDetector(
        onTap: () {
          controller.messageOptionVisible.value = false;
        },
        child: Container(
          color: Colors.black.withOpacity(0.5),
          alignment: AlignmentDirectional.topCenter,
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.updateMessageOption(onlyTeacher: false);
                  },
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    color: controller.onlyShowTeacherMessage.value
                        ? Colors.white
                        : selectedColor.withOpacity(0.1),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '全部聊天',
                            style: TextStyle(
                              fontSize: 12,
                              color: controller.onlyShowTeacherMessage.value
                                  ? null
                                  : selectedColor,
                            ),
                          ),
                        ),
                        Offstage(
                          offstage: controller.onlyShowTeacherMessage.value,
                          child: Icon(
                            Icons.done_rounded,
                            size: 15,
                            color: selectedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.updateMessageOption(onlyTeacher: true);
                  },
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    color: !controller.onlyShowTeacherMessage.value
                        ? Colors.white
                        : selectedColor.withOpacity(0.1),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '只看老师',
                            style: TextStyle(
                              fontSize: 12,
                              color: controller.onlyShowTeacherMessage.value
                                  ? Theme.of(context).primaryColor
                                  : null,
                            ),
                          ),
                        ),
                        Offstage(
                          offstage: !controller.onlyShowTeacherMessage.value,
                          child: Icon(
                            Icons.done_rounded,
                            size: 15,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class LiveChatTile extends StatelessWidget {
  const LiveChatTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(fontSize: 13),
          children: [
            WidgetSpan(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                margin: const EdgeInsets.only(right: 3),
                child: const Text(
                  '助教',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            TextSpan(
              text: '海军: ',
              style: TextStyle(
                color: const Color(0xFF999999),
              ),
            ),
            TextSpan(text: '不错，容易懂')
          ],
        ),
      ),
    );
  }
}
