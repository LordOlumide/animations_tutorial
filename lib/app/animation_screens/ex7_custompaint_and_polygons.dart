import 'dart:math' show pi, cos, sin;

import 'package:flutter/material.dart';

class Example7 extends StatefulWidget {
  static const screenId = 'Example 7';
  const Example7({Key? key}) : super(key: key);

  @override
  State<Example7> createState() => _Example7State();
}

class _Example7State extends State<Example7> with TickerProviderStateMixin {
  late final AnimationController _sidesController;
  late final Animation _sidesAnimation;

  late final AnimationController _radiusController;
  late final Animation _radiusAnimation;

  late final AnimationController _rotationController;
  late final Animation _rotationAnimation;

  int noOfSides = 3;

  @override
  void initState() {
    super.initState();

    _sidesController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 3,
      ),
    );
    _radiusController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _sidesAnimation = IntTween(begin: 3, end: 10).animate(_sidesController);
    _radiusAnimation = Tween<double>(begin: 20.0, end: 400.0)
        .chain(CurveTween(curve: Curves.bounceInOut))
        .animate(_radiusController);
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * pi)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_rotationController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sidesController.repeat(reverse: true);
    _radiusController.repeat(reverse: true);
    _rotationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _sidesController.dispose();
    _radiusController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
            animation: Listenable.merge([
              _sidesController,
              _radiusController,
              _rotationController,
            ]),
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateX(_rotationAnimation.value)
                  ..rotateY(_rotationAnimation.value)
                  ..rotateZ(_rotationAnimation.value),
                child: CustomPaint(
                  painter: PolygonPainter(sides: _sidesAnimation.value),
                  child: SizedBox(
                    width: _radiusAnimation.value,
                    height: _radiusAnimation.value,
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class PolygonPainter extends CustomPainter {
  final int sides;

  const PolygonPainter({
    required this.sides,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    final Path path = Path();

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double angle = (2 * pi) / sides;
    final List<double> angles = List.generate(sides, (index) => angle * index);
    final radius = size.width / 2;

    path.moveTo(
      center.dx + (radius * cos(0)),
      center.dy + (radius * sin(0)),
    );

    for (final angle in angles) {
      path.lineTo(
        center.dx + (radius * cos(angle)),
        center.dy + (radius * sin(angle)),
      );
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate is PolygonPainter && oldDelegate.sides != sides;
}
