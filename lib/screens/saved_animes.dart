import 'package:animu/utils/categories.dart';
import 'package:animu/widgets/anime_list.dart';
import 'package:animu/widgets/dialog_button.dart';
import 'package:animu/widgets/search_bar.dart';
import 'package:animu/utils/models.dart';
import 'package:animu/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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
    final settings = Hive.box('settings');
    setState(() {
      categorySelected = categories[settings.get('default_category_index')];
      categoryHasChanged = true;
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
                    ? Spinner(size: 50)
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
