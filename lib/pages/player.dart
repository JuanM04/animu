import 'package:animu/components/previous_next.dart';
import 'package:animu/utils/classes.dart';
import 'package:animu/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';

class Player extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  PlayerData data;
  VideoPlayerController _controller;

  void initPlayer() async {
    _controller = VideoPlayerController.network(await getURLFromData(data))
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) data = ModalRoute.of(context).settings.arguments;
    if (_controller == null) initPlayer();

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
            : SpinKitDoubleBounce(
                color: Theme.of(context).accentColor,
                size: 100,
              ),
      ),
    );
  }
}

class PlayerControls extends StatelessWidget {
  final PlayerData data;
  final VideoPlayerController controller;
  final Function(Duration moment) seekTo;
  final Function(Episode episode) changeEpisode;
  PlayerControls({this.data, this.controller, this.seekTo, this.changeEpisode});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Middle Buttons
          Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  PreviousNext(
                    type: PreviousNextType.previous,
                    data: data,
                    changeEpisode: changeEpisode,
                  ),
                  Icon(
                    Icons.play_arrow,
                    size: 100,
                  ),
                  PreviousNext(
                    type: PreviousNextType.next,
                    data: data,
                    changeEpisode: changeEpisode,
                  ),
                ],
              )),
          // Progress Bar
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(formatDuration(controller.value.position)),
                  Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Slider(
                      value: controller.value.position.inSeconds.toDouble(),
                      min: 0,
                      max: controller.value.duration.inSeconds.toDouble(),
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (time) =>
                          seekTo(Duration(seconds: time.round())),
                    ),
                  ),
                  Text(formatDuration(controller.value.duration)),
                ],
              ),
            ),
          ),
          // Back Button
          Positioned(
            top: 5,
            left: 10,
            child: BackButton(),
          ),
          //Title
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10),
                Text(
                  data.anime.name,
                  style: TextStyle(
                    height: 1,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Episodio ${data.currentEpisode.n}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
