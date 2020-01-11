import 'package:animu/services/sources.dart';
import 'package:animu/utils/categories.dart';
import 'package:animu/widgets/dialog_button.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GeneralSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('settings').listenable(),
      builder: (context, box, _) => ListView(
        children: <Widget>[
          ListTile(
            title: Text('Categoría predeterminada'),
            subtitle:
                Text('Selecciona la categoría por defecto al abrir Mis Animes'),
            onTap: () => showDialog(
              context: context,
              builder: (context) => _DefaultCategory(),
            ),
          ),
          ListTile(
            title: Text('Servidor'),
            subtitle: Text('Selecciona el servidor para ver anime'),
            onTap: () => showDialog(
              context: context,
              builder: (context) => _Server(),
            ),
          ),
          SwitchListTile(
            activeColor: Theme.of(context).primaryColor,
            title: Text('Marcar como visto automáticamente'),
            subtitle: Text(
                'Marcar un episodio como visto al pasar al siguiente desde los controles'),
            value: box.get('mark_as_seen_when_next_episode'),
            onChanged: (value) {
              box.put('mark_as_seen_when_next_episode', value);
            },
          ),
        ],
      ),
    );
  }
}

class _DefaultCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('settings').listenable(),
      builder: (context, box, _) => AlertDialog(
        title: Text('Categoría predeterminada'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List<Widget>.generate(
            categories.length,
            (int index) => ChoiceChip(
              avatar: Icon(categories[index].icon, size: 18),
              label: Text(
                categories[index].label,
                style: TextStyle(color: Colors.white),
              ),
              selected: box.get('default_category_index') == index,
              onSelected: (_) {
                box.put('default_category_index', index);
              },
            ),
          ).toList(),
        ),
        actions: <Widget>[
          DialogButton(
            label: 'Salir',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class _Server extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('settings').listenable(),
      builder: (context, box, _) => AlertDialog(
        title: Text('Selecciona un servidor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: servers
              .map((server) => RadioListTile<int>(
                    title: Text(server.title),
                    value: servers.indexOf(server),
                    activeColor: Theme.of(context).primaryColor,
                    groupValue: box.get('server_index'),
                    onChanged: (index) {
                      box.put('server_index', index);
                    },
                  ))
              .toList(),
        ),
        actions: <Widget>[
          DialogButton(
            label: 'Salir',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
