import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class StagedDrawer extends StatefulWidget {
  final Duration duration;
  final int size;
  final IndexedWidgetBuilder builder;

  const StagedDrawer(
      {Key key, @required this.duration, this.builder, this.size})
      : super(key: key);

  @override
  _StagedDrawerState createState() => _StagedDrawerState();
}

class _StagedDrawerState extends State<StagedDrawer>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _angleAnimation;
  final _perspectiveTween = Tween(begin: 0.0005, end: 0.0);
  final _backgroundColorTween =
      ColorTween(begin: Colors.orange, end: Colors.yellow);
  final _perspectiveAnimations = <Animation>[];
  final _backgroundColorAnimations = <Animation>[];
  bool _reverse = false;
  bool some = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);
    _angleAnimation = Tween(begin: -(pi / 2), end: 0.0).animate(_controller);
    _buildAnimationsForListItems(widget.size);

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          some = !some;
          _controller.forward();
        }));
  }

  void _buildAnimationsForListItems(int count) {
    final startingPoint = 0.7 / count;
    for (var index = 0; index < count; index++) {
      final curveAnimation = CurvedAnimation(
        parent: _controller,
        curve: Interval(
          startingPoint * index,
          startingPoint * index + 0.3,
          curve: Curves.linear,
        ),
      );
      _perspectiveAnimations.add(
        _perspectiveTween.animate(curveAnimation),
      );
      _backgroundColorAnimations.add(
        _backgroundColorTween.animate(curveAnimation),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _controller.reverse();
        return Future.delayed(widget.duration, () => true);
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, index) =>
            ListView.builder(
              itemCount: widget.size,
              itemBuilder: (context, index) {
                return _buildAnimation(index, widget.builder(context, index));
              },
            ),
      ),
    );
  }

  _buildAnimation(int index, Widget child) {
    final perspectiveAnimationValue = _perspectiveAnimations[index].value;
    return Transform(
      alignment: FractionalOffset.topLeft,
      transform: Matrix4.identity()
        ..rotateY(_angleAnimation.value)
        ..setEntry(3, 0, perspectiveAnimationValue),
      child: Container(
        color: _backgroundColorAnimations[index].value,
        child: child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
