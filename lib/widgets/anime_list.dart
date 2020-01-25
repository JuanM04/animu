import 'package:animu/models/anime.dart';
import 'package:animu/screens/anime/anime.dart';
import 'package:flutter/material.dart';

class AnimeList extends StatelessWidget {
  final List<Anime> animes;
  final String emptyLabel;
  AnimeList({this.animes, this.emptyLabel});

  @override
  Widget build(BuildContext context) {
    List<List<Anime>> rows = [];
    for (var i = 0; i < animes.length; i++) {
      if (i % 2 == 0) {
        rows.add([animes[i]]);
      } else {
        rows.last.add(animes[i]);
      }
    }

    if (animes.length > 0) {
      return ListView.builder(
        itemCount: rows.length,
        itemBuilder: (context, i) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rows[i]
              .map(
                (anime) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AnimeScreen(),
                        settings: RouteSettings(arguments: anime),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .433,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(7.5),
                            child: Image.memory(anime.cover),
                          ),
                          SizedBox(height: 5),
                          Text(
                            anime.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
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
