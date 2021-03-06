// Autogenerated from Pigeon (v1.0.8), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name
// @dart = 2.12
import 'dart:async';
import 'dart:typed_data' show Uint8List, Int32List, Int64List, Float64List;

import 'package:flutter/foundation.dart' show WriteBuffer, ReadBuffer;
import 'package:flutter/services.dart';

enum PlayerType {
  vod,
  live,
}

enum LiveType {
  rtmp,
  flv,
}

class TextureMessage {
  int? textureId;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['textureId'] = textureId;
    return pigeonMap;
  }

  static TextureMessage decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return TextureMessage()
      ..textureId = pigeonMap['textureId'] as int?;
  }
}

class CreateMessage {
  PlayerType? type;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['type'] = type == null ? null : type!.index;
    return pigeonMap;
  }

  static CreateMessage decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return CreateMessage()
      ..type = pigeonMap['type'] != null
          ? PlayerType.values[pigeonMap['type']! as int]
          : null;
  }
}

class PlayMessage {
  int? textureId;
  LiveType? liveType;
  String? uri;
  String? asset;
  String? packageName;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['textureId'] = textureId;
    pigeonMap['liveType'] = liveType == null ? null : liveType!.index;
    pigeonMap['uri'] = uri;
    pigeonMap['asset'] = asset;
    pigeonMap['packageName'] = packageName;
    return pigeonMap;
  }

  static PlayMessage decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return PlayMessage()
      ..textureId = pigeonMap['textureId'] as int?
      ..liveType = pigeonMap['liveType'] != null
          ? LiveType.values[pigeonMap['liveType']! as int]
          : null
      ..uri = pigeonMap['uri'] as String?
      ..asset = pigeonMap['asset'] as String?
      ..packageName = pigeonMap['packageName'] as String?;
  }
}

class LoopingMessage {
  int? textureId;
  bool? isLooping;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['textureId'] = textureId;
    pigeonMap['isLooping'] = isLooping;
    return pigeonMap;
  }

  static LoopingMessage decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return LoopingMessage()
      ..textureId = pigeonMap['textureId'] as int?
      ..isLooping = pigeonMap['isLooping'] as bool?;
  }
}

class VolumeMessage {
  int? textureId;
  double? volume;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['textureId'] = textureId;
    pigeonMap['volume'] = volume;
    return pigeonMap;
  }

  static VolumeMessage decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return VolumeMessage()
      ..textureId = pigeonMap['textureId'] as int?
      ..volume = pigeonMap['volume'] as double?;
  }
}

class PlaybackSpeedMessage {
  int? textureId;
  double? speed;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['textureId'] = textureId;
    pigeonMap['speed'] = speed;
    return pigeonMap;
  }

  static PlaybackSpeedMessage decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return PlaybackSpeedMessage()
      ..textureId = pigeonMap['textureId'] as int?
      ..speed = pigeonMap['speed'] as double?;
  }
}

class PositionMessage {
  int? textureId;
  int? position;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['textureId'] = textureId;
    pigeonMap['position'] = position;
    return pigeonMap;
  }

  static PositionMessage decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return PositionMessage()
      ..textureId = pigeonMap['textureId'] as int?
      ..position = pigeonMap['position'] as int?;
  }
}

class SnapshotMessage {
  String? path;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['path'] = path;
    return pigeonMap;
  }

  static SnapshotMessage decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return SnapshotMessage()
      ..path = pigeonMap['path'] as String?;
  }
}

class _TencentVideoPlayerApiCodec extends StandardMessageCodec {
  const _TencentVideoPlayerApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is CreateMessage) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else 
    if (value is LoopingMessage) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else 
    if (value is PlayMessage) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else 
    if (value is PlaybackSpeedMessage) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else 
    if (value is PositionMessage) {
      buffer.putUint8(132);
      writeValue(buffer, value.encode());
    } else 
    if (value is SnapshotMessage) {
      buffer.putUint8(133);
      writeValue(buffer, value.encode());
    } else 
    if (value is TextureMessage) {
      buffer.putUint8(134);
      writeValue(buffer, value.encode());
    } else 
    if (value is VolumeMessage) {
      buffer.putUint8(135);
      writeValue(buffer, value.encode());
    } else 
{
      super.writeValue(buffer, value);
    }
  }
  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:       
        return CreateMessage.decode(readValue(buffer)!);
      
      case 129:       
        return LoopingMessage.decode(readValue(buffer)!);
      
      case 130:       
        return PlayMessage.decode(readValue(buffer)!);
      
      case 131:       
        return PlaybackSpeedMessage.decode(readValue(buffer)!);
      
      case 132:       
        return PositionMessage.decode(readValue(buffer)!);
      
      case 133:       
        return SnapshotMessage.decode(readValue(buffer)!);
      
      case 134:       
        return TextureMessage.decode(readValue(buffer)!);
      
      case 135:       
        return VolumeMessage.decode(readValue(buffer)!);
      
      default:      
        return super.readValueOfType(type, buffer);
      
    }
  }
}

class TencentVideoPlayerApi {
  /// Constructor for [TencentVideoPlayerApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  TencentVideoPlayerApi({BinaryMessenger? binaryMessenger}) : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _TencentVideoPlayerApiCodec();

  Future<TextureMessage> create(CreateMessage arg_msg) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.TencentVideoPlayerApi.create', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object>[arg_msg]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return (replyMap['result'] as TextureMessage?)!;
    }
  }

  Future<void> play(PlayMessage arg_msg) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.TencentVideoPlayerApi.play', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object>[arg_msg]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> resume(TextureMessage arg_msg) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.TencentVideoPlayerApi.resume', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object>[arg_msg]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> pause(TextureMessage arg_msg) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.TencentVideoPlayerApi.pause', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object>[arg_msg]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> stop(TextureMessage arg_msg) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.TencentVideoPlayerApi.stop', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object>[arg_msg]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> seekTo(PositionMessage arg_msg) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.TencentVideoPlayerApi.seekTo', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object>[arg_msg]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> setLooping(LoopingMessage arg_msg) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.TencentVideoPlayerApi.setLooping', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object>[arg_msg]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> setVolume(VolumeMessage arg_msg) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.TencentVideoPlayerApi.setVolume', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object>[arg_msg]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> setPlaybackSpeed(PlaybackSpeedMessage arg_msg) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.TencentVideoPlayerApi.setPlaybackSpeed', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object>[arg_msg]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<SnapshotMessage> snapshot(TextureMessage arg_msg) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.TencentVideoPlayerApi.snapshot', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object>[arg_msg]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return (replyMap['result'] as SnapshotMessage?)!;
    }
  }

  Future<void> dispose(TextureMessage arg_msg) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.TencentVideoPlayerApi.dispose', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object>[arg_msg]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }
}
