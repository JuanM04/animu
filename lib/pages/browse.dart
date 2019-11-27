import 'package:animu/components/anime_list.dart';
import 'package:animu/components/search_bar.dart';
import 'package:animu/utils/classes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Browse extends StatefulWidget {
  @override
  _BrowseState createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  List<Anime> animes;
  List<Anime> favorites;
  bool loading = false;

  void getAnimes(String query) async {
    setState(() => loading = true);

    Response response = await Dio().post(
      'https://animeflv.net/api/animes/search',
      options: Options(contentType: Headers.formUrlEncodedContentType),
      data: {'value': query},
    );

    setState(() {
      animes = new List<Anime>.from(response.data
          .map((map) => Anime(
              id: int.parse(map['id']), name: map['title'], slug: map['slug']))
          .toList());
      loading = false;
    });
  }

  Widget bigContent() {
    if (!loading) {
      if (animes != null) {
        return AnimeList(
          animes: animes,
          emptyLabel: 'No se han encontrado animes',
        );
      } else {
        if (favorites.isNotEmpty) {
          return AnimeList(
            animes: favorites,
            emptyLabel: '',
          );
        } else {
          return NoDataInList(
            icon: Icons.search,
            label: 'Busca un anime en la barra superior.',
          );
        }
      }
    } else {
      return SpinKitDoubleBounce(
        color: Colors.grey[600],
        size: 50,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments;
    favorites = args != null ? args : [];

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Column(
            children: <Widget>[
              SearchBar(
                label: 'Buscar Anime',
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
