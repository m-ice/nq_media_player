import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nq_media_player/nq_media_player_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelNqMediaPlayer platform = MethodChannelNqMediaPlayer();
  const MethodChannel channel = MethodChannel('nq_media_player');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
