import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tencent_video_player_example/super_player/utils/format_utils.dart';
import 'package:tencent_video_player_example/super_player_pro/models/mark_model.dart';
import '../../../super_player/super_player.dart';
import '../super_player_pro_controller.dart';

class MarkListButton extends StatefulWidget {
  const MarkListButton({
    Key? key,
  }) : super(key: key);

  @override
  State<MarkListButton> createState() => _MarkListButtonState();
}

class _MarkListButtonState extends State<MarkListButton>
    with TickerProviderStateMixin {
  void _onTap(BuildContext context) {
    final controller = context.read<SuperPlayerController>();
    if (controller.showVideoControls) controller.hideControls();

    final animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    final animation = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(animationController);
    final panel = MarkListPanel(
      animation: animation,
      onClose: () async {
        await animationController.reverse();
        controller.removeOverlay('settingPanel');
      },
    );
    controller.insertOverlay('settingPanel', panel);
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Image.asset(
        'assets/images/ic_player_mark_list.png',
        width: 20,
      ),
      onPressed: () => _onTap(context),
    );
  }
}

class MarkListPanel extends StatelessWidget {
  const MarkListPanel({
    Key? key,
    required this.animation,
    required this.onClose,
  }) : super(key: key);

  final Animation<Offset> animation;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.transparent,
        alignment: Alignment.centerRight,
        child: SlideTransition(
          position: animation,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              color: Colors.black.withOpacity(0.85),
              child: SafeArea(
                left: false,
                top: false,
                bottom: false,
                child: SizedBox(
                  width: 230,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: [
                            Text(
                              '标记',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              height: 3,
                              width: 20,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Builder(builder: (context) {
                          return GetX<SuperPlayerProController>(
                              builder: (controller) {
                            final marks = controller.marks;
                            return ListView.builder(
                              itemCount: marks.length,
                              itemBuilder: (BuildContext context, int index) {
                                return MarkTile(
                                  mark: marks[index],
                                  needTopLine: index != 0,
                                  needBottomLine: index != marks.length - 1,
                                  onDelete: () {
                                    controller.deleteMark(marks[index]);
                                  },
                                  onTap: () {
                                    context
                                        .read<SuperPlayerController>()
                                        .playerController
                                        .seekTo(marks[index].position);
                                    onClose();
                                  },
                                  onEdit: () {
                                    controller.editMark(context, marks[index]);
                                  },
                                );
                              },
                            );
                          });
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MarkTile extends StatefulWidget {
  const MarkTile({
    Key? key,
    required this.mark,
    required this.needTopLine,
    required this.needBottomLine,
    this.onDelete,
    this.onTap,
    this.onEdit,
  }) : super(key: key);

  final MarkModel mark;
  final bool needTopLine;
  final bool needBottomLine;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  @override
  State<MarkTile> createState() => _MarkTileState();
}

class _MarkTileState extends State<MarkTile> {
  bool _isDeleting = false;
  bool _isExpended = false;
  bool _needExpended = false;
  final _maxWordCount = 30;

  void _delete() {
    _isDeleting = !_isDeleting;
    setState(() {});
  }

  void _cancelDelete() {
    _isDeleting = false;
    setState(() {});
  }

  void _ensureDelete() {
    if (widget.onDelete != null) {
      widget.onDelete!();
    }
  }

  @override
  void didUpdateWidget(covariant MarkTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      _isDeleting = false;
      _isExpended = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Visibility(
                visible: widget.needTopLine,
                maintainState: true,
                maintainSize: true,
                maintainAnimation: true,
                child: Container(
                  width: 1,
                  height: 11,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(5),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              Expanded(
                child: Visibility(
                  visible: widget.needBottomLine,
                  child: Container(
                    width: 1,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 20),
          child: Stack(
            children: [
              Obx(() {
                var content = widget.mark.content.value;
                if (!_isExpended && content.length > 30) {
                  content = content.substring(0, 30) + '…';
                }
                final needExpended =
                    widget.mark.content.value.length > _maxWordCount;

                return Offstage(
                  offstage: content.isEmpty,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const AspectRatio(
                        aspectRatio: 16 / 9,
                        child: SizedBox(),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(8, 15, 8, 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(8),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isExpended = !_isExpended;
                            });
                          },
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.5,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              children: [
                                TextSpan(text: content),
                                if (needExpended)
                                  WidgetSpan(
                                    child: Icon(
                                      _isExpended
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down,
                                      size: 20,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.play_circle,
                        color: Colors.white.withOpacity(0.5),
                        size: 15,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        formatTime(widget.mark.position),
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'din',
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      const Spacer(),
                      Offstage(
                        offstage: widget.mark.type != 2,
                        child: Row(
                          children: [
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              minSize: 30,
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.edit,
                                color: Colors.white.withOpacity(0.5),
                                size: 16,
                              ),
                              onPressed: () {
                                if (widget.onEdit != null) widget.onEdit!();
                              },
                            ),
                            Container(
                              width: 1,
                              height: 10,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 30,
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.delete_forever,
                          color: Colors.white.withOpacity(0.5),
                          size: 20,
                        ),
                        onPressed: _delete,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              color: Colors.red,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                ),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFFB743),
                                    Color(0xFFFF9619),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFFF9619),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  )
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              child: Text(
                                widget.mark.typeString,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Offstage(
                              offstage: !_isDeleting,
                              child: Container(
                                color: Colors.black.withOpacity(0.3),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF6F6F6),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          '取消',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      onPressed: _cancelDelete,
                                    ),
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          '确定',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      onPressed: _ensureDelete,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class MarkMenuView extends StatelessWidget {
  const MarkMenuView({
    Key? key,
    required this.offset,
  }) : super(key: key);

  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return AutoHideContainer(
      child: Stack(
        children: [
          Positioned(
            left: offset.dx,
            bottom: offset.dy - 65,
            child: Container(
              width: 100,
              decoration: ShapeDecoration(
                shape: MarkMenuBorder(),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MarkMenuTile(
                    title: '疑问',
                    icon: Icons.question_answer,
                    onTap: () {
                      Get.find<SuperPlayerProController>().addMark(context, 0);
                    },
                  ),
                  MarkMenuTile(
                    title: '重点',
                    icon: Icons.important_devices,
                    onTap: () {
                      Get.find<SuperPlayerProController>().addMark(context, 1);
                    },
                  ),
                  MarkMenuTile(
                    title: '自定义',
                    icon: Icons.dashboard_customize,
                    onTap: () {
                      Get.find<SuperPlayerProController>().addMark(context, 2);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MarkMenuTile extends StatelessWidget {
  const MarkMenuTile({
    Key? key,
    required this.title,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}

class MarkMenuBorder extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(rect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(rect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()..color = Colors.black.withOpacity(0.8);
    final path = _getPath(rect);

    canvas.drawPath(path, paint);
  }

  @override
  ShapeBorder scale(double t) {
    return this;
  }

  Path _getPath(Rect rect) {
    final path = Path();
    const rightSpacing = 6.0;
    const arrowHeight = 10.0;
    const bottomSpacing = 20.0;

    path.addRRect(
      RRect.fromLTRBR(
        rect.left,
        rect.top,
        rect.right - rightSpacing,
        rect.bottom,
        const Radius.circular(5),
      ),
    );
    path.moveTo(rect.right - rightSpacing, rect.bottom - bottomSpacing);
    path.cubicTo(
      rect.right - rightSpacing,
      rect.bottom - bottomSpacing,
      rect.right,
      rect.bottom - bottomSpacing - arrowHeight * 0.5 + arrowHeight * 0.2,
      rect.right,
      rect.bottom - bottomSpacing - arrowHeight * 0.5,
    );

    path.cubicTo(
      rect.right,
      rect.bottom - bottomSpacing - arrowHeight * 0.5 - arrowHeight * 0.2,
      rect.right - rightSpacing,
      rect.bottom - bottomSpacing - arrowHeight,
      rect.right - rightSpacing,
      rect.bottom - bottomSpacing - arrowHeight,
    );
    return path;
  }
}

class CustomMarkTextFiled extends StatefulWidget {
  const CustomMarkTextFiled({
    Key? key,
    this.content,
  }) : super(key: key);

  final String? content;

  Future<String?> show(BuildContext context) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: this,
        );
      },
    );
  }

  @override
  State<CustomMarkTextFiled> createState() => _CustomMarkTextFiledState();
}

class _CustomMarkTextFiledState extends State<CustomMarkTextFiled> {
  late TextEditingController _editingController;
  final int _maxWordCount = 250;
  int _wordCount = 0;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: widget.content);
    _editingController.addListener(() {
      _wordCount = _editingController.text.length;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.1),
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        behavior: HitTestBehavior.translucent,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: SafeArea(
              top: false,
              bottom: false,
              child: Row(children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _editingController,
                            autofocus: true,
                            textInputAction: TextInputAction.done,
                            minLines: 1,
                            maxLines: 5,
                            scrollPadding: EdgeInsets.zero,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            keyboardAppearance: Brightness.light,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(_maxWordCount),
                            ],
                            onEditingComplete: () {
                              Navigator.of(context)
                                  .pop(_editingController.text);
                            },
                          ),
                        ),
                        Text(
                          '${_maxWordCount - _wordCount}',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'din',
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CupertinoButton(
                  minSize: 35,
                  borderRadius: BorderRadius.circular(5),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    _wordCount > 0 ? '确定' : '取消',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(_editingController.text);
                  },
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
