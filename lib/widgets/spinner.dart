import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Spinner extends StatelessWidget {
  final double size;
  const Spinner({Key key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitDoubleBounce(
      color: Theme.of(context).accentColor,
      size: size,
    );
  }
}
