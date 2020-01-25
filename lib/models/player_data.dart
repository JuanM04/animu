import 'package:animu/models/anime.dart';
import 'package:animu/models/episode.dart';

class PlayerData {
  final Anime anime;
  final List<Episode> episodes;
  Episode currentEpisode;

  PlayerData({
    this.anime,
    this.episodes,
    this.currentEpisode,
  });
}
