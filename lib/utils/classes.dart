import 'package:flutter/material.dart';

class Anime {
  final int id;
  final String name;
  final String slug;
  bool favorite;
  List<int> episodesSeen;

  Anime({
    this.id,
    this.name,
    this.slug,
    this.favorite = false,
    this.episodesSeen,
  });

  factory Anime.fromDBMap(Map<String, dynamic> map) => Anime(
        id: map['id'],
        name: map['name'],
        slug: map['slug'],
        favorite: map['favorite'] == 1 ? true : false,
        episodesSeen: map['episodes_seen'] != ''
            ? List<int>.from(
                map['episodes_seen'].split(',').map((x) => int.parse(x)))
            : [],
      );

  Map<String, dynamic> toDBMap() => {
        'id': id,
        'name': name,
        'slug': slug,
        'favorite': favorite ? 1 : 0,
        'episodes_seen': episodesSeen != null && episodesSeen.length > 0
            ? episodesSeen
                .fold('', (accum, value) => '$accum,$value')
                .substring(1)
            : '',
      };
}

class Episode {
  final int id;
  final int n;

  Episode({this.id, this.n});
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

class APIServer {
  final String name;
  Future<String> Function(String sourceCode) function;

  APIServer({this.name, this.function});
}

class TabInfo {
  final String title;
  final IconData icon;
  final Widget widget;
  TabInfo(this.title, this.icon, this.widget);
}
