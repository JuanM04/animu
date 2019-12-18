import 'package:animu/screens/anime/episode_list.dart';
import 'package:animu/utils/models.dart';
import 'package:animu/services/anime_database.dart';
import 'package:animu/utils/helpers.dart';
import 'package:animu/utils/watching_states.dart';
import 'package:animu/widgets/dialog_button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'main_button.dart';

class AnimeScreen extends StatefulWidget {
  @override
  _AnimeScreenState createState() => _AnimeScreenState();
}

class _AnimeScreenState extends State<AnimeScreen> {
  Anime anime;
  List<Episode> episodes;
  bool loading = true;

  void getAnimeDBData() async {
    dynamic dbAnime = await AnimeDatabaseService().getAnimeById(anime.id);
    if (dbAnime != null) setState(() => anime = dbAnime);
  }

  void getEpisodes() async {
    List response = await getJSONFromServer('/get-episodes', {
      'anime_id': anime.id.toString(),
      'anime_slug': anime.slug,
    });

    if (mounted)
      setState(() {
        episodes = new List<Episode>.from(
          response.map((list) => Episode(id: list[1], n: list[0])).toList(),
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
                          Shadow(color: Colors.black87, blurRadius: 10),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80,
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
                    bottom: 20,
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
