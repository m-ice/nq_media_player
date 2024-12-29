import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'nq_media_player_method_channel.dart';

abstract class NqMediaPlayerPlatform extends PlatformInterface {
  /// Constructs a NqMediaPlayerPlatform.
  NqMediaPlayerPlatform() : super(token: _token);

  static final Object _token = Object();

  static NqMediaPlayerPlatform _instance = MethodChannelNqMediaPlayer();

  /// The default instance of [NqMediaPlayerPlatform] to use.
  ///
  /// Defaults to [MethodChannelNqMediaPlayer].
  static NqMediaPlayerPlatform get instance => _instance;


  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NqMediaPlayerPlatform] when
  /// they register themselves.
  static set instance(NqMediaPlayerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> switchMusicOn() {
    throw UnimplementedError('switchMusicOn() has not been implemented.');
  }

  Future<bool> isMusicOn() {
    throw UnimplementedError('isMusicOn() has not been implemented.');
  }

  Future<bool> nextMusic() {
    throw UnimplementedError('nextMusic() has not been implemented.');
  }

  Future<bool> lastMusic() {
    throw UnimplementedError('lastMusic() has not been implemented.');
  }

  Stream<bool> get musicOn {
    throw UnimplementedError('get isMusicOn has not been implemented.');
  }
}
