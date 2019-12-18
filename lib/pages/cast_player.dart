import 'dart:async';

import 'package:animu/components/previous_next.dart';
import 'package:animu/utils/classes.dart';
import 'package:animu/utils/helpers.dart';
import 'package:animu/utils/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class CastPlayer extends StatefulWidget {
  @override
  _CastPlayerState createState() => _CastPlayerState();
}

class _CastPlayerState extends State<CastPlayer> {
  PlayerData data;
  VLCNotifier vlc;

  Timer ticker;
  bool isPlaying = false;
  bool sliding = false;
  Duration time = Duration.zero;
  Duration length = Duration(seconds: -1);

  void tick(timer) async {
    if (sliding) return;
    final data = await vlc.send(null);

    setState(() {
      isPlaying = data['state'] == 'playing';
      time = Duration(seconds: data['time']);
      length = Duration(seconds: data['length']);
    });
  }

  void initPlayer() async {
    final url = await getEpisodeURLFromData(data);
    await vlc.send('in_play', input: url);
    ticker = new Timer.periodic(Duration(seconds: 1), tick);
  }

  void changeEpisode(Episode episode) async {
    if (ticker.isActive) ticker.cancel();
    data.currentEpisode = episode;
    isPlaying = false;
    time = Duration.zero;
    length = Duration(seconds: -1);
    setState(() {});
    initPlayer();
  }

  @override
  void dispose() {
    if (ticker.isActive) ticker.cancel();
    vlc.send('pl_stop');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      data = ModalRoute.of(context).settings.arguments;
      vlc = Provider.of<VLCNotifier>(context);
      initPlayer();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Transmitiendo'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              PreviousNext(
                type: PreviousNextType.previous,
                data: data,
                changeEpisode: changeEpisode,
              ),
              Column(
                children: <Widget>[
                  Text(
                    data.anime.name,
                    style: TextStyle(
                      height: 1,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'Episodio ${data.currentEpisode.n}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              PreviousNext(
                type: PreviousNextType.next,
                data: data,
                changeEpisode: changeEpisode,
              ),
            ],
          ),
          SizedBox(height: 50),
          length.inSeconds < 0
              ? SpinKitDoubleBounce(
                  color: Theme.of(context).accentColor,
                  size: 50,
                )
              : Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => vlc.send('seek', val: '-10s'),
                          child: Icon(Icons.replay_10, size: 50),
                        ),
                        GestureDetector(
                          onTap: () {
                            vlc.send('pl_pause');
                            setState(() => isPlaying = !isPlaying);
                          },
                          child: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 100,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => vlc.send('seek', val: '+10s'),
                          child: Icon(Icons.forward_10, size: 50),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(formatDuration(time)),
                          Text(formatDuration(length)),
                        ],
                      ),
                    ),
                    Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width,
                      child: Slider(
                        value: time.inSeconds.toDouble(),
                        min: 0,
                        max: length.inSeconds.toDouble(),
                        activeColor: Theme.of(context).primaryColor,
                        onChangeStart: (seconds) =>
                            setState(() => sliding = true),
                        onChanged: (seconds) => setState(
                            () => time = Duration(seconds: seconds.round())),
                        onChangeEnd: (seconds) => setState(() {
                          sliding = false;
                          vlc.send('seek', val: seconds.round().toString());
                        }),
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
