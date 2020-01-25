import 'package:animu/models/anime.dart';
import 'package:animu/services/requests.dart';
import 'package:animu/widgets/anime_list.dart';
import 'package:animu/widgets/search_bar.dart';
import 'package:animu/widgets/spinner.dart';
import 'package:flutter/material.dart';

class Browse extends StatefulWidget {
  @override
  _BrowseState createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  List<Anime> animes;
  bool loading = false;

  void getAnimes(String query) async {
    setState(() => loading = true);

    animes = await RequestsService.searchAnimes(query);

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
          icon: Icons.search,
          label: 'Buscá un anime en la barra superior',
        );
      }
    } else {
      return Spinner(size: 50);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Column(
            children: <Widget>[
              SearchBar(
                label: 'Buscar anime',
                callback: getAnimes,
                disabled: loading,
              ),
              SizedBox(height: 25),
              Expanded(child: bigContent()),
            ],
          ),
        ),
      ),
    );
  }
}
