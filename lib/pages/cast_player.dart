import 'package:animu/components/previous_next.dart';
import 'package:animu/utils/classes.dart';
import 'package:animu/utils/helpers.dart';
import 'package:animu/utils/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CastPlayer extends StatefulWidget {
  @override
  _CastPlayerState createState() => _CastPlayerState();
}

class _CastPlayerState extends State<CastPlayer> {
  PlayerData data;
  SSHNotifier ssh;
  bool isPlaying = true;

  void initPlayer() async {
    final url = await getURLFromData(data);
    ssh.client.writeToShell('omxplayer $url\n');
  }

  void changeEpisode(Episode episode) async {
    data.currentEpisode = episode;
    isPlaying = true;
    setState(() {});
    await ssh.client.writeToShell('q');
    initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      data = ModalRoute.of(context).settings.arguments;
      ssh = Provider.of<SSHNotifier>(context);
      initPlayer();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          BackButton(),
          SizedBox(height: 10),
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
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () => ssh.client.writeToShell('^[[D'),
                child: Icon(Icons.replay_30, size: 50),
              ),
              GestureDetector(
                onTap: () {
                  ssh.client.writeToShell('p');
                  setState(() => isPlaying = !isPlaying);
                },
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 100,
                ),
              ),
              GestureDetector(
                onTap: () => ssh.client.writeToShell('^[[C'),
                child: Icon(Icons.forward_30, size: 50),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              PreviousNext(
                type: PreviousNextType.previous,
                data: data,
                changeEpisode: changeEpisode,
              ),
              SizedBox(width: 20),
              PreviousNext(
                type: PreviousNextType.next,
                data: data,
                changeEpisode: changeEpisode,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
