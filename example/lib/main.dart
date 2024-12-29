import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nq_media_player/nq_media_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NQ Media Player Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const MediaControlPage(),
    );
  }
}

class MediaControlPage extends StatefulWidget {
  const MediaControlPage({Key? key}) : super(key: key);

  @override
  State<MediaControlPage> createState() => _MediaControlPageState();
}

class _MediaControlPageState extends State<MediaControlPage>
    with SingleTickerProviderStateMixin {
  final NqMediaPlayer _player = NqMediaPlayer();
  bool _isPlaying = false;
  late AnimationController _animationController;
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _initPlatformState();
    _checkInitialMusicState();
    _setupMusicListener();
  }

  Future<void> _initPlatformState() async {
    String platformVersion;
    try {
      platformVersion =
          await _player.getPlatformVersion() ?? 'Unknown platform version';
    } catch (e) {
      platformVersion = 'Failed to get platform version';
    }
    if (!mounted) return;
    setState(() => _platformVersion = platformVersion);
  }

  Future<void> _checkInitialMusicState() async {
    try {
      final bool isPlaying = await _player.isMusicOn();
      if (mounted) {
        setState(() => _isPlaying = isPlaying);
        if (isPlaying) {
          _animationController.forward();
        }
      }
    } catch (e) {
      debugPrint('Error checking initial music state: $e');
    }
  }

  void _setupMusicListener() {
    _player.musicStateStream.listen(
      (bool isPlaying) {
        if (mounted) {
          setState(() => _isPlaying = isPlaying);
          if (isPlaying) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
        }
      },
      onError: (error) {
        debugPrint('Error in music state stream: $error');
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.greenAccent,
        systemNavigationBarDividerColor: Colors.greenAccent,
        systemStatusBarContrastEnforced: true,
        systemNavigationBarContrastEnforced: false,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade900,
                Colors.purple.shade900,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const Spacer(),
                _buildMusicControls(),
                const Spacer(),
                _buildPlatformInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Text(
            'NQ Media Player',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Music Control Demo',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMusicStatusIndicator(),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildControlButton(
              icon: Icons.skip_previous,
              onPressed: () => _player.lastMusic(),
            ),
            const SizedBox(width: 20),
            _buildPlayPauseButton(),
            const SizedBox(width: 20),
            _buildControlButton(
              icon: Icons.skip_next,
              onPressed: () => _player.nextMusic(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMusicStatusIndicator() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.purple.shade400],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
          child: Icon(
            _isPlaying ? Icons.music_note : Icons.music_off,
            size: 80,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    return GestureDetector(
      onTap: () async {
        try {
          await _player.switchMusicOn();
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error controlling playback: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          _isPlaying ? Icons.pause : Icons.play_arrow,
          size: 40,
          color: Colors.blue.shade900,
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: () async {
        try {
           onPressed();
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error controlling playback: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
        ),
        child: Icon(
          icon,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPlatformInfo() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.info_outline,
            color: Colors.white70,
          ),
          const SizedBox(width: 10),
          Text(
            'Platform: $_platformVersion',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
