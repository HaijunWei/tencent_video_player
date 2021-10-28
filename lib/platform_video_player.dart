import 'dart:ui';

import 'package:flutter/services.dart';

import 'messages.dart';

class VideoEvent {
  VideoEvent({
    required this.eventType,
    this.duration,
    this.position,
    this.buffered,
    this.size,
  });

  final VideoEventType eventType;

  /// 视频总时长
  final Duration? duration;

  /// 当前播放时长
  final Duration? position;

  /// 已缓冲长度
  final Duration? buffered;

  /// 视频分辨率
  final Size? size;
}

enum VideoEventType {
  /// 已加载到视频，可以开始播放了
  ready,

  /// 视频进度改变
  progressUpdate,

  /// 分辨率改变
  resolutionUpdate,

  /// 视频播放已结束
  ended,

  /// unknown
  unknown,
}

class PlatformVideoPlayer {
  static final PlatformVideoPlayer _instance = PlatformVideoPlayer();
  static PlatformVideoPlayer get instance => _instance;

  final TencentVideoPlayerApi _api = TencentVideoPlayerApi();

  Future<int?> create(PlayerType type) async {
    final msg = CreateMessage();
    msg.type = type;
    final result = await _api.create(msg);
    return result.textureId;
  }

  Future<void> play(
    int textureId, {
    String? uri,
    String? asset,
    String? packageName,
    LiveType liveType = LiveType.flv,
  }) async {
    return _api.play(
      PlayMessage()
        ..textureId = textureId
        ..uri = uri
        ..asset = asset
        ..packageName = packageName
        ..liveType = liveType,
    );
  }

  Future<void> pause(int textureId) {
    return _api.pause(TextureMessage()..textureId = textureId);
  }

  Future<void> resume(int textureId) {
    return _api.resume(TextureMessage()..textureId = textureId);
  }

  Future<void> stop(int textureId) {
    return _api.stop(TextureMessage()..textureId = textureId);
  }

  Future<void> seekTo(int textureId, int position) {
    return _api.seekTo(
      PositionMessage()
        ..textureId = textureId
        ..position = position,
    );
  }

  Future<void> setLooping(int textureId, bool isLooping) {
    return _api.setLooping(
      LoopingMessage()
        ..textureId = textureId
        ..isLooping = isLooping,
    );
  }

  Future<void> setVolume(int textureId, double volume) {
    return _api.setVolume(
      VolumeMessage()
        ..textureId = textureId
        ..volume = volume,
    );
  }

  Future<void> setPlaybackSpeed(int textureId, double speed) {
    return _api.setPlaybackSpeed(
      PlaybackSpeedMessage()
        ..textureId = textureId
        ..speed = speed,
    );
  }

  Future<String?> snapshot(int textureId) async {
    final result = await _api.snapshot(
      TextureMessage()..textureId = textureId,
    );
    return result.path;
  }

  Future<void> dispose(int textureId) async {
    return _api.dispose(TextureMessage()..textureId = textureId);
  }

  Stream<VideoEvent> videoEventsFor(int textureId) {
    return _eventChannelFor(textureId)
        .receiveBroadcastStream()
        .map((dynamic event) {
      final Map<dynamic, dynamic> map = event;
      switch (map['event']) {
        case 'ready':
          return VideoEvent(eventType: VideoEventType.ready);
        case 'resolutionUpdate':
          return VideoEvent(
            eventType: VideoEventType.resolutionUpdate,
            size: Size(
              map['width']?.toDouble() ?? 0.0,
              map['height']?.toDouble() ?? 0.0,
            ),
          );
        case 'progressUpdate':
          final position = map['position'] ?? 0;
          if (position < 0) {
            return VideoEvent(eventType: VideoEventType.unknown);
          }
          return VideoEvent(
            eventType: VideoEventType.progressUpdate,
            duration: Duration(milliseconds: map['duration'] ?? 0),
            position: Duration(milliseconds: position),
            buffered: Duration(milliseconds: map['buffered'] ?? 0),
          );
        case 'ended':
          return VideoEvent(eventType: VideoEventType.ended);
        default:
          return VideoEvent(eventType: VideoEventType.unknown);
      }
    });
  }

  EventChannel _eventChannelFor(int textureId) {
    return EventChannel(
        'com.haijunwei/tencentVideoPlayer/videoEvents$textureId');
  }
}
