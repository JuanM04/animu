import 'dart:convert';

import 'package:animu/screens/anime/episode_list.dart';
import 'package:animu/services/requests.dart';
import 'package:animu/utils/models.dart';
import 'package:animu/services/anime_database.dart';
import 'package:animu/utils/watching_states.dart';
import 'package:animu/widgets/dialog_button.dart';
import 'package:animu/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main_button.dart';

class AnimeScreen extends StatefulWidget {
  @override
  _AnimeScreenState createState() => _AnimeScreenState();
}

class _AnimeScreenState extends State<AnimeScreen> {
  Anime anime;
  List<Episode> episodes;
  bool loading = true;

  double positionFromBottom(int n) => n * 50.00 + (n + 1) * 20;

  void getAnimeDBData() async {
    dynamic dbAnime = await AnimeDatabaseService().getAnimeById(anime.id);
    if (dbAnime != null) setState(() => anime = dbAnime);
  }

  void getEpisodes() async {
    List response = await RequestsService.getEpisodes(anime: anime);

    if (mounted)
      setState(() {
        episodes = new List<Episode>.from(
          response
              .map((map) => Episode(
                    id: map['id'],
                    n: map['n'],
                    thumbnail: base64Decode(map['thumbnail']),
                  ))
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
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 1 / 3,
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Image.memory(
                    anime.cover,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Positioned(
                    bottom: positionFromBottom(1),
                    right: 0,
                    child: MainButton(
                      backgroundColor: Theme.of(context).backgroundColor,
                      child: IconButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Cambiar el estado del anime'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: WatchingState.values
                                  .map((state) => ChoiceChip(
                                        avatar: Icon(state.icon, size: 18),
                                        label: Text(
                                          state.name,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        selected: anime.watchingState == state,
                                        onSelected: (changed) async {
                                          if (!changed) return;
                                          anime.watchingState = state;
                                          await AnimeDatabaseService()
                                              .updateAnime(anime);
                                          setState(
                                              () => Navigator.pop(context));
                                        },
                                      ))
                                  .toList(),
                            ),
                            actions: <Widget>[
                              if (anime.watchingState != null)
                                DialogButton(
                                  label: 'Eliminar estado',
                                  onPressed: () async {
                                    anime.watchingState = null;
                                    await AnimeDatabaseService()
                                        .updateAnime(anime);
                                    setState(() => Navigator.pop(context));
                                  },
                                ),
                              DialogButton(
                                label: 'Cancelar',
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        ),
                        icon: Icon(
                          anime.watchingState != null
                              ? anime.watchingState.icon
                              : Icons.bookmark_border,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: positionFromBottom(0),
                    right: 0,
                    child: MainButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: IconButton(
                        onPressed: () async {
                          anime.favorite = !anime.favorite;
                          await AnimeDatabaseService().updateAnime(anime);
                          setState(() {});
                        },
                        icon: Icon(anime.favorite
                            ? Icons.favorite
                            : Icons.favorite_border),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .7,
                    child: Text(
                      anime.name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        letterSpacing: 1,
                        height: 1.25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: !loading
                  ? EpisodeList(
                      anime: anime,
                      episodes: episodes,
                      seenUnseen: (episode) async {
                        if (anime.episodesSeen == null) anime.episodesSeen = [];
                        if (anime.episodesSeen.contains(episode.n))
                          anime.episodesSeen.remove(episode.n);
                        else
                          anime.episodesSeen.add(episode.n);
                        await AnimeDatabaseService().updateAnime(anime);
                        HapticFeedback.vibrate();
                        setState(() {});
                      },
                      swapOrder: () {
                        setState(() => episodes = episodes.reversed.toList());
                      },
                    )
                  : Spinner(size: 50),
            ),
          ],
        ),
      ),
    );
  }
}
