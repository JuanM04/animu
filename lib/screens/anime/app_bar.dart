import 'dart:ui';

import 'package:animu/models/anime.dart';
import 'package:animu/models/watching_states.dart';
import 'package:animu/services/anime_database.dart';
import 'package:animu/widgets/dialog_button.dart';
import 'package:flutter/material.dart';

class AnimeAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final BuildContext parentContext;
  final Anime anime;

  AnimeAppBar({this.expandedHeight, this.parentContext, this.anime});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        Container(
          color: Colors.black,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight) * (1 - .33) + .33,
            child: Image.memory(
              anime.banner,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              0,
              MediaQuery.of(parentContext).padding.top,
              10,
              0,
            ),
            child: SizedBox(
              height: kToolbarHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  BackButton(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          anime.watchingState == null
                              ? Icons.bookmark_border
                              : anime.watchingState.icon,
                        ),
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
                                          AnimeDatabaseService.updateAnime(
                                              anime..watchingState = state);
                                          Navigator.pop(context);
                                        },
                                      ))
                                  .toList(),
                            ),
                            actions: <Widget>[
                              if (anime.watchingState != null)
                                DialogButton(
                                  label: 'Eliminar estado',
                                  onPressed: () {
                                    AnimeDatabaseService.updateAnime(
                                        anime..watchingState = null);
                                    Navigator.pop(context);
                                  },
                                ),
                              DialogButton(
                                label: 'Cancelar',
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          anime.favorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                        onPressed: () => AnimeDatabaseService.updateAnime(
                          anime..favorite = !anime.favorite,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: expandedHeight / 4 - shrinkOffset,
          left: MediaQuery.of(context).size.width / 4,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    spreadRadius: 5,
                    blurRadius: 10,
                  )
                ],
              ),
              child: SizedBox(
                height: expandedHeight,
                width: MediaQuery.of(context).size.width / 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7.5),
                  child: Image.memory(anime.cover),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent =>
      kToolbarHeight + MediaQuery.of(parentContext).padding.top;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
