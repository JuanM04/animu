import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  const DialogButton({Key key, this.label, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Text(
        label.toUpperCase(),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      textColor: Colors.white,
    );
  }
}
