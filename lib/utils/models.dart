import 'dart:typed_data';

import 'package:animu/utils/watching_states.dart';
import 'package:hive/hive.dart';

part 'models.g.dart';

@HiveType(typeId: 0)
class Anime {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String slug;
  @HiveField(3)
  final Uint8List cover;
  @HiveField(4)
  bool favorite;
  @HiveField(5)
  WatchingState watchingState;
  @HiveField(6)
  List<int> episodesSeen;

  Anime({
    this.id,
    this.name,
    this.slug,
    this.cover,
    this.favorite = false,
    this.watchingState,
    this.episodesSeen,
  });
}

class Episode {
  final int id;
  final int n;
  final Uint8List thumbnail;

  Episode({this.id, this.n, this.thumbnail});
}

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
