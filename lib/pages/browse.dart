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
          emptyLabel: 'Mala suerte, no se encontró nada',
        );
      } else {
        return NoDataInList(
          icon: Icons.search,
          label: 'Buscá un anime en la barra superior',
        );
      }
    } else {
      return SpinKitDoubleBounce(
        color: Theme.of(context).accentColor,
        size: 50,
      );
    }
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
