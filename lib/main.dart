import 'package:animu/pages/anime.dart';
import 'package:animu/pages/browse.dart';
import 'package:animu/pages/player.dart';
import 'package:animu/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Animú',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFFBF3030), // Strawberry Red
        accentColor: Colors.grey[600],
        backgroundColor: Colors.grey[900],
        fontFamily: 'Manrope',
      ),
      routes: {
        '/': (context) => Browse(),
        '/anime': (context) => AnimePage(),
        '/player': (context) => Player(),
        '/loading': (context) => SplashScreen(),
      },
      initialRoute: '/loading',
    );
  }
}
