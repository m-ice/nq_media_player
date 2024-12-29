import 'package:flutter_test/flutter_test.dart';
import 'package:nq_media_player/nq_media_player.dart';
import 'package:nq_media_player/nq_media_player_platform_interface.dart';
import 'package:nq_media_player/nq_media_player_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNqMediaPlayerPlatform
    with MockPlatformInterfaceMixin
    implements NqMediaPlayerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> isMusicOn() {
    // TODO: implement isMusicOn
    throw UnimplementedError();
  }

  @override
  Future<bool> lastMusic() {
    // TODO: implement lastMusic
    throw UnimplementedError();
  }

  @override
  // TODO: implement musicOn
  Stream<bool> get musicOn => throw UnimplementedError();

  @override
  Future<bool> nextMusic() {
    // TODO: implement nextMusic
    throw UnimplementedError();
  }

  @override
  Future<bool> switchMusicOn() {
    // TODO: implement switchMusicOn
    throw UnimplementedError();
  }
}

void main() {
  final NqMediaPlayerPlatform initialPlatform = NqMediaPlayerPlatform.instance;

  test('$MethodChannelNqMediaPlayer is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNqMediaPlayer>());
  });

  test('getPlatformVersion', () async {
    NqMediaPlayer nqMediaPlayerPlugin = NqMediaPlayer();
    MockNqMediaPlayerPlatform fakePlatform = MockNqMediaPlayerPlatform();
    NqMediaPlayerPlatform.instance = fakePlatform;

    expect(await nqMediaPlayerPlugin.getPlatformVersion(), '42');
  });
}
