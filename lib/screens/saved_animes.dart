import 'package:animu/utils/categories.dart';
import 'package:animu/widgets/anime_list.dart';
import 'package:animu/widgets/dialog_button.dart';
import 'package:animu/widgets/search_bar.dart';
import 'package:animu/utils/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedAnimes extends StatefulWidget {
  @override
  _SavedAnimesState createState() => _SavedAnimesState();
}

class _SavedAnimesState extends State<SavedAnimes> {
  List<Anime> animes;
  bool loading = true;
  Category categorySelected;
  bool categoryHasChanged = false;

  void getAnimes(String query) async {
    setState(() => loading = true);
    animes = await categorySelected.dbFunction(query);
    if (mounted) setState(() => loading = false);
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      if (mounted)
        setState(() {
          categorySelected = categories[prefs.getInt('default_category_index')];
          categoryHasChanged = true;
        });
    });
    super.initState();
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
                      label: categorySelected != null
                          ? categorySelected.searchBarLabel
                          : '',
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
                          DialogButton(
                            label: 'Cancelar',
                            onPressed: () => Navigator.pop(context),
                          ),
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
