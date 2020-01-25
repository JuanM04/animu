import 'package:animu/utils/helpers.dart';
import 'package:animu/utils/models.dart';
import 'package:animu/widgets/aicon.dart';
import 'package:animu/widgets/previous_next.dart';
import 'package:animu/widgets/seen_unseen_button.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayerControls extends StatelessWidget {
  final PlayerData data;
  final VideoPlayerController controller;
  final Function togglePlay;
  final Function(Duration moment) seekTo;
  final Function(Episode episode) changeEpisode;

  PlayerControls({
    this.data,
    this.togglePlay,
    this.controller,
    this.seekTo,
    this.changeEpisode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black38,
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
                  GestureDetector(
                    onTap: togglePlay,
                    child: AIcon(
                      isInitialState: !controller.value.isPlaying,
                      icon: AnimatedIcons.play_pause,
                      size: 100,
                    ),
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
          // Mark as Seen
          Positioned(
            top: 5,
            right: 10,
            child: SeenUnseenButton(data),
          ),
          //Title
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 15),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: data.anime.name,
                        style: TextStyle(
                          height: 1,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(text: '\n'),
                      TextSpan(
                        text: 'Episodio ${data.currentEpisode.n}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
