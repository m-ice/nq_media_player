# nq_media_player

A flutter plugin that uses key commands to play and pause the music player of the mobile phone system and switch between the top and bottom songs.

## Features

You can use this plug-in to switch the top and bottom of the mobile phone system player, play and pause, and monitor the playback status.

## Getting started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/to/develop-plugins),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Usage

- Get plugin instance

```dart
  final NqMediaPlayer _player = NqMediaPlayer();
```

- Check initial music state

```dart
  Future<void> _checkInitialMusicState() async {
    try {
      final bool isPlaying = await _player.isMusicOn();
      if (mounted) {
        setState(() => _isPlaying = isPlaying);
      }
    } catch (e) {
      debugPrint('Error checking initial music state: $e');
    }
  }
```

- Setup music listene

```dart
  void _setupMusicListener() {
    _player.musicStateStream.listen(
      (bool isPlaying) {
        if (mounted) {
          setState(() => _isPlaying = isPlaying);
        }
      },
      onError: (error) {
        debugPrint('Error in music state stream: $error');
      },
    );
  }
```

- Switch the home page up and down

```dart
_player.lastMusic();
_player.nextMusic();
```



## Additional information

More information about this [package](https://github.com/m-ice/nq_media_player)
