import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'watching_states.g.dart';

@HiveType(typeId: 1)
enum WatchingState {
  @HiveField(0)
  toWatch,
  @HiveField(1)
  watching,
  @HiveField(2)
  watched
}

const watchingStateString = {
  WatchingState.toWatch: 'toWatch',
  WatchingState.watching: 'watching',
  WatchingState.watched: 'watched',
};

extension WatchingStateExtension on WatchingState {
  String get name {
    switch (this) {
      case WatchingState.toWatch:
        return 'Para ver';
      case WatchingState.watching:
        return 'Viendo';
      case WatchingState.watched:
        return 'Visto';
      default:
        return null;
    }
  }

  String get categoryName {
    switch (this) {
      case WatchingState.toWatch:
        return 'Para ver';
      case WatchingState.watching:
        return 'Viendo';
      case WatchingState.watched:
        return 'Vistos';
      default:
        return null;
    }
  }

  String get categorySearchBarLabel {
    switch (this) {
      case WatchingState.toWatch:
        return 'Buscar tus animes que para ver';
      case WatchingState.watching:
        return 'Buscar animes que estás viendo';
      case WatchingState.watched:
        return 'Buscar animes que viste';
      default:
        return null;
    }
  }

  String get categoryEmptyLabel {
    switch (this) {
      case WatchingState.toWatch:
        return 'Acá se guardan, por ejemplo, las recomendaciones de tus ami-... lo lamento';
      case WatchingState.watching:
        return '¿Cómo que no estás viendo nada? Ya mismo buscás qué ver';
      case WatchingState.watched:
        return 'Apurando, vieja, que hay mucho que ver';
      default:
        return null;
    }
  }

  IconData get icon {
    switch (this) {
      case WatchingState.toWatch:
        return Icons.bookmark;
      case WatchingState.watching:
        return Icons.play_circle_outline;
      case WatchingState.watched:
        return Icons.remove_red_eye;
      default:
        return null;
    }
  }
}
