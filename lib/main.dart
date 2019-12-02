import 'package:animu/pages/anime.dart';
import 'package:animu/pages/browse.dart';
import 'package:animu/pages/favorites.dart';
import 'package:animu/pages/info.dart';
import 'package:animu/pages/player.dart';
import 'package:animu/pages/splash_screen.dart';
import 'package:animu/utils/classes.dart';
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
        dialogTheme: DialogTheme(
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        fontFamily: 'Manrope',
      ),
      routes: {
        '/': (context) => TabsWrapper(),
        '/browse': (context) => Browse(),
        '/anime': (context) => AnimePage(),
        '/player': (context) => Player(),
        '/loading': (context) => SplashScreen(),
      },
      initialRoute: '/loading',
    );
  }
}

class TabsWrapper extends StatefulWidget {
  @override
  _TabsWrapperState createState() => _TabsWrapperState();
}

class _TabsWrapperState extends State<TabsWrapper> {
  int _currentIndex = 0;
  final tabs = <TabInfo>[
    TabInfo('Favoritos', Icons.favorite, Favorites()),
    TabInfo('Buscar', Icons.search, Browse()),
    TabInfo('Info', Icons.info, Info()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: tabs.map((tab) => tab.widget).toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
          },
          selectedItemColor: Colors.white,
          selectedIconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          unselectedItemColor: Theme.of(context).accentColor,
          showUnselectedLabels: false,
          items: tabs
              .map((tab) => BottomNavigationBarItem(
                    icon: Icon(tab.icon),
                    title: Text(tab.title),
                  ))
              .toList(),
        ));
  }
}
