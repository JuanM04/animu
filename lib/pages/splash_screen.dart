import 'package:animu/components/updater.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

  void initApp() async {
    if (await isOnline() == false) return;
    await checkUpdates();
    Navigator.pop(context);
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
