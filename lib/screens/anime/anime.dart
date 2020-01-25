import 'dart:math';

import 'package:animu/screens/anime/app_bar.dart';
import 'package:animu/screens/anime/episode_list.dart';
import 'package:animu/screens/anime/type_bar.dart';
import 'package:animu/screens/cast_player/cast_player.dart';
import 'package:animu/screens/player/player.dart';
import 'package:animu/services/requests.dart';
import 'package:animu/utils/models.dart';
import 'package:animu/services/anime_database.dart';
import 'package:animu/utils/notifiers.dart';
import 'package:animu/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

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
    dynamic dbAnime = AnimeDatabaseService.getAnimeById(anime.id);
    if (dbAnime != null) setState(() => anime = dbAnime);
  }

  void getEpisodes() async {
    episodes = await RequestsService.getEpisodes(anime);
    if (mounted) setState(() => loading = false);
  }

  void playEpisode(BuildContext context, Episode episode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Provider.of<VLCNotifier>(context).isConnected
            ? CastPlayer()
            : Player(),
        settings: RouteSettings(
          arguments: PlayerData(
            anime: anime,
            episodes: episodes,
            currentEpisode: episode,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (anime == null) {
      anime = ModalRoute.of(context).settings.arguments;
      getAnimeDBData();
    }
    if (episodes == null) getEpisodes();

    final appBarExpandedHeight = MediaQuery.of(context).size.height / 3;

    return ValueListenableBuilder(
      valueListenable: Hive.box<Anime>('animes').listenable(),
      builder: (context, box, _) => Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.play_arrow, size: 35),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            var nextEpisode = episodes.firstWhere((episode) => episode.n == 1);

            if (anime.episodesSeen != null && anime.episodesSeen.length > 0) {
              // nextEpisode = the episode with the largest N + 1 or the last episode
              nextEpisode = episodes.firstWhere(
                (episode) => episode.n == anime.episodesSeen.reduce(max) + 1,
                orElse: () =>
                    episodes.reduce((a, b) => max(a.n, b.n) == a.n ? a : b),
              );
            }

            playEpisode(context, nextEpisode);
          },
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              delegate: AnimeAppBar(
                expandedHeight: appBarExpandedHeight,
                parentContext: context,
                anime: anime,
              ),
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  TypeBar(anime.type),
                  SizedBox(height: appBarExpandedHeight / 5),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      anime.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        letterSpacing: 1,
                        height: 1.25,
                      ),
                    ),
                  ),
                  if (loading)
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Spinner(size: 50),
                    ),
                ],
              ),
            ),
            if (!loading)
              EpisodeList(
                anime: anime,
                episodes: episodes,
                seenUnseen: (episode) {
                  if (anime.episodesSeen == null) anime.episodesSeen = [];
                  if (anime.episodesSeen.contains(episode.n))
                    anime.episodesSeen.remove(episode.n);
                  else
                    anime.episodesSeen.add(episode.n);
                  AnimeDatabaseService.updateAnime(anime);
                  HapticFeedback.vibrate();
                },
                swapOrder: () {
                  setState(() => episodes = episodes.reversed.toList());
                },
              ),
          ],
          /*       child: SafeArea(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: ,
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
                                                onSelected: (changed) {
                                                  if (!changed) return;
                                                  anime.watchingState = state;
                                                  AnimeDatabaseService.updateAnime(
                                                      anime);
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
                                          onPressed: () {
                                            anime.watchingState = null;
                                            AnimeDatabaseService.updateAnime(anime);
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
                                onPressed: () {
                                  anime.favorite = !anime.favorite;
                                  AnimeDatabaseService.updateAnime(anime);
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
                    Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text(
                          anime.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                            letterSpacing: 1,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.red,
                    ),
                    Expanded(
                      child: !loading
                          ? EpisodeList(
                              anime: anime,
                              episodes: episodes,
                              seenUnseen: (episode) {
                                if (anime.episodesSeen == null) anime.episodesSeen = [];
                                if (anime.episodesSeen.contains(episode.n))
                                  anime.episodesSeen.remove(episode.n);
                                else
                                  anime.episodesSeen.add(episode.n);
                                AnimeDatabaseService.updateAnime(anime);
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
               ), */
        ),
      ),
    );
  }
}
