import 'package:animu/screens/splash_screen/updater.dart';
import 'package:animu/services/anime_database.dart';
import 'package:animu/utils/anime_types.dart';
import 'package:animu/utils/global.dart';
import 'package:animu/utils/models.dart';
import 'package:animu/utils/watching_states.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:pub_semver/pub_semver.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String message = '';

  Future run({Future function(), String msg}) {
    setState(() => message = msg);
    return function();
  }

  Future<bool> isOnline() async {
    var connection = await Connectivity().checkConnectivity();
    bool connected = ConnectivityResult.none != connection;

    if (!connected)
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Sin conexión a internet'),
          content: Text(
              'Decime: ¿cómo pensás ver anime sin internet? En serio te pregunto'),
        ),
      );

    return connected;
  }

  Future<void> checkUpdates() async {
    var dio = new Dio();
    var response = await dio
        .get('https://api.github.com/repos/${Global.repo}/releases/latest');

    Map lastRelease = response.data;

    var latestVersion = Version.parse(lastRelease['tag_name'].substring(1));
    var currentVersion =
        Version.parse((await PackageInfo.fromPlatform()).version);

    if (latestVersion.compareTo(currentVersion) > 0 &&
        lastRelease['assets'].length > 0) {
      final abis = (await DeviceInfoPlugin().androidInfo).supportedAbis;

      for (var abi in abis) {
        final assetIndex = lastRelease['assets']
            .indexWhere((asset) => asset['name'].toString().contains(abi));

        if (assetIndex > -1) {
          return await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Updater(
              currentVersion: currentVersion,
              latestVersion: latestVersion,
              downloadURL: lastRelease['assets'][assetIndex]
                  ['browser_download_url'],
            ),
          );
        }
      }
    }
  }

  Future<void> setDefaultSettings() async {
    await Hive.initFlutter();

    void setDefaultSetting(Box box, String key, dynamic defaultValue) {
      if (box.get(key) == null) box.put(key, defaultValue);
    }

    final settingsBox = await Hive.openBox('settings');
    setDefaultSetting(settingsBox, 'cast_ip', '192.168.0.1');
    setDefaultSetting(settingsBox, 'cast_port', '8080');
    setDefaultSetting(settingsBox, 'cast_password', '');
    setDefaultSetting(settingsBox, 'default_category_index', 1);
    setDefaultSetting(settingsBox, 'server_index', 0);
    setDefaultSetting(settingsBox, 'mark_as_seen_when_next_episode', true);
    setDefaultSetting(
        settingsBox, 'anime_database_version', AnimeDatabaseService.version);

    Hive.registerAdapter(AnimeAdapter());
    Hive.registerAdapter(WatchingStateAdapter());
    Hive.registerAdapter(AnimeTypeAdapter());
    await Hive.openBox<Anime>('animes');
  }

  Future<void> upgradeAnimeDatabase() async {
    Box settingsBox = Hive.box('settings');
    final currentVersion = settingsBox.get('anime_database_version');
    final lastVersion = AnimeDatabaseService.version;

    if (currentVersion < lastVersion) {
      bool applyUpgrade(int version) =>
          currentVersion < version && lastVersion >= version;

      if (applyUpgrade(2)) {
        final animes = Hive.box<Anime>('animes').values;
        await Future.wait(animes.map(AnimeDatabaseService.upgradeAnimeVersion));
        settingsBox.put('anime_database_version', 2);
      }
    }
  }

  void initApp() async {
    if (await isOnline() == false) return;

    await run(
      function: checkUpdates,
      msg: 'Buscando actualizaciones...',
    );
    await run(
      function: setDefaultSettings,
      msg: 'Verificando configuración...',
    );
    await run(
      function: upgradeAnimeDatabase,
      msg: 'Actualizando base de datos...',
    );

    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void initState() {
    initApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              'images/Name.png',
              width: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Text(message),
            ),
          ),
        ],
      ),
    );
  }
}
