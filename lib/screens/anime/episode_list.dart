import 'package:animu/utils/models.dart';
import 'package:animu/utils/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EpisodeList extends StatelessWidget {
  final Anime anime;
  final List<Episode> episodes;
  final Function(Episode episode) seenUnseen;
  EpisodeList({this.anime, this.episodes, this.seenUnseen});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 16 / 9,
      mainAxisSpacing: 20,
      crossAxisSpacing: 15,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      children: List.generate(
        episodes.length,
        (i) => GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            Provider.of<VLCNotifier>(context).isConnected
                ? '/cast_player'
                : '/player',
            arguments: PlayerData(
              anime: anime,
              episodes: episodes,
              currentEpisode: episodes[i],
            ),
          ),
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
    );
  }
}
