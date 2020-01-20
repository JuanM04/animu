import 'package:flutter/material.dart';

// AIcon = AnimatedIcon
class AIcon extends StatefulWidget {
  final bool isInitialState;
  final AnimatedIconData icon;
  final double size;
  final Color color;

  const AIcon({
    Key key,
    this.isInitialState,
    this.icon,
    this.size,
    this.color,
  }) : super(key: key);

  @override
  _AIconState createState() => _AIconState();
}

class _AIconState extends State<AIcon> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  bool currentIsInitalState = true;
  // Initial State -- End State
  // Foward (Initial --> End)
  // Reverse (Initial <-- End)

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isInitialState != currentIsInitalState) {
      currentIsInitalState = !currentIsInitalState;

      if (widget.isInitialState)
        _animationController.reverse();
      else
        _animationController.forward();
    }
    return AnimatedIcon(
      icon: widget.icon,
      color: widget.color,
      size: widget.size,
      progress: _animationController,
    );
  }
}
