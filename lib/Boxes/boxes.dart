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

