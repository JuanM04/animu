import 'package:animu/models/anime.dart';
import 'package:animu/models/episode.dart';
import 'package:animu/models/player_data.dart';
import 'package:animu/screens/cast_player/cast_player.dart';
import 'package:animu/screens/player/player.dart';
import 'package:animu/utils/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EpisodeList extends StatelessWidget {
  final Anime anime;
  final List<Episode> episodes;
  final Function(Episode episode) seenUnseen;
  EpisodeList({this.anime, this.episodes, this.seenUnseen});

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
    return SliverPadding(
      padding: EdgeInsets.all(10),
      sliver: SliverGrid.count(
        crossAxisCount: 2,
        childAspectRatio: 16 / 9,
        mainAxisSpacing: 20,
        crossAxisSpacing: 15,
        children: List.generate(
          episodes.length,
          (i) => GestureDetector(
            onTap: () => playEpisode(context, episodes[i]),
            onLongPress: () => seenUnseen(episodes[i]),
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.memory(episodes[i].thumbnail),
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
    );
  }
}
