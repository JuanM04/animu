import 'package:animu/models/anime_types.dart';
import 'package:flutter/material.dart';

class TypeBar extends StatelessWidget {
  final AnimeType type;

  const TypeBar(this.type, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: type.color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _TypeText(type.name),
          _TypeText(type.name),
        ],
      ),
    );
  }
}

class _TypeText extends StatelessWidget {
  final String type;

  const _TypeText(this.type, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: Text(
        type.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
