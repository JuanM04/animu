import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  const MainButton({Key key, this.backgroundColor, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(12.5)),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 5,
            )
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}
