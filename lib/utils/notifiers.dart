import 'package:flutter/foundation.dart';
import 'package:ssh/ssh.dart';

class SSHNotifier with ChangeNotifier {
  SSHClient client;

  bool get isConnected => client != null;

  void setClient(SSHClient newClient) {
    client = newClient;
    notifyListeners();
  }

  void disconnect() async {
    await client.disconnect();
    client = null;
    notifyListeners();
  }
}
