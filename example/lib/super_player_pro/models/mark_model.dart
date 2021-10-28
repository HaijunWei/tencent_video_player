import 'package:get/get.dart';

class MarkModel {
  MarkModel({
    required this.id,
    required this.type,
    required this.position,
    required this.thumb,
  });

  final String id;

  /// 标记类型 0 = 疑问，1 = 重点，2 = 自定义
  final int type;

  String get typeString {
    switch (type) {
      case 0:
        return '疑问';
      case 1:
        return '重点';
      default:
        return '自定义';
    }
  }

  /// 标记时间，单位 秒
  final int position;

  /// 标记自定义内容
  final content = ''.obs;

  /// 标记预览图
  final String thumb;
}
