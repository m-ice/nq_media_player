import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'nq_media_player_platform_interface.dart';

/// An implementation of [NqMediaPlayerPlatform] that uses method channels.
class MethodChannelNqMediaPlayer extends NqMediaPlayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('nq_media_player');
  @visibleForTesting
  final eventChannel = const EventChannel('nq_media_player/event');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> switchMusicOn() async{
    return await methodChannel.invokeMethod<bool>('switchMusicOn')??false;
  }

  @override
  Future<bool> isMusicOn() async{
    return await methodChannel.invokeMethod<bool>('isMusicOn')??false;
  }

  @override
  Future<bool> nextMusic() async{
    return await methodChannel.invokeMethod<bool>('nextMusic')??false;
  }

  @override
  Future<bool> lastMusic() async{
    return await methodChannel.invokeMethod<bool>('lastMusic')??false;
  }

  @override
  Stream<bool> get musicOn => eventChannel.receiveBroadcastStream()
      .map((event) => event as bool);

}
