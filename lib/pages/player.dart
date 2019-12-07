import 'dart:convert';
import 'package:animu/utils/classes.dart';
import 'package:animu/utils/helpers.dart';
import 'package:dio/dio.dart';
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
    Response response = await new Dio().get(
        'https://animeflv.net/ver/${data.currentEpisode.id}/${data.anime.slug}-${data.currentEpisode.n}');

    List sources = jsonDecode(response.data
        .toString()
        .split('var videos = ')[1]
        .split(';')[0])['SUB'];
    for (APIServer server in serverPriorityList) {
      int index =
          sources.indexWhere((source) => source['server'] == server.name);

      if (index > -1) {
        _controller = VideoPlayerController.network(
            await server.function(sources[index]['code']))
          ..initialize().then((_) => setState(() {}));
        return;
      }
    }
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

class PreviousNext extends StatelessWidget {
  final PreviousNextType type;
  final PlayerData data;
  final Function(Episode episode) changeEpisode;
  PreviousNext({this.type, this.data, this.changeEpisode});

  @override
  Widget build(BuildContext context) {
    final isPrevious = type == PreviousNextType.previous;
    int difference = isPrevious ? -1 : 1;
    int index = data.episodes
        .indexWhere((e) => e.n == data.currentEpisode.n + difference);

    if (index == -1)
      return SizedBox(width: 50);
    else
      return GestureDetector(
        onTap: () => changeEpisode(data.episodes[index]),
        child: Icon(
          isPrevious ? Icons.skip_previous : Icons.skip_next,
          size: 50,
        ),
      );
  }
}
