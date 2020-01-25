import 'package:animu/utils/helpers.dart';
import 'package:animu/utils/models.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SeenUnseenButton extends StatelessWidget {
  final PlayerData data;

  const SeenUnseenButton(this.data, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Anime>('animes').listenable(),
      builder: (context, Box<Anime> box, _) {
        final seen =
            box.get(data.anime.id).episodesSeen.contains(data.currentEpisode.n);

        return IconButton(
          icon: Opacity(
            opacity: seen ? 1 : .33,
            child: Icon(Icons.remove_red_eye),
          ),
          onPressed: () => seenUnseen(data.anime, data.currentEpisode),
        );
      },
    );
  }
}
