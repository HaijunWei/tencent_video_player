class MessageModel {
  MessageModel({
    required this.content,
    required this.nickname,
    required this.assistant,
    required this.position,
  });

  /// 消息内容
  final String content;

  /// 发送人
  final String nickname;

  /// 是否助教
  final bool assistant;

  /// 发送消息时的直播秒数
  final int position;
}
