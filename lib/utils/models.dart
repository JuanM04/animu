import 'dart:convert';
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

  factory Anime.fromMap(Map<String, dynamic> map) {
    return Anime(
      id: map['id'],
      name: map['name'],
      slug: map['slug'],
      cover: map['cover'] == null ? null : base64Decode(map['cover']),
      favorite: map['favorite'] ?? false,
      watchingState: map['watchingState'] == null
          ? null
          : watchingStateString.entries
              .firstWhere((x) => x.value == map['watchingState'])
              .key,
      episodesSeen: map['episodesSeen'] ?? [],
    );
  }

  Map<String, dynamic> toMap([bool limited = false]) {
    return {
      'id': id,
      'name': limited ? null : name,
      'slug': slug,
      'cover': limited || cover == null ? null : base64Encode(cover),
      'favorite': favorite,
      'watchingState':
          watchingState == null ? null : watchingStateString[watchingState],
      'episodesSeen': episodesSeen,
    };
  }
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
