import 'package:animu/utils/helpers.dart';
import 'package:animu/utils/models.dart';
import 'package:animu/widgets/previous_next.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
