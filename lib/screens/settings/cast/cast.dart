import 'package:animu/screens/settings/cast/guide.dart';
import 'package:animu/utils/notifiers.dart';
import 'package:animu/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class CastOptions {
  String ip;
  String port;
  String password;

  CastOptions({this.ip, this.port, this.password});
}

class CastScreen extends StatefulWidget {
  @override
  _CastScreenState createState() => _CastScreenState();
}

class _CastScreenState extends State<CastScreen> {
  final _form = new GlobalKey<FormState>();
  var options = new CastOptions();
  bool connecting = false;

  @override
  void initState() {
    final settingsBox = Hive.box('settings');
    setState(() {
      options = CastOptions(
        ip: settingsBox.get('cast_ip'),
        port: settingsBox.get('cast_port'),
        password: settingsBox.get('cast_password'),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final vlc = Provider.of<VLCNotifier>(context);

    return Form(
      key: _form,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CastGuide()),
              );
            },
            child: Card(
              child: ListTile(
                leading: Icon(Icons.info, size: 30),
                title: Text('Cómo configurar'),
                subtitle: Text(
                    'Tocá acá para ver cómo configurar el modo Transmitir'),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * .6,
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Dirección IP'),
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
                  decoration: InputDecoration(labelText: 'Puerto'),
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
          TextFormField(
            decoration: InputDecoration(labelText: 'Contraseña'),
            initialValue: options.password,
            enabled: !connecting,
            obscureText: true,
            maxLines: 1,
            onChanged: (val) {
              setState(() => options.password = val);
            },
          ),
          SizedBox(height: 50),
          vlc.isConnected
              ? RaisedButton(
                  onPressed: vlc.disconnect,
                  child: Text('Desconectar'),
                )
              : (connecting
                  ? Spinner(size: 30)
                  : RaisedButton(
                      onPressed: () async {
                        if (!_form.currentState.validate()) return;
                        setState(() => connecting = true);

                        Hive.box('settings').putAll({
                          'cast_ip': options.ip,
                          'cast_port': options.port,
                          'cast_password': options.password,
                        });

                        final connected = await vlc.init(
                          ip: options.ip,
                          port: int.parse(options.port),
                          password: options.password,
                        );
                        if (!connected)
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('Error conectándose'),
                          ));
                        setState(() => connecting = false);
                      },
                      child: Text('Guardar y conectar'),
                    )),
        ],
      ),
    );
  }
}
