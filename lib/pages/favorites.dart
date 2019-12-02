import 'package:animu/components/anime_list.dart';
import 'package:animu/components/search_bar.dart';
import 'package:animu/utils/classes.dart';
import 'package:animu/utils/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<Anime> favorites;
  bool loading = false;

  void getFavorites(String query) async {
    setState(() => loading = true);
    favorites = await AnimeDatabase().searchFavorites(query);
    setState(() => loading = false);
  }

  @override
  void initState() {
    getFavorites('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Column(
            children: <Widget>[
              SearchBar(
                label: 'Buscar favoritos',
                callback: getFavorites,
                disabled: loading,
              ),
              SizedBox(height: 25),
              Expanded(
                child: loading
                    ? SpinKitDoubleBounce(
                        color: Theme.of(context).accentColor,
                        size: 50,
                      )
                    : AnimeList(
                        animes: favorites,
                        emptyLabel:
                            '¿Cómo que no hay nada en favoritos? Ya mismo buscás qué ver',
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
