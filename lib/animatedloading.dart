import 'package:flutter/material.dart';

class AnimatedAppBar extends StatefulWidget implements PreferredSizeWidget {
  /// Preferred size of this widget for Scaffold
  final double _preferredHeight = 10.0;

  @override
  _AnimatedAppBarState createState() => _AnimatedAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(_preferredHeight);
}

class _AnimatedAppBarState extends State<AnimatedAppBar>
    with SingleTickerProviderStateMixin {
  /// Main [AnimationController] that will be used to manipulate our animation
  AnimationController _animationController;

  /// Rotation [Animation] that'll be passed to [RotationTransition]
  Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    /// Initializing our AnimationController
    /// Longer duration means slower rotations and vice versa.
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 90));

    /// Initializing our rotate animation
    /// We use [Curves.linear] so that our animation plays out evenly.
    _rotateAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear);

    /// Telling our animation to repeat indefinitely.
    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Align(
        heightFactor: 1.5,
        alignment: Alignment.center,
        child: RotationTransition(
          turns: _rotateAnimation,
          child: Image.asset("assets/images/logo.png", width: 120, height: 60),
        ),
      ),
    );
  }
}
