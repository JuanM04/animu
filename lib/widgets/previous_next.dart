import 'package:animu/utils/models.dart';
import 'package:flutter/material.dart';

enum PreviousNextType { previous, next }

class PreviousNext extends StatelessWidget {
  final PreviousNextType type;
  final PlayerData data;
  final Function(Episode episode) changeEpisode;
  PreviousNext({this.type, this.data, this.changeEpisode});

  @override
  Widget build(BuildContext context) {
    final isPrevious = type == PreviousNextType.previous;
    int difference = isPrevious ? -1 : 1;
    int index = data.episodes
        .indexWhere((e) => e.n == data.currentEpisode.n + difference);

    if (index == -1)
      return SizedBox(width: 50);
    else
      return GestureDetector(
        onTap: () => changeEpisode(data.episodes[index]),
        child: Icon(
          isPrevious ? Icons.skip_previous : Icons.skip_next,
          size: 50,
        ),
      );
  }
}
