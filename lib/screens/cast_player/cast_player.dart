import 'dart:async';

import 'package:animu/services/sources.dart';
import 'package:animu/widgets/previous_next.dart';
import 'package:animu/utils/models.dart';
import 'package:animu/utils/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  bool sliding = false;

  void tick(timer) async {
    if (sliding) return;
    tickerData = await vlc.send(null);
    setState(() {});
  }

  void initPlayer() async {
    final url = await getEpisodeURLFromData(data);
    if (!mounted) return;
    await vlc.send('in_play', input: url);
    ticker = new Timer.periodic(Duration(seconds: 1), tick);
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
          (tickerData == null || tickerData['length'] < 0)
              ? SpinKitDoubleBounce(
                  color: Theme.of(context).accentColor,
                  size: 50,
                )
              : CastPlayerControls(data: tickerData),
        ],
      ),
    );
  }
}
