import 'package:animu/services/anime_database.dart';
import 'package:animu/utils/watching_states.dart';
import 'package:flutter/material.dart';

class Category {
  final String label;
  final IconData icon;
  final String searchBarLabel;
  final String emptyLabel;
  final Function(String query) dbFunction;

  Category({
    this.label,
    this.icon,
    this.searchBarLabel,
    this.emptyLabel,
    this.dbFunction,
  });
}

final List<Category> categories = WatchingState.values
        .map(
          (state) => Category(
            label: state.categoryName,
            icon: state.icon,
            searchBarLabel: state.categorySearchBarLabel,
            emptyLabel: state.categoryEmptyLabel,
            dbFunction: (String query) =>
                AnimeDatabaseService.searchByWatchingState(query, state),
          ),
        )
        .toList() +
    <Category>[
      Category(
        label: 'Favoritos',
        icon: Icons.favorite,
        searchBarLabel: 'Buscar tus animes favoritos',
        emptyLabel: 'No tenés corazón :c',
        dbFunction: (String query) =>
            AnimeDatabaseService.searchFavorites(query),
      ),
    ];
