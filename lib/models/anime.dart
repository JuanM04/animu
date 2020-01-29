import 'dart:convert';
import 'dart:typed_data';

import 'package:animu/models/anime_types.dart';
import 'package:animu/models/watching_states.dart';
import 'package:animu/utils/helpers.dart';
import 'package:hive/hive.dart';

part 'anime.g.dart';

@HiveType(typeId: 0)
class Anime {
  @HiveField(0)
  final int id;
  @HiveField(2)
  final String slug;
  @HiveField(1)
  String name;
  @HiveField(3)
  Uint8List cover;
  @HiveField(7)
  Uint8List banner;
  @HiveField(8)
  AnimeType type;
  @HiveField(4)
  bool favorite;
  @HiveField(5)
  WatchingState watchingState;
  @HiveField(6)
  List<int> episodesSeen;

  Anime({
    this.id,
    this.slug,
    this.name,
    this.cover,
    this.banner,
    this.type,
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
      banner: map['banner'] == null ? null : base64Decode(map['banner']),
      type: map['type'] == null
          ? null
          : stringToKey(map['type'], animeTypeString),
      favorite: map['favorite'] ?? false,
      watchingState: map['watchingState'] == null
          ? null
          : stringToKey(map['watchingState'], watchingStateString),
      episodesSeen: map['episodesSeen'] == null
          ? []
          : List<int>.from(map['episodesSeen']),
    );
  }

  Map<String, dynamic> toMap([bool limited = false]) {
    final Map<String, dynamic> map = {
      'id': id,
      'slug': slug,
      'favorite': favorite,
      'watchingState':
          watchingState == null ? null : watchingStateString[watchingState],
      'episodesSeen': episodesSeen,
    };

    if (!limited) {
      return {
        ...map,
        'name': name,
        'cover': cover == null ? null : base64Encode(cover),
        'banner': banner == null ? null : base64Encode(banner),
        'type': type == null ? null : animeTypeString[type],
      };
    } else {
      return map;
    }
  }
}
