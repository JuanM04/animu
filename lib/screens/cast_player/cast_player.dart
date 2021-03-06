import 'dart:async';

import 'package:animu/models/episode.dart';
import 'package:animu/models/player_data.dart';
import 'package:animu/services/sources.dart';
import 'package:animu/widgets/previous_next.dart';
import 'package:animu/utils/notifiers.dart';
import 'package:animu/widgets/seen_unseen_button.dart';
import 'package:animu/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controls.dart';

class CastPlayer extends StatefulWidget {
  @override
  _CastPlayerState createState() => _CastPlayerState();
}

class _CastPlayerState extends State<CastPlayer> {
  PlayerData data;
  VLCNotifier vlc;

  Timer ticker;
  dynamic tickerData;

  void tick(timer) async {
    tickerData = await vlc.send(null);
    if (mounted) setState(() {});
  }

  void initPlayer() async {
    final url = await getEpisodeURLFromData(data);
    if (!mounted) return;
    if (url == null) return initPlayer();
    tickerData = await vlc.send('in_play', input: url);
    ticker = new Timer.periodic(Duration(seconds: 1), tick);
    setState(() {});
  }

  void changeEpisode(Episode episode) async {
    if (ticker.isActive) ticker.cancel();
    data.currentEpisode = episode;
    tickerData = null;
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
      appBar: AppBar(
        title: Text('Transmitiendo'),
        actions: <Widget>[
          SeenUnseenButton(data),
        ],
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
              Flexible(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: data.anime.name,
                        style: TextStyle(
                          height: 1,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      TextSpan(text: '\n'),
                      TextSpan(
                        text: 'Episodio ${data.currentEpisode.n}',
                        style: TextStyle(
                          height: 1.75,
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PreviousNext(
                type: PreviousNextType.next,
                data: data,
                changeEpisode: changeEpisode,
              ),
            ],
          ),
          SizedBox(height: 25),
          (tickerData == null || tickerData['length'] <= 0)
              ? Spinner(size: 30)
              : CastPlayerControls(data: tickerData),
        ],
      ),
    );
  }
}
