import 'package:animu/components/anime_list.dart';
import 'package:animu/components/search_bar.dart';
import 'package:animu/utils/classes.dart';
import 'package:animu/utils/db.dart';
import 'package:animu/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

final categories = <Category>[
  Category(
    label: 'Viendo',
    icon: Icons.play_circle_outline,
    searchBarLabel: 'Buscar animes que estás viendo',
    emptyLabel: '¿Cómo que no estás viendo nada? Ya mismo buscás qué ver',
    dbFunction: (String query) async => await AnimeDatabase()
        .searchByWatchingState(query, WatchingState.watching),
  ),
  Category(
    label: 'Para ver',
    icon: Icons.bookmark,
    searchBarLabel: 'Buscar tus animes que para ver',
    emptyLabel:
        'Acá se guardan, por ejemplo, las recomendaciones de tus ami-... lo lamento',
    dbFunction: (String query) async => await AnimeDatabase()
        .searchByWatchingState(query, WatchingState.toWatch),
  ),
  Category(
    label: 'Vistos',
    icon: Icons.remove_red_eye,
    searchBarLabel: 'Buscar animes que viste',
    emptyLabel: 'Apurando, vieja, que hay mucho que ver',
    dbFunction: (String query) async => await AnimeDatabase()
        .searchByWatchingState(query, WatchingState.watched),
  ),
  Category(
    label: 'Favoritos',
    icon: Icons.favorite,
    searchBarLabel: 'Buscar tus animes favoritos',
    emptyLabel: 'No tenés corazón :c',
    dbFunction: (String query) async =>
        await AnimeDatabase().searchFavorites(query),
  ),
];

class SavedAnimes extends StatefulWidget {
  @override
  _SavedAnimesState createState() => _SavedAnimesState();
}

class _SavedAnimesState extends State<SavedAnimes> {
  List<Anime> animes;
  bool loading = false;
  Category categorySelected = categories[3];
  bool categoryHasChanged = true;

  void getAnimes(String query) async {
    setState(() => loading = true);
    animes = await categorySelected.dbFunction(query);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (categoryHasChanged) {
      getAnimes('');
      setState(() => categoryHasChanged = false);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: SearchBar(
                      label: categorySelected.searchBarLabel,
                      callback: getAnimes,
                      disabled: loading,
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    child: Icon(Icons.category),
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('¿Qué deseás buscar?'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List<Widget>.generate(
                            categories.length,
                            (int index) => ChoiceChip(
                              avatar: Icon(categories[index].icon, size: 18),
                              label: Text(
                                categories[index].label,
                                style: TextStyle(color: Colors.white),
                              ),
                              selected: categorySelected == categories[index],
                              onSelected: (_) => setState(() {
                                categorySelected = categories[index];
                                categoryHasChanged = true;
                                Navigator.pop(context);
                              }),
                            ),
                          ).toList(),
                        ),
                        actions: <Widget>[
                          dialogButton(
                              'Cancelar', () => Navigator.pop(context)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Expanded(
                child: loading
                    ? SpinKitDoubleBounce(
                        color: Theme.of(context).accentColor,
                        size: 50,
                      )
                    : AnimeList(
                        animes: animes,
                        emptyLabel: categorySelected.emptyLabel,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
