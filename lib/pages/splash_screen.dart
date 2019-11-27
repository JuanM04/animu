import 'package:animu/utils/db.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void getFavorites() async {
    var favorites = await AnimeDatabase().getFavorites();
    print(favorites);
    Navigator.pushReplacementNamed(
      context,
      '/',
      arguments: favorites,
    );
  }

  @override
  void initState() {
    getFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Image.asset(
          'images/Name.png',
          width: MediaQuery.of(context).size.width * 0.8,
        ),
      ),
    );
  }
}
