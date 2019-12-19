import 'package:animu/utils/categories.dart';
import 'package:animu/widgets/dialog_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralSettings extends StatefulWidget {
  @override
  _GeneralSettingsState createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  SharedPreferences prefs;

  @override
  void initState() {
    SharedPreferences.getInstance().then((instance) {
      setState(() => prefs = instance);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('Categoría predeterminada'),
          subtitle:
              Text('Selecciona la categoría por defecto al abrir Mis Animes'),
          onTap: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('¿Qué deseás buscar?'),
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
                    selected: prefs.getInt('default_category_index') == index,
                    onSelected: (_) {
                      prefs.setInt('default_category_index', index).then((_) {
                        setState(() => Navigator.pop(context));
                      });
                    },
                  ),
                ).toList(),
              ),
              actions: <Widget>[
                DialogButton(
                  label: 'Cancelar',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
