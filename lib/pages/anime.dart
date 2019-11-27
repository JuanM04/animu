import 'dart:convert';
import 'package:animu/components/episode_list.dart';
import 'package:animu/utils/classes.dart';
import 'package:animu/utils/db.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AnimePage extends StatefulWidget {
  @override
  _AnimePageState createState() => _AnimePageState();
}

class _AnimePageState extends State<AnimePage> {
  Anime anime;
  List<Episode> episodes;
  bool loading = true;

  void getAnimeDBData() async {
    dynamic dbAnime = await AnimeDatabase().getAnimeById(anime.id);
    if (dbAnime != null) setState(() => anime = dbAnime);
  }

  void getEpisodes() async {
    Response response =
        await Dio().get('https://animeflv.net/anime/${anime.id}/${anime.slug}');

    String rawEpisodes =
        response.data.toString().split('var episodes = ')[1].split(';')[0];

    setState(() {
      episodes = new List<Episode>.from(
        jsonDecode(rawEpisodes)
            .map((list) => Episode(id: list[1], n: list[0]))
            .toList(),
      );
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (anime == null) {
      anime = ModalRoute.of(context).settings.arguments;
      getAnimeDBData();
    }
    if (episodes == null) getEpisodes();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 1 / 3,
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Image.network(
                    'https://animeflv.net/uploads/animes/covers/${anime.id}.jpg',
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Positioned(
                    bottom: 5,
                    left: 10,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: AutoSizeText(
                      anime.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 28,
                        letterSpacing: 1,
                        height: 1.25,
                        shadows: [
                          Shadow(color: Colors.black54, blurRadius: 10),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(20)),
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        child: Center(
                          child: IconButton(
                            onPressed: () async {
                              anime.favorite = !anime.favorite;
                              await AnimeDatabase().updateAnime(anime);
                              setState(() {});
                            },
                            icon: Icon(anime.favorite
                                ? Icons.favorite
                                : Icons.favorite_border),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: BackButton(),
                  )
                ],
              ),
            ),
            Expanded(
              child: !loading
                  ? EpisodeList(
                      anime: anime,
                      episodes: episodes,
                      seenUnseen: (episode) async {
                        if (anime.episodesSeen.contains(episode.n))
                          anime.episodesSeen.remove(episode.n);
                        else
                          anime.episodesSeen.add(episode.n);
                        await AnimeDatabase().updateAnime(anime);
                        HapticFeedback.vibrate();
                        setState(() {});
                      },
                    )
                  : SpinKitDoubleBounce(
                      color: Colors.grey[600],
                      size: 25,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
