import 'package:animu/services/sources.dart';
import 'package:animu/utils/models.dart';
import 'package:animu/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';
import 'package:video_player/video_player.dart';

import 'controls.dart';

class Player extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  PlayerData data;
  VideoPlayerController _controller;

  void initPlayer() async {
    final url = await getEpisodeURLFromData(data);
    if (!mounted) return;
    if (url == null) return initPlayer();
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) => setState(() {}));
  }

  void seekTo(Duration moment) {
    _controller.seekTo(moment);
    setState(() {});
  }

  void changeEpisode(Episode episode) {
    data.currentEpisode = episode;
    _controller = null;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    if (_controller != null) _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    Screen.keepOn(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) data = ModalRoute.of(context).settings.arguments;
    if (_controller == null) initPlayer();

    if (_controller != null && _controller.value.initialized)
      Screen.keepOn(_controller.value.isPlaying);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller != null && _controller.value.initialized
            ? Stack(
                children: <Widget>[
                  // Video
                  Align(
                    alignment: Alignment.center,
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                  GestureDetector(
                    child: !_controller.value.isPlaying
                        ? PlayerControls(
                            data: data,
                            controller: _controller,
                            seekTo: seekTo,
                            changeEpisode: changeEpisode,
                          )
                        : Opacity(
                            opacity: 0,
                            child: Container(color: Colors.black),
                          ),
                    onTap: () {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                      setState(() {});
                    },
                  ),
                ],
              )
            : Spinner(size: 75),
      ),
    );
  }
}
