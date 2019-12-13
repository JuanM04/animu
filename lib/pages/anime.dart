import 'package:animu/components/episode_list.dart';
import 'package:animu/utils/classes.dart';
import 'package:animu/utils/db.dart';
import 'package:animu/utils/helpers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WatchingStateWithProps {
  final WatchingState watchingState;
  final String name;
  final IconData icon;
  WatchingStateWithProps({this.watchingState, this.name, this.icon});
}

final watchingStates = <WatchingStateWithProps>[
  WatchingStateWithProps(
    watchingState: WatchingState.toWatch,
    name: 'Para ver',
    icon: Icons.bookmark,
  ),
  WatchingStateWithProps(
    watchingState: WatchingState.watching,
    name: 'Viendo',
    icon: Icons.play_circle_outline,
  ),
  WatchingStateWithProps(
    watchingState: WatchingState.watched,
    name: 'Visto',
    icon: Icons.remove_red_eye,
  ),
  WatchingStateWithProps(
    watchingState: null,
    name: 'Ninguno',
    icon: Icons.bookmark_border,
  ),
];

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
    List response = await getJSONFromServer('/get-episodes', {
      'anime_id': anime.id.toString(),
      'anime_slug': anime.slug,
    });

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
                    child: animePageButton(
                      backgroundColor: Theme.of(context).backgroundColor,
                      child: IconButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Cambiar el estado del anime'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List<Widget>.generate(
                                watchingStates.length,
                                (int index) => ChoiceChip(
                                  avatar: Icon(watchingStates[index].icon,
                                      size: 18),
                                  label: Text(
                                    watchingStates[index].name,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  selected: anime.watchingState ==
                                      watchingStates[index].watchingState,
                                  onSelected: (changed) async {
                                    if (!changed) return;
                                    anime.watchingState =
                                        watchingStates[index].watchingState;
                                    await AnimeDatabase().updateAnime(anime);
                                    setState(() => Navigator.pop(context));
                                  },
                                ),
                              ).toList(),
                            ),
                            actions: <Widget>[
                              dialogButton(
                                  'Cancelar', () => Navigator.pop(context)),
                            ],
                          ),
                        ),
                        icon: Icon(watchingStates
                            .firstWhere(
                                (x) => x.watchingState == anime.watchingState)
                            .icon),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 0,
                    child: animePageButton(
                      backgroundColor: Theme.of(context).primaryColor,
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
