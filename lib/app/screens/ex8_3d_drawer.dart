import 'dart:math' show pi;

import 'package:flutter/material.dart';

class Example8 extends StatelessWidget {
  const Example8({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyDrawerScaffold(
      drawer: Material(
        child: Container(
          color: const Color(0xFF24283b),
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 80.0, top: 100),
            itemCount: 20,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Item $index'),
              );
            },
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Draggable Drawer Scaffold'),
        ),
        body: Container(
          color: const Color(0xFF414868),
        ),
      ),
    );
  }
}

class MyDrawerScaffold extends StatefulWidget {
  final Widget child;
  final Widget drawer;

  const MyDrawerScaffold({
    Key? key,
    required this.child,
    required this.drawer,
  }) : super(key: key);

  @override
  State<MyDrawerScaffold> createState() => _MyDrawerScaffoldState();
}

class _MyDrawerScaffoldState extends State<MyDrawerScaffold>
    with TickerProviderStateMixin {
  late AnimationController _xMovementController;

  late Animation<double> _yRotationAnimationForChild;
  late Animation<double> _yRotationAnimationForDrawer;

  @override
  void initState() {
    super.initState();
    _xMovementController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _yRotationAnimationForChild =
        Tween<double>(begin: 0.0, end: -pi / 2).animate(_xMovementController);
    _yRotationAnimationForDrawer =
        Tween<double>(begin: pi / 2.7, end: 0.0).animate(_xMovementController);
  }

  @override
  void dispose() {
    _xMovementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double maxDrag = screenWidth * 0.8;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final double delta = details.delta.dx / maxDrag;
        _xMovementController.value += delta;
      },
      onHorizontalDragEnd: (details) {
        if (_xMovementController.value < 0.5) {
          _xMovementController.reverse();
        } else {
          _xMovementController.forward();
        }
      },
      child: AnimatedBuilder(
        animation: _xMovementController,
        builder: (context, child) {
          return Stack(
            children: [
              Container(
                color: const Color(0xFF1a1b26),
              ),
              Transform(
                alignment: Alignment.centerLeft,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..translate(_xMovementController.value * maxDrag)
                  ..rotateY(_yRotationAnimationForChild.value),
                child: widget.child,
              ),
              Transform(
                alignment: Alignment.centerRight,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..translate(
                      -screenWidth + _xMovementController.value * maxDrag)
                  ..rotateY(_yRotationAnimationForDrawer.value),
                child: widget.drawer,
              ),
            ],
          );
        },
      ),
    );
  }
}
