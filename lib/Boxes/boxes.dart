import 'package:hive/hive.dart';
import 'package:store_data/Model/notes_model.dart';

class Boxes {
  static Box<NotesModel> getData() => Hive.box('notes');
}
////YT

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:miniplayer/miniplayer.dart';

void main() {
  runApp(VideoDemoApp());
}

class VideoDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VideoListScreen(),
    );
  }
}

class VideoListScreen extends StatefulWidget {
  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  VideoPlayerController? _controller;
  Video? _currentVideo;
  final MiniplayerController _miniplayerController = MiniplayerController();
  final double _playerMinHeight = 70.0;

  void _playVideo(Video video) {
    setState(() {
      _currentVideo = video;
      _controller = VideoPlayerController.network(video.url)
        ..initialize().then((_) {
          setState(() {});
          _controller!.play();
        });
    });
    _miniplayerController.animateToHeight(state: PanelState.MAX);
  }

  void _closeMiniPlayer() {
    setState(() {
      _controller?.dispose();
      _controller = null;
      _currentVideo = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Demo'),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: videoList.length,
            itemBuilder: (context, index) {
              final video = videoList[index];
              return ListTile(
                title: Text(video.title),
                onTap: () => _playVideo(video),
              );
            },
          ),
          if (_controller != null && _currentVideo != null)
            Miniplayer(
              controller: _miniplayerController,
              minHeight: _playerMinHeight,
              maxHeight: MediaQuery.of(context).size.height,
              builder: (height, percentage) {
                if (height <= _playerMinHeight + 50) {
                  return Container(
                    color: Colors.black,
                    child: Row(
                      children: [
                        _controller!.value.isInitialized
                            ? AspectRatio(
                                aspectRatio: _controller!.value.aspectRatio,
                                child: VideoPlayer(_controller!),
                              )
                            : Center(child: CircularProgressIndicator()),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              _currentVideo!.title,
                              style: TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.close, color: Colors.white),
                              onPressed: _closeMiniPlayer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return FullScreenVideoPlayer(
                    video: _currentVideo!,
                    controller: _controller!,
                    miniplayerController: _miniplayerController,
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final Video video;
  final VideoPlayerController controller;
  final MiniplayerController miniplayerController;

  FullScreenVideoPlayer({
    required this.video,
    required this.controller,
    required this.miniplayerController,
  });

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > 0) {
          widget.miniplayerController.animateToHeight(state: PanelState.MIN);
        }
      },
      child: Scaffold(
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : CircularProgressIndicator(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }
}

class Video {
  final String title;
  final String url;

  Video({required this.title, required this.url});
}

List<Video> videoList = [
  Video(
    title: "The Valley",
    url:
        "https://mazwai.com/videvo_files/video/free/2016-04/small_watermarked/the_valley-graham_uheslki_preview.webm",
  ),
  Video(
    title: "Taksin Bridge",
    url:
        "https://mazwai.com/videvo_files/video/free/2019-01/small_watermarked/190111_04_TaksinBridge_Drone_06_preview.webm",
  ),
  Video(
    title: "Wat Arun Temple",
    url:
        "https://mazwai.com/videvo_files/video/free/2019-02/small_watermarked/190111_03_WatArunTemple_Drone_02_preview.webm",
  ),
];

//Second

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:miniplayer/miniplayer.dart';

void main() {
  runApp(VideoDemoApp());
}

class VideoDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VideoListScreen(),
    );
  }
}

class VideoListScreen extends StatefulWidget {
  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  VideoPlayerController? _controller;
  Video? _currentVideo;
  final MiniplayerController _miniplayerController = MiniplayerController();
  final double _playerMinHeight = 70.0;
  bool _isVideoPlaying = false;

  void _playVideo(Video video) {
    setState(() {
      _currentVideo = video;
      _controller = VideoPlayerController.network(video.url)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isVideoPlaying = true;
              _controller!.play();
            });
            Future.delayed(Duration(milliseconds: 300), () {
              if (mounted) {
                _miniplayerController.animateToHeight(state: PanelState.MAX);
              }
            });
          }
        });
    });
  }

  void _closeMiniPlayer() {
    setState(() {
      _controller?.dispose();
      _controller = null;
      _currentVideo = null;
      _isVideoPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Demo'),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: videoList.length,
            itemBuilder: (context, index) {
              final video = videoList[index];
              return ListTile(
                title: Text(video.title),
                onTap: () => _playVideo(video),
              );
            },
          ),
          if (_isVideoPlaying)
            Miniplayer(
              controller: _miniplayerController,
              minHeight: _playerMinHeight,
              maxHeight: MediaQuery.of(context).size.height,
              builder: (height, percentage) {
                if (height <= _playerMinHeight + 50) {
                  return Container(
                    color: Colors.black,
                    child: Row(
                      children: [
                        _controller!.value.isInitialized
                            ? AspectRatio(
                                aspectRatio: _controller!.value.aspectRatio,
                                child: VideoPlayer(_controller!),
                              )
                            : Center(child: CircularProgressIndicator()),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              _currentVideo!.title,
                              style: TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.close, color: Colors.white),
                              onPressed: _closeMiniPlayer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return FullScreenVideoPlayer(
                    video: _currentVideo!,
                    controller: _controller!,
                    miniplayerController: _miniplayerController,
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final Video video;
  final VideoPlayerController controller;
  final MiniplayerController miniplayerController;

  FullScreenVideoPlayer({
    required this.video,
    required this.controller,
    required this.miniplayerController,
  });

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > 0) {
          widget.miniplayerController.animateToHeight(state: PanelState.MIN);
        }
      },
      child: Scaffold(
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : CircularProgressIndicator(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }
}

class Video {
  final String title;
  final String url;

  Video({required this.title, required this.url});
}

List<Video> videoList = [
  Video(
    title: "The Valley",
    url:
        "https://mazwai.com/videvo_files/video/free/2016-04/small_watermarked/the_valley-graham_uheslki_preview.webm",
  ),
  Video(
    title: "Taksin Bridge",
    url:
        "https://mazwai.com/videvo_files/video/free/2019-01/small_watermarked/190111_04_TaksinBridge_Drone_06_preview.webm",
  ),
  Video(
    title: "Wat Arun Temple",
    url:
        "https://mazwai.com/videvo_files/video/free/2019-02/small_watermarked/190111_03_WatArunTemple_Drone_02_preview.webm",
  ),
];

///bottom bar

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool _showIcons = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showIcons = false; // Hide icons when a navigation item is tapped
    });
  }

  void _toggleIcons() {
    setState(() {
      _showIcons = !_showIcons;
      if (_showIcons) {
        _selectedIndex = 4; // Change page when floating action button is tapped
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bottom Navigation Bar Example'),
      ),
      body: Stack(
        children: [
          Center(
            child: Text(
              'Selected Index: $_selectedIndex',
              style: TextStyle(fontSize: 24),
            ),
          ),
          if (_showIcons)
            Positioned(
              bottom: 80.0,
              left: MediaQuery.of(context).size.width / 2 - 90,
              right: MediaQuery.of(context).size.width / 2 - 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.blue, size: 30),
                    onPressed: () {
                      print('Camera icon pressed');
                      _toggleIcons();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.photo, color: Colors.blue, size: 30),
                    onPressed: () {
                      print('Photo icon pressed');
                      _toggleIcons();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.videocam, color: Colors.blue, size: 30),
                    onPressed: () {
                      print('Video icon pressed');
                      _toggleIcons();
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleIcons,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      _onItemTapped(0);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.home,
                          color:
                              _selectedIndex == 0 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Home',
                          style: TextStyle(
                            color:
                                _selectedIndex == 0 ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      _onItemTapped(1);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.search,
                          color:
                              _selectedIndex == 1 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Search',
                          style: TextStyle(
                            color:
                                _selectedIndex == 1 ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      _onItemTapped(2);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.notifications,
                          color:
                              _selectedIndex == 2 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Notifications',
                          style: TextStyle(
                            color:
                                _selectedIndex == 2 ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      _onItemTapped(3);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          color:
                              _selectedIndex == 3 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(
                            color:
                                _selectedIndex == 3 ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


///custom

import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(VideoDemoApp());
}

class VideoDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VideoListScreen(),
    );
  }
}

class VideoListScreen extends StatefulWidget {
  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  VideoPlayerController? _controller;
  Video? _currentVideo;
  final MiniplayerController _miniplayerController = MiniplayerController();
  final double _playerMinHeight = 70.0;
  bool _isVideoPlaying = false;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _playVideo(Video video) {
    setState(() {
      _currentVideo = video;
      _controller?.dispose();
      _controller = VideoPlayerController.network(video.url)
        ..initialize().then((_) {
          setState(() {
            _isVideoPlaying = true;
            _controller!.play();
            _miniplayerController.animateToHeight(state: PanelState.MAX);
          });
        });
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
  }

  void _closeMiniPlayer() {
    setState(() {
      _controller?.pause();
      _isVideoPlaying = false;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Demo'),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: videoList.length,
            itemBuilder: (context, index) {
              final video = videoList[index];
              return ListTile(
                title: Text(video.title),
                onTap: () => _playVideo(video),
              );
            },
          ),
          if (_isVideoPlaying)
            Miniplayer(
              controller: _miniplayerController,
              minHeight: _playerMinHeight,
              maxHeight: MediaQuery.of(context).size.height,
              builder: (height, percentage) {
                if (height <= _playerMinHeight + 50) {
                  return Container(
                    color: Colors.black,
                    child: Row(
                      children: [
                        _controller!.value.isInitialized
                            ? AspectRatio(
                                aspectRatio: _controller!.value.aspectRatio,
                                child: VideoPlayer(_controller!),
                              )
                            : Center(child: CircularProgressIndicator()),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              _currentVideo!.title,
                              style: TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.close, color: Colors.white),
                              onPressed: _closeMiniPlayer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Scaffold(
                    body: Center(
                      child: _controller!.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _controller!.value.aspectRatio,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  VideoPlayer(_controller!),
                                  _ControlsOverlay(
                                    controller: _controller!,
                                    onFullscreenToggle: () {
                                      _miniplayerController.animateToHeight(
                                        state: PanelState.MAX,
                                      );
                                    },
                                    onDismiss: _closeMiniPlayer,
                                  ),
                                  VideoProgressIndicator(
                                    _controller!,
                                    allowScrubbing: true,
                                  ),
                                ],
                              ),
                            )
                          : CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}

class _ControlsOverlay extends StatefulWidget {
  const _ControlsOverlay({
    required this.controller,
    required this.onFullscreenToggle,
    required this.onDismiss,
    Key? key,
  }) : super(key: key);

  final VideoPlayerController controller;
  final VoidCallback onFullscreenToggle;
  final VoidCallback onDismiss;

  @override
  __ControlsOverlayState createState() => __ControlsOverlayState();
}

class __ControlsOverlayState extends State<_ControlsOverlay> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: widget.controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              widget.controller.value.isPlaying
                  ? widget.controller.pause()
                  : widget.controller.play();
            });
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: Icon(Icons.fullscreen, color: Colors.white),
            onPressed: widget.onFullscreenToggle,
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: widget.onDismiss,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _buildControls(context),
        ),
      ],
    );
  }

  Widget _buildControls(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller,
      builder: (context, VideoPlayerValue value, child) {
        return Container(
          color: Colors.black45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  widget.controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    widget.controller.value.isPlaying
                        ? widget.controller.pause()
                        : widget.controller.play();
                  });
                },
              ),
              Text(
                '${_formatDuration(value.position)} / ${_formatDuration(value.duration)}',
                style: TextStyle(color: Colors.white),
              ),
              IconButton(
                icon: Icon(Icons.fullscreen, color: Colors.white),
                onPressed: widget.onFullscreenToggle,
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }
}

class Video {
  final String title;
  final String url;

  Video({required this.title, required this.url});
}

List<Video> videoList = [
  Video(
    title: "The Valley",
    url:
        "https://mazwai.com/videvo_files/video/free/2016-04/small_watermarked/the_valley-graham_uheslki_preview.webm",
  ),
  Video(
    title: "Taksin Bridge",
    url:
        "https://mazwai.com/videvo_files/video/free/2019-01/small_watermarked/190111_04_TaksinBridge_Drone_06_preview.webm",
  ),
  Video(
    title: "Wat Arun Temple",
    url:
        "https://mazwai.com/videvo_files/video/free/2019-02/small_watermarked/190111_03_WatArunTemple_Drone_02_preview.webm",
  ),
];

///other
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(VideoDemoApp());
}

class VideoDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VideoListScreen(),
    );
  }
}

class VideoListScreen extends StatefulWidget {
  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  VideoPlayerController? _controller;
  Video? _currentVideo;
  final MiniplayerController _miniplayerController = MiniplayerController();
  final double _playerMinHeight = 70.0;
  bool _isVideoPlaying = false;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _playVideo(Video video) {
    setState(() {
      _currentVideo = video;
      _controller?.dispose();
      _controller = VideoPlayerController.network(video.url)
        ..initialize().then((_) {
          setState(() {
            _isVideoPlaying = true;
            _controller!.play();
            _miniplayerController.animateToHeight(state: PanelState.MAX);
          });
        });
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
  }

  void _closeMiniPlayer() {
    setState(() {
      _controller?.pause();
      _isVideoPlaying = false;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Demo'),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: videoList.length,
            itemBuilder: (context, index) {
              final video = videoList[index];
              return ListTile(
                title: Text(video.title),
                onTap: () => _playVideo(video),
              );
            },
          ),
          if (_isVideoPlaying)
            Miniplayer(
              controller: _miniplayerController,
              minHeight: _playerMinHeight,
              maxHeight: MediaQuery.of(context).size.height,
              builder: (height, percentage) {
                if (height <= _playerMinHeight + 50) {
                  return Container(
                    color: Colors.black,
                    child: Row(
                      children: [
                        _controller!.value.isInitialized
                            ? AspectRatio(
                                aspectRatio: _controller!.value.aspectRatio,
                                child: VideoPlayer(_controller!),
                              )
                            : Center(child: CircularProgressIndicator()),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              _currentVideo!.title,
                              style: TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.close, color: Colors.white),
                              onPressed: _closeMiniPlayer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            VideoPlayer(_controller!),
                            _ControlsOverlay(
                              controller: _controller!,
                              onPlayPauseToggle: _togglePlayPause,
                              onFullscreenToggle: () {
                                _miniplayerController.animateToHeight(
                                  state: PanelState.MAX,
                                );
                              },
                              onDismiss: _closeMiniPlayer,
                            ),
                            VideoProgressIndicator(
                              _controller!,
                              allowScrubbing: true,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: videoList.length,
                          itemBuilder: (context, index) {
                            final video = videoList[index];
                            return ListTile(
                              title: Text(video.title),
                              onTap: () => _playVideo(video),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}

class _ControlsOverlay extends StatefulWidget {
  const _ControlsOverlay({
    required this.controller,
    required this.onPlayPauseToggle,
    required this.onFullscreenToggle,
    required this.onDismiss,
    Key? key,
  }) : super(key: key);

  final VideoPlayerController controller;
  final VoidCallback onPlayPauseToggle;
  final VoidCallback onFullscreenToggle;
  final VoidCallback onDismiss;

  @override
  __ControlsOverlayState createState() => __ControlsOverlayState();
}

class __ControlsOverlayState extends State<_ControlsOverlay> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              widget.controller.value.isPlaying
                  ? widget.controller.pause()
                  : widget.controller.play();
            });
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _buildControls(context),
        ),
      ],
    );
  }

  Widget _buildControls(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller,
      builder: (context, VideoPlayerValue value, child) {
        return Container(
          color: Colors.black45,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  widget.controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: widget.onPlayPauseToggle,
              ),
              Text(
                '${_formatDuration(value.position)} / ${_formatDuration(value.duration)}',
                style: TextStyle(color: Colors.white),
              ),
              IconButton(
                icon: Icon(Icons.fullscreen, color: Colors.white),
                onPressed: widget.onFullscreenToggle,
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: widget.onDismiss,
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }
}

class Video {
  final String title;
  final String url;

  Video({required this.title, required this.url});
}

List<Video> videoList = [
  Video(
    title: "The Valley",
    url:
        "https://mazwai.com/videvo_files/video/free/2016-04/small_watermarked/the_valley-graham_uheslki_preview.webm",
  ),
  Video(
    title: "Taksin Bridge",
    url:
        "https://mazwai.com/videvo_files/video/free/2019-01/small_watermarked/190111_04_TaksinBridge_Drone_06_preview.webm",
  ),
  Video(
    title: "Wat Arun Temple",
    url:
        "https://mazwai.com/videvo_files/video/free/2019-02/small_watermarked/190111_03_WatArunTemple_Drone_02_preview.webm",
  ),
];

