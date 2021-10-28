import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/messages.dart',
  objcHeaderOut: 'ios/Classes/messages.h',
  objcSourceOut: 'ios/Classes/messages.m',
  objcOptions: ObjcOptions(prefix: 'HJ'),
  javaOut:
      'android/src/main/java/com/haijunwei/tencent_video_player/Messages.java',
  javaOptions: JavaOptions(package: 'com.haijunwei.tencent_video_player'),
))
class TextureMessage {
  late int textureId;
}

enum PlayerType { vod, live }

enum LiveType { rtmp, flv }

class CreateMessage {
  late PlayerType type;
}

class PlayMessage {
  late int textureId;
  late LiveType liveType;
  String? uri;
  String? asset;
  String? packageName;
}

class LoopingMessage {
  late int textureId;
  late bool isLooping;
}

class VolumeMessage {
  late int textureId;
  late double volume;
}

class PlaybackSpeedMessage {
  late int textureId;
  late double speed;
}

class PositionMessage {
  late int textureId;
  late int position;
}

class SnapshotMessage {
  late String path;
}

@HostApi()
abstract class TencentVideoPlayerApi {
  TextureMessage create(CreateMessage msg);
  void play(PlayMessage msg);
  void resume(TextureMessage msg);
  void pause(TextureMessage msg);
  void stop(TextureMessage msg);
  void seekTo(PositionMessage msg);
  void setLooping(LoopingMessage msg);
  void setVolume(VolumeMessage msg);
  void setPlaybackSpeed(PlaybackSpeedMessage msg);
  @async
  SnapshotMessage snapshot(TextureMessage msg);
  void dispose(TextureMessage msg);
}
