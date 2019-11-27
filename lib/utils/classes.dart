class Anime {
  int id;
  String name;
  String slug;
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
  int id;
  int n;

  Episode({this.id, this.n});
}

class APIServer {
  String name;
  Future<String> Function(String sourceCode) function;

  APIServer({this.name, this.function});
}
