import 'package:animu/models/episode.dart';
import 'package:animu/models/player_data.dart';
import 'package:animu/services/anime_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

enum PreviousNextType { previous, next }

class PreviousNext extends StatelessWidget {
  final PreviousNextType type;
  final PlayerData data;
  final Function(Episode episode) changeEpisode;
  PreviousNext({this.type, this.data, this.changeEpisode});

  @override
  Widget build(BuildContext context) {
    final isPrevious = type == PreviousNextType.previous;
    int difference = isPrevious ? -1 : 1;
    int index = data.episodes
        .indexWhere((e) => e.n == data.currentEpisode.n + difference);

    if (index == -1)
      return SizedBox(width: 50);
    else
      return GestureDetector(
        onTap: () {
          var anime = data.anime;

          if (!isPrevious &&
              Hive.box('settings').get('mark_as_seen_when_next_episode') &&
              !anime.episodesSeen.contains(data.currentEpisode.n)) {
            anime.episodesSeen.add(data.currentEpisode.n);
            AnimeDatabaseService.updateAnime(anime);
          }

          changeEpisode(data.episodes[index]);
        },
        child: Icon(
          isPrevious ? Icons.skip_previous : Icons.skip_next,
          size: 50,
        ),
      );
  }
}
