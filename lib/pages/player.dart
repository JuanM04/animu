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
  VideoPlayerController _controller;
  Anime anime;
  List<Episode> episodes;
  Episode episode;

  void initPlayer() async {
    Response response = await new Dio().get(
        'https://animeflv.net/ver/${episode.id}/${anime.slug}-${episode.n}');

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
    if (anime == null) {
      Map args = ModalRoute.of(context).settings.arguments;
      anime = args['anime'];
      episodes = args['episodes'];
      episode = args['episode'];
      initPlayer();
    }

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
                            _controller,
                            setState: setState,
                            anime: anime,
                            episodes: episodes,
                            episode: episode,
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
  final VideoPlayerController _controller;
  final Function setState;
  final Anime anime;
  final List<Episode> episodes;
  final Episode episode;
  PlayerControls(this._controller,
      {this.setState, this.anime, this.episodes, this.episode});

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
                    'previous',
                    episodes: episodes,
                    episode: episode,
                  ),
                  Icon(
                    Icons.play_arrow,
                    size: 100,
                  ),
                  PreviousNext(
                    'next',
                    episodes: episodes,
                    episode: episode,
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
                  Text(formatDuration(_controller.value.position)),
                  Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Slider(
                      value: _controller.value.position.inSeconds.toDouble(),
                      min: 0,
                      max: _controller.value.duration.inSeconds.toDouble(),
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (time) {
                        _controller.seekTo(Duration(seconds: time.round()));
                        setState(() {});
                      },
                    ),
                  ),
                  Text(formatDuration(_controller.value.duration)),
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
                  anime.name,
                  style: TextStyle(
                    height: 1,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Episodio ${episode.n}',
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
  final String type;
  final List<Episode> episodes;
  final Episode episode;
  PreviousNext(this.type, {this.episodes, this.episode});

  @override
  Widget build(BuildContext context) {
    int difference = type == 'previous' ? -1 : 1;
    int index = episodes.indexWhere((e) => e.n == episode.n + difference);

    if (index == -1)
      return SizedBox(width: 50);
    else
      return GestureDetector(
        onTap: () {
          Map args = ModalRoute.of(context).settings.arguments;
          args['episode'] = episodes[index];

          Navigator.pushReplacementNamed(context, '/player', arguments: args);
        },
        child: Icon(
          type == 'previous' ? Icons.skip_previous : Icons.skip_next,
          size: 50,
        ),
      );
  }
}
