import 'dart:math';

import 'package:flutter/material.dart';

class StagedDrawer extends StatefulWidget {
  final Duration duration;
  final IndexedWidgetBuilder builder;

  const StagedDrawer({Key key, this.duration, @required this.builder}) : super(key: key);

  @override
  _StagedDrawerState createState() => _StagedDrawerState();
}

class _StagedDrawerState extends State<StagedDrawer>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _angleAnimation;
  final _perspectiveTween = Tween(begin: 0.001, end: 0.0);
  final _perspectiveAnimations = <Animation>[];
  bool some = false;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: widget.duration);
    _angleAnimation = Tween(begin: -(pi / 2), end: 0.0).animate(_controller);
    _buildPerspectiveAnimations(8);

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          some = !some;
          _controller.forward();
        }));
  }

  void _buildPerspectiveAnimations(int count) {
    for (var index = 0; index < count; index++) {
      _perspectiveAnimations.add(_perspectiveTween.animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.1 * index,
            0.1 * index + 0.3,
            curve: Curves.linear,
          ),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO remove scaffold, when it is finished
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => ListView(
          children: <Widget>[
            _buildBigItem(),
            _buildItem(1, Icons.home, 'HOME'),
            _buildItem(2, Icons.menu, 'FEED'),
            _buildItem(3, Icons.message, 'MESSAGES'),
            _buildItem(4, Icons.camera_alt, 'PHOTOS'),
            _buildItem(5, Icons.place, 'PLACES'),
            _buildItem(6, Icons.notifications, 'NOTIFICATIONS'),
            _buildItem(7, Icons.person, 'PROFILE'),

            ListView.builder(itemBuilder: (context, index){
              return _buildAnimation(index, widget.builder(context, index));
            })

          ],
        ),
      ),
    );
  }

  _buildItem(int index, IconData icon, String text) {
    return _buildAnimation(index, _buildSmallItem(icon, text));
  }

  _buildAnimation(int index, Widget child) {
    return Transform(
      alignment: FractionalOffset.topLeft,
      transform: Matrix4.identity()
        ..rotateY(_angleAnimation.value)
        ..setEntry(3, 0, _perspectiveAnimations[index].value),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500 - (7 - index) * 20),
        color: some ? Colors.yellow : Colors.redAccent,
        child: child,
      ),
    );
  }

  _buildBigItem() {
    return Center(
      child: Container(
        height: 300,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'MI',
              style: TextStyle(fontSize: 120),
            ),
          ),
        ),
      ),
    );
  }

  _buildSmallItem(IconData icon, String text) {
    return Container(
      height: 72,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Icon(
              icon,
              size: 30,
            ),
            flex: 2,
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            flex: 9,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
