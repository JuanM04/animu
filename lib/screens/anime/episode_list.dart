import 'dart:math';

import 'package:animu/screens/cast_player/cast_player.dart';
import 'package:animu/screens/player/player.dart';
import 'package:animu/utils/models.dart';
import 'package:animu/utils/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EpisodeList extends StatelessWidget {
  final Anime anime;
  final List<Episode> episodes;
  final Function(Episode episode) seenUnseen;
  final Function() swapOrder;
  EpisodeList({this.anime, this.episodes, this.seenUnseen, this.swapOrder});

  void playEpisode(BuildContext context, Episode episode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Provider.of<VLCNotifier>(context).isConnected
            ? CastPlayer()
            : Player(),
        settings: RouteSettings(
          arguments: PlayerData(
            anime: anime,
            episodes: episodes,
            currentEpisode: episode,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 16 / 9,
            mainAxisSpacing: 20,
            crossAxisSpacing: 15,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: List.generate(
              episodes.length,
              (i) => GestureDetector(
                onTap: () => playEpisode(context, episodes[i]),
                onLongPress: () => seenUnseen(episodes[i]),
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                          'https://animu.juanm04.com/api/get-image?type=thumbnail&anime_id=${anime.id}&episode_n=${episodes[i].n}'),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        episodes[i].n.toString(),
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w800,
                          shadows: [
                            Shadow(color: Colors.black54, blurRadius: 20),
                          ],
                        ).merge(anime.episodesSeen != null &&
                                anime.episodesSeen.contains(episodes[i].n)
                            ? TextStyle(
                                decoration: TextDecoration.lineThrough,
                                decorationThickness: 1.5,
                                decorationStyle: TextDecorationStyle.wavy,
                                decorationColor: Theme.of(context).primaryColor,
                              )
                            : TextStyle()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          color: Colors.grey[850],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.swap_vert),
                label: Text('Orden'),
                onPressed: swapOrder,
              ),
              FlatButton.icon(
                icon: Icon(Icons.play_arrow),
                label: Text('Reproducir siguiente'),
                onPressed: () {
                  var nextEpisode =
                      episodes.firstWhere((episode) => episode.n == 1);

                  if (anime.episodesSeen != null &&
                      anime.episodesSeen.length > 0) {
                    // nextEpisode = the episode with the largest N + 1 or the last episode
                    nextEpisode = episodes.firstWhere(
                      (episode) =>
                          episode.n == anime.episodesSeen.reduce(max) + 1,
                      orElse: () => episodes
                          .reduce((a, b) => max(a.n, b.n) == a.n ? a : b),
                    );
                  }

                  playEpisode(context, nextEpisode);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
