import 'package:animu/screens/splash_screen/updater.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    var response = await dio
        .get('https://api.github.com/repos/JuanM04/animu/releases/latest');

    Map lastRelease = response.data;

    var latestVersion = Version.parse(lastRelease['tag_name'].substring(1));
    var currentVersion =
        Version.parse((await PackageInfo.fromPlatform()).version);

    if (latestVersion.compareTo(currentVersion) > 0 &&
        lastRelease['assets'].length > 0) {
      final abis = (await DeviceInfoPlugin().androidInfo).supportedAbis;

      for (var abi in abis) {
        final assetIndex = lastRelease['assets']
            .indexWhere((asset) => asset['name'].contains(abi));

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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getInt('default_category_index') == null)
      await prefs.setInt('default_category_index', 1);
    if (prefs.getInt('server_index') == null)
      await prefs.setInt('server_index', 0);
  }

  void initApp() async {
    if (await isOnline() == false) return;
    await checkUpdates();
    await setDefaultSettings();
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
