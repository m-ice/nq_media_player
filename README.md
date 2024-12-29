# nq_media_player

A flutter plugin that uses key commands to play and pause the music player of the mobile phone system and switch between the top and bottom songs.

![Static Badge](https://img.shields.io/badge/packages-nq_media_player-lightgreen?labelColor=grey&color=purple&link=https://github.com/m-ice/nq_media_player.git) ![Static Badge](https://img.shields.io/badge/version-1.0.0-lightgreen?labelColor=grey&color=lightgreen&link=https%3A%2F%2Fgithub.com%2Fm-ice%2Fflutter_mi_code.git)![Static Badge](https://img.shields.io/badge/LICENSE-MIT-lightgreen?labelColor=grey&color=orange&link=https://github.com/m-ice/nq_media_player/blob/master/LICENSE) [![Flutter.io](https://img.shields.io/badge/Flutter-Website-deepskyblue.svg)](https://flutter.io/)

## Features

## 

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
