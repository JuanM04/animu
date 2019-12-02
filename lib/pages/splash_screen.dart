import 'package:animu/components/updater.dart';
import 'package:animu/utils/db.dart';
import 'package:animu/utils/helpers.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:package_info/package_info.dart';
import 'package:pub_semver/pub_semver.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
    var response =
        await dio.get('https://api.github.com/repos/JuanM04/animu/releases');

    Map lastRelease = response.data[0];

    var latestVersion = Version.parse(lastRelease['tag_name'].substring(1));
    var currentVersion =
        Version.parse((await PackageInfo.fromPlatform()).version);

    if (latestVersion.compareTo(currentVersion) > 0 &&
        lastRelease['assets'].length > 0)
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Updater(
          currentVersion: currentVersion,
          latestVersion: latestVersion,
          downloadURL: lastRelease['assets'][0]['browser_download_url'],
        ),
      );
  }

  Future<void> checkCloudflare() async {
    try {
      await Dio().post('https://animeflv.net/api/animes/search');
    } catch (e) {
      if (e.response.statusCode == 503)
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(
                'AnimeFLV es re ortvia, y por eso tenés que apretar este botón y esperar un par de segundos. Si sigue sin funcionar, tenés que esperar hasta un día :)'),
            actions: <Widget>[
              dialogButton(
                'Este botón',
                () =>
                    FlutterWebBrowser.openWebPage(url: 'https://animeflv.net'),
              ),
            ],
          ),
        );
    }
  }

  void initApp() async {
    if (await isOnline() == false) return;
    await checkUpdates();
    await checkCloudflare();

    final favorites = await AnimeDatabase().getFavorites();
    Navigator.pushReplacementNamed(
      context,
      '/',
      arguments: favorites,
    );
  }

  @override
  void initState() {
    initApp();
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
