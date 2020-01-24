import 'dart:convert';

import 'package:animu/services/error.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class VLCNotifier with ChangeNotifier {
  String ip;
  int port;
  String password;
  bool isConnected = false;

  Future<bool> init({String ip, int port, String password}) async {
    this.ip = ip;
    this.port = port;
    this.password = password;

    final res = await send(null);
    if (res != null) {
      isConnected = true;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> send(String command, {String input, String val}) async {
    try {
      Response response = await new Dio().get(
        'http://$ip:$port/requests/status.json',
        queryParameters: {
          'command': command,
          'input': input,
          'val': val,
        },
        options: Options(headers: {
          'Authorization': 'Basic ' + base64Encode(utf8.encode(':$password')),
        }),
      );
      return jsonDecode(response.data);
    } catch (e, s) {
      ErrorService.report(e, s);
      return null;
    }
  }

  void disconnect() {
    isConnected = false;
    notifyListeners();
  }
}
