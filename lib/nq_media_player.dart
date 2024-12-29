import 'dart:async';
import 'package:flutter/services.dart';
import 'nq_media_player_platform_interface.dart';

class NqMediaPlayer {
  static const MethodChannel _channel = MethodChannel('nq_media_player');
  static const EventChannel _eventChannel =
      EventChannel('nq_media_player/event');

  // 公开的 Stream getter
  Stream<bool> get musicStateStream => _eventChannel
      .receiveBroadcastStream()
      .map<bool>((dynamic event) => event as bool);

  factory NqMediaPlayer() {
    _singleton ??= NqMediaPlayer._();
    return _singleton!;
  }

  NqMediaPlayer._();

  static NqMediaPlayer? _singleton;

  static NqMediaPlayerPlatform get _platform {
    return NqMediaPlayerPlatform.instance;
  }

  Future<String?> getPlatformVersion() async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<void> switchMusicOn() async {
    await _channel.invokeMethod('switchMusicOn');
  }

  Future<bool> isMusicOn() async {
    final bool isOn = await _channel.invokeMethod('isMusicOn');
    return isOn;
  }

  Future<void> nextMusic() async {
    await _channel.invokeMethod('nextMusic');
  }

  Future<void> lastMusic() async {
    await _channel.invokeMethod('lastMusic');
  }

  Stream<bool> get musicOn => _platform.musicOn;
}
