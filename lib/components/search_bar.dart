import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final String label;
  final bool disabled;
  final Function callback;
  SearchBar({this.callback, this.label, this.disabled});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: callback,
      decoration: InputDecoration(labelText: label),
      textInputAction: TextInputAction.done,
      enabled: !disabled,
      cursorColor: Theme.of(context).primaryColor,
    );
  }
}
