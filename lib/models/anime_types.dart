import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'anime_types.g.dart';

@HiveType(typeId: 2)
enum AnimeType {
  @HiveField(0)
  TV,
  @HiveField(1)
  MOVIE,
  @HiveField(2)
  SPECIAL,
  @HiveField(3)
  OVA,
}

const animeTypeString = {
  AnimeType.TV: 'TV',
  AnimeType.MOVIE: 'MOVIE',
  AnimeType.SPECIAL: 'SPECIAL',
  AnimeType.OVA: 'OVA',
};

extension AnimeTypeExtension on AnimeType {
  String get name {
    switch (this) {
      case AnimeType.TV:
        return 'Anime';
      case AnimeType.MOVIE:
        return 'Película';
      case AnimeType.SPECIAL:
        return 'Especial';
      case AnimeType.OVA:
        return 'OVA';
      default:
        return null;
    }
  }

  Color get color {
    switch (this) {
      case AnimeType.TV:
        return Colors.blue;
      case AnimeType.MOVIE:
        return Colors.red;
      case AnimeType.SPECIAL:
        return Colors.purple;
      case AnimeType.OVA:
        return Colors.orange[800];
      default:
        return null;
    }
  }
}
