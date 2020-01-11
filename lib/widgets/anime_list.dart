import 'package:animu/screens/anime/anime.dart';
import 'package:animu/services/requests.dart';
import 'package:animu/utils/helpers.dart';
import 'package:animu/utils/models.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimeList extends StatelessWidget {
  final List<Anime> animes;
  final String emptyLabel;
  AnimeList({this.animes, this.emptyLabel});

  @override
  Widget build(BuildContext context) {
    final requestsService = Provider.of<RequestsService>(context);

    if (animes.length > 0) {
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: .56,
        crossAxisSpacing: 30,
        children: List.generate(
          animes.length,
          (i) => GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AnimeScreen(),
                  settings: RouteSettings(arguments: animes[i]),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(7.5),
                  child: Image.network(
                    getImageURL(ImageURLType.cover, anime: animes[i]),
                    headers: requestsService.headers,
                  ),
                ),
                SizedBox(height: 5),
                AutoSizeText(
                  animes[i].name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return NoDataInList(
        icon: Icons.error,
        label: emptyLabel,
      );
    }
  }
}

class NoDataInList extends StatelessWidget {
  final IconData icon;
  final String label;
  NoDataInList({this.icon, this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 50,
          color: Theme.of(context).accentColor,
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w300,
            color: Theme.of(context).accentColor,
          ),
        )
      ],
    );
  }
}
