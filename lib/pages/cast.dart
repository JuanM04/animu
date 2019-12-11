import 'package:animu/utils/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:ssh/ssh.dart';

class CastOptions {
  String ip;
  String port;
  String user;
  String password;
}

class CastScreen extends StatefulWidget {
  @override
  _CastScreenState createState() => _CastScreenState();
}

class _CastScreenState extends State<CastScreen> {
  final _storage = new FlutterSecureStorage();
  final _form = new GlobalKey<FormState>();
  var options = new CastOptions();
  bool loading = true;
  bool connecting = false;

  void getOptions() async {
    options.ip = await _storage.read(key: 'cast_ip') ?? '';
    options.port = await _storage.read(key: 'cast_port') ?? '22';
    options.user = await _storage.read(key: 'cast_user') ?? 'pi';
    options.password = await _storage.read(key: 'cast_password') ?? '';
    setState(() => loading = false);
  }

  @override
  void initState() {
    getOptions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ssh = Provider.of<SSHNotifier>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Form(
          key: _form,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .050 / 2,
                vertical: 20),
            child: loading
                ? SpinKitDoubleBounce(
                    color: Theme.of(context).accentColor,
                    size: 50,
                  )
                : Column(
                    children: <Widget>[
                      Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.warning,
                            size: 30,
                          ),
                          title: Text('Función en desarrollo'),
                          subtitle: Text(
                              'El modo Transmitir solo está disponible para dispositivos (usualmente una Raspberry Pi) con el reproductor OMXPlayer.'),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .6,
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Dirección IP'),
                              initialValue: options.ip,
                              maxLines: 1,
                              maxLength: 15,
                              keyboardType: TextInputType.number,
                              enabled: !connecting,
                              onChanged: (val) {
                                setState(() => options.ip = val);
                              },
                              validator: (val) =>
                                  RegExp(r'^(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)$')
                                          .hasMatch(val)
                                      ? null
                                      : 'Ingrese una IP válida',
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .3,
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Puerto SSH'),
                              initialValue: options.port.toString(),
                              maxLines: 1,
                              maxLength: 5,
                              keyboardType: TextInputType.number,
                              enabled: !connecting,
                              onChanged: (val) {
                                setState(() => options.port = val);
                              },
                              validator: (val) => RegExp(r'^\d+$').hasMatch(val)
                                  ? null
                                  : 'Ingrese un puerto válido',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .45,
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'Usuario'),
                              initialValue: options.user,
                              enabled: !connecting,
                              maxLines: 1,
                              onChanged: (val) {
                                setState(() => options.user = val);
                              },
                              validator: (val) =>
                                  val.isEmpty ? 'Ingrese un usuario' : null,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .45,
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Contraseña'),
                              initialValue: options.password,
                              enabled: !connecting,
                              obscureText: true,
                              maxLines: 1,
                              onChanged: (val) {
                                setState(() => options.password = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      ssh.isConnected
                          ? RaisedButton(
                              onPressed: ssh.disconnect,
                              child: Text('Desconectar'),
                            )
                          : (connecting
                              ? SpinKitDoubleBounce(
                                  color: Theme.of(context).accentColor,
                                  size: 30,
                                )
                              : RaisedButton(
                                  onPressed: () async {
                                    if (!_form.currentState.validate()) return;
                                    setState(() => connecting = true);

                                    await _storage.write(
                                        key: 'cast_ip', value: options.ip);
                                    await _storage.write(
                                        key: 'cast_port', value: options.port);
                                    await _storage.write(
                                        key: 'cast_user', value: options.user);
                                    await _storage.write(
                                        key: 'cast_password',
                                        value: options.password);

                                    var client = SSHClient(
                                      host: options.ip,
                                      port: int.parse(options.port),
                                      username: options.user,
                                      passwordOrKey: options.password,
                                    );
                                    try {
                                      await client.connect();
                                      await client.startShell();
                                      ssh.setClient(client);
                                    } catch (e) {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('Error conectándose'),
                                      ));
                                    }
                                    setState(() => connecting = false);
                                  },
                                  child: Text('Guardar y conectar'),
                                )),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
