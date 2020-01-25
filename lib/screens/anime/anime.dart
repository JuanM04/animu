import 'dart:math';

import 'package:animu/models/anime.dart';
import 'package:animu/models/episode.dart';
import 'package:animu/models/player_data.dart';
import 'package:animu/screens/anime/app_bar.dart';
import 'package:animu/screens/anime/episode_list.dart';
import 'package:animu/screens/anime/type_bar.dart';
import 'package:animu/screens/cast_player/cast_player.dart';
import 'package:animu/screens/player/player.dart';
import 'package:animu/services/requests.dart';
import 'package:animu/utils/helpers.dart';
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
  List<Episode> unloadedEpisodes;
  List<Episode> allEpisodes;
  bool firstLoaded = false;
  bool loadingNewEpisodes = false;
  var _scrollController = ScrollController();

  bool get moreEpisodesToLoad =>
      unloadedEpisodes != null && unloadedEpisodes.length > 0;

  bool get onlyEpisodesDataAviable =>
      allEpisodes != null && allEpisodes.length > 0;

  double positionFromBottom(int n) => n * 50.00 + (n + 1) * 20;

  void getAnimeDBData() async {
    dynamic dbAnime = AnimeDatabaseService.getAnimeById(anime.id);
    if (dbAnime != null) setState(() => anime = dbAnime);
  }

  void getEpisodes() async {
    allEpisodes = unloadedEpisodes = await RequestsService.getEpisodes(anime);
    if (mounted) await loadEpisodes();
    if (mounted) setState(() => firstLoaded = true);
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
            episodes: allEpisodes,
            currentEpisode: episode,
          ),
        ),
      ),
    );
  }

  Future loadEpisodes() async {
    if (!moreEpisodesToLoad) return;

    List<Episode> toLoad;
    if (unloadedEpisodes.length > 30) {
      toLoad = unloadedEpisodes.take(30).toList();
      unloadedEpisodes.removeRange(0, 30);
    } else {
      toLoad = unloadedEpisodes;
      unloadedEpisodes = [];
    }

    if (episodes == null) episodes = [];
    episodes.addAll(
      await RequestsService.getEpisodesThumbnails(anime.id, toLoad),
    );

    if (mounted) {
      setState(() {});
      loadingNewEpisodes = false;
    }
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 50 &&
          !loadingNewEpisodes) {
        loadingNewEpisodes = true;
        loadEpisodes();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (anime == null) {
      anime = ModalRoute.of(context).settings.arguments;
      getAnimeDBData();
    }
    if (allEpisodes == null) getEpisodes();

    final appBarExpandedHeight = MediaQuery.of(context).size.height / 3;

    return ValueListenableBuilder(
      valueListenable: Hive.box<Anime>('animes').listenable(),
      builder: (context, box, _) => Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.play_arrow, size: 35),
          backgroundColor: onlyEpisodesDataAviable
              ? Theme.of(context).primaryColor
              : Theme.of(context).accentColor,
          onPressed: () {
            if (!onlyEpisodesDataAviable) return;

            var nextEpisode =
                allEpisodes.firstWhere((episode) => episode.n == 1);

            if (anime.episodesSeen != null && anime.episodesSeen.length > 0) {
              // nextEpisode = the episode with the largest N + 1 or the last episode
              nextEpisode = allEpisodes.firstWhere(
                (episode) => episode.n == anime.episodesSeen.reduce(max) + 1,
                orElse: () =>
                    allEpisodes.reduce((a, b) => max(a.n, b.n) == a.n ? a : b),
              );
            }

            playEpisode(context, nextEpisode);
          },
        ),
        body: CustomScrollView(
          controller: _scrollController,
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
                  if (!firstLoaded)
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Spinner(size: 50),
                    ),
                ],
              ),
            ),
            if (firstLoaded && episodes.length > 0)
              EpisodeList(
                anime: anime,
                episodes: episodes,
                seenUnseen: (episode) => setState(() {
                  seenUnseen(anime, episode);
                  HapticFeedback.vibrate();
                }),
              ),
            if (moreEpisodesToLoad)
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Spinner(size: 20),
                  ),
                ]),
              ),
          ],
        ),
      ),
    );
  }
}
