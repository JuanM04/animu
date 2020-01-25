import 'package:animu/models/anime.dart';
import 'package:animu/models/anime_genres.dart';
import 'package:animu/models/anime_types.dart';
import 'package:animu/services/requests.dart';
import 'package:animu/widgets/anime_list.dart';
import 'package:animu/widgets/dialog_button.dart';
import 'package:animu/widgets/spinner.dart';
import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  List<Anime> animes;
  List<AnimeGenre> genres = [];
  List<AnimeType> types = [];
  bool loading = false;

  void getAnimes() async {
    if (loading) return;
    setState(() => loading = true);

    animes = await RequestsService.exploreAnimes(
      genres: genres,
      types: types,
    );

    if (mounted) setState(() => loading = false);
  }

  Widget bigContent() {
    if (!loading) {
      if (animes != null) {
        return AnimeList(
          animes: animes,
          emptyLabel: 'Mala suerte, no se encontró nada',
        );
      } else {
        return NoDataInList(
          icon: Icons.explore,
          label: 'Encontrá animes',
        );
      }
    } else {
      return Spinner(size: 50);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.explore, size: 35),
        backgroundColor: loading
            ? Theme.of(context).accentColor
            : Theme.of(context).primaryColor,
        onPressed: getAnimes,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    child: Text('Género'),
                    onPressed: () {
                      if (loading) return;
                      showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setDialogState) => AlertDialog(
                              title: Text('Elegí los géneros'),
                              content: Container(
                                height: 300,
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 10,
                                    children: AnimeGenre.values
                                        .map((genre) => ChoiceChip(
                                              label: Text(genre.name),
                                              labelStyle:
                                                  TextStyle(fontSize: 12),
                                              labelPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              selected: genres.contains(genre),
                                              onSelected: (selected) {
                                                if (selected)
                                                  genres.add(genre);
                                                else
                                                  genres.remove(genre);
                                                setState(() {});
                                                setDialogState(() {});
                                              },
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                DialogButton(
                                  label: 'Salir',
                                  onPressed: () => Navigator.of(context).pop(),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  FlatButton(
                    child: Text('Tipo'),
                    onPressed: () {
                      if (loading) return;
                      showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setDialogState) => AlertDialog(
                              title: Text('Elegí los tipos'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: AnimeType.values
                                    .map((type) => ChoiceChip(
                                          label: Text(type.name),
                                          labelStyle: TextStyle(fontSize: 12),
                                          labelPadding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          selected: types.contains(type),
                                          onSelected: (selected) {
                                            if (selected)
                                              types.add(type);
                                            else
                                              types.remove(type);
                                            setState(() {});
                                            setDialogState(() {});
                                          },
                                        ))
                                    .toList(),
                              ),
                              actions: <Widget>[
                                DialogButton(
                                  label: 'Salir',
                                  onPressed: () => Navigator.of(context).pop(),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  )
                ],
              ),
              Divider(),
              Expanded(child: bigContent()),
            ],
          ),
        ),
      ),
    );
  }
}
