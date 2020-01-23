import 'package:animu/screens/browse.dart';
import 'package:animu/screens/saved_animes.dart';
import 'package:animu/screens/settings/settings.dart';
import 'package:animu/screens/splash_screen/splash_screen.dart';
import 'package:animu/services/backup.dart';
import 'package:animu/utils/notifiers.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TabInfo {
  final String title;
  final IconData icon;
  final Widget widget;
  TabInfo(this.title, this.icon, this.widget);
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final primaryColor = Color(0xFFBF3030); // Strawberry Red

    final analytics = FirebaseAnalytics();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<VLCNotifier>.value(value: VLCNotifier()),
        StreamProvider<FirebaseUser>.value(value: BackupService.userStream),
      ],
      child: MaterialApp(
        title: 'Animú',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: primaryColor,
          accentColor: Colors.grey[600],
          backgroundColor: Colors.grey[900],
          scaffoldBackgroundColor: Colors.grey[900],
          dialogTheme: DialogTheme(
            titleTextStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: primaryColor,
            textTheme: ButtonTextTheme.primary,
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: Colors.grey[800],
            contentTextStyle: TextStyle(
              color: Colors.white,
            ),
          ),
          cursorColor: primaryColor,
          textSelectionHandleColor: primaryColor,
          fontFamily: 'Manrope',
        ),
        routes: {
          '/': (context) => SplashScreen(),
          '/home': (context) => TabsWrapper(),
        },
        initialRoute: '/',
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
      ),
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
    TabInfo('Mis animes', Icons.bookmark, SavedAnimes()),
    TabInfo('Buscar', Icons.search, Browse()),
    TabInfo('Opciones', Icons.settings, SettingsIndex()),
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
