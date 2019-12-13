import 'package:animu/pages/settings/cast.dart';
import 'package:animu/pages/settings/about.dart';
import 'package:flutter/material.dart';

class Setting {
  final String name;
  final IconData icon;
  final Widget widget;
  Setting({this.name, this.icon, this.widget});
}

class SettingsIndex extends StatelessWidget {
  final settings = <Setting>[
    Setting(
      name: 'Trasmitir',
      icon: Icons.cast,
      widget: CastScreen(),
    ),
    Setting(
      name: 'Acerca de',
      icon: Icons.info,
      widget: About(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView.builder(
        itemCount: settings.length,
        itemBuilder: (context, i) => ListTile(
          leading: Icon(settings[i].icon),
          title: Text(
            settings[i].name,
            style: TextStyle(fontSize: 18),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Scaffold(
                  backgroundColor: Theme.of(context).backgroundColor,
                  appBar: AppBar(
                    title: Text(settings[i].name),
                  ),
                  body: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            MediaQuery.of(context).size.width * .050 / 2,
                        vertical: 20,
                      ),
                      child: settings[i].widget,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
