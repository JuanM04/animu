import 'package:flutter/material.dart';

enum WatchingState { toWatch, watching, watched }

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

  int get n {
    switch (this) {
      case WatchingState.toWatch:
        return 1;
      case WatchingState.watching:
        return 2;
      case WatchingState.watched:
        return 3;
      default:
        return 0;
    }
  }
}

WatchingState intToWatchingState(int n) {
  for (var state in WatchingState.values) {
    if (state.n == n) return state;
  }
  return null;
}
