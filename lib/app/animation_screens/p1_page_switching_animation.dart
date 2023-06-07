import 'package:flutter/material.dart';

class PageViewScaffold extends StatefulWidget {
  static const screenId = 'PageView Scaffold';
  const PageViewScaffold({Key? key}) : super(key: key);

  @override
  State<PageViewScaffold> createState() => _PageViewScaffoldState();
}

class _PageViewScaffoldState extends State<PageViewScaffold> {
  late final PageController _controller;

  /// Fraction animating from 0 to pages.length
  double currentOffset = 0.0;

  void positionListener() {
    setState(() {
      currentOffset = _controller.offset / MediaQuery.of(context).size.width;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _controller.addListener(positionListener);
  }

  @override
  void dispose() {
    _controller.removeListener(positionListener);
    _controller.dispose();
    super.dispose();
  }

  void changePageTo(int newPage) {
    setState(() {
      _controller.animateTo(
        newPage.toDouble(),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return pages[index];
            },
          ),
          Positioned(
            top: 120,
            child: PageIndicator(
              pageCount: pages.length,
              currentOffset: currentOffset,
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: SafeArea(
              child: IconButton(
                onPressed: () {
                  if (_controller.offset != 0.0) {
                    _controller.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                    );
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const List<PageScreen> pages = [
  PageScreen(
    appBarTitle: 'Page 1',
    appBarColor: Colors.white,
    bodyColor: Colors.white,
  ),
  PageScreen(
    appBarTitle: 'Page 2',
    appBarColor: Colors.lightBlueAccent,
    bodyColor: Colors.blue,
  ),
  PageScreen(
    appBarTitle: 'Page 3',
    appBarColor: Colors.greenAccent,
    bodyColor: Colors.green,
  ),
  PageScreen(
    appBarTitle: 'Page 4',
    appBarColor: Colors.lightGreenAccent,
    bodyColor: Colors.lightGreen,
  ),
  PageScreen(
    appBarTitle: 'Page 5',
    appBarColor: Colors.blueGrey,
    bodyColor: Colors.grey,
  ),
];

class PageScreen extends StatelessWidget {
  final String appBarTitle;
  final Color appBarColor;
  final Color bodyColor;

  const PageScreen({
    Key? key,
    required this.appBarTitle,
    required this.appBarColor,
    required this.bodyColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 100,
        centerTitle: true,
        backgroundColor: appBarColor,
        title: Text(
          appBarTitle,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int pageCount;
  final double currentOffset;

  const PageIndicator({
    Key? key,
    required this.pageCount,
    required this.currentOffset,
  }) : super(key: key);

  static const double ratioOfScreenWidthToTake = 0.9;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: MediaQuery.of(context).size.width * ratioOfScreenWidthToTake,
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width *
              ((1 - ratioOfScreenWidthToTake) / 2)),
      child: CustomPaint(
        foregroundPainter: IndicatorPainter(
          activeColor: Colors.black,
          inactiveColor: Colors.grey[400]!,
          nodeInternalColor: Colors.white70,
          nodeCount: pageCount,
          progression: currentOffset,
        ),
      ),
    );
  }
}

class IndicatorPainter extends CustomPainter {
  final Color activeColor;
  final Color inactiveColor;
  final Color nodeInternalColor;
  final int nodeCount;
  final double progression;

  IndicatorPainter({
    required this.activeColor,
    required this.inactiveColor,
    required this.nodeInternalColor,
    required this.nodeCount,
    required this.progression,
  });
  final double nodeRadius = 4.0;
  final lineThickness = 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    // ============= Bottom stack =======================
    // Drawing the lines
    final Paint linePaint = Paint()
      ..strokeWidth = lineThickness
      ..color = inactiveColor
      ..style = PaintingStyle.stroke;
    final Path linePath = Path();

    linePath.moveTo(0, size.height / 2);
    linePath.lineTo(size.width, size.height / 2);

    canvas.drawPath(linePath, linePaint);

    // Drawing the nodes
    final Paint circlePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = nodeInternalColor;
    final Paint circleBorderPaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    final Path circlePath = Path();

    List<Offset> nodes = getAllNodes(size.width, size.height);
    for (Offset node in nodes) {
      circlePath.addOval(
        Rect.fromCircle(
          center: node,
          radius: nodeRadius,
        ),
      );
    }
    canvas.drawPath(circlePath, circlePaint);
    canvas.drawPath(circlePath, circleBorderPaint);

    // ================= Top stack ===================
    // Drawing the lines
    final Paint linePaint2 = Paint()
      ..strokeWidth = lineThickness
      ..color = activeColor
      ..style = PaintingStyle.stroke;
    final Path linePath2 = Path();

    linePath2.moveTo(0, size.height / 2);
    linePath2.lineTo(
        (size.width * progression / (nodeCount - 1)), size.height / 2);

    canvas.drawPath(linePath2, linePaint2);

    // Drawing the nodes
    final Paint circlePaint2 = Paint()
      ..style = PaintingStyle.fill
      ..color = activeColor;
    final Path circlePath2 = Path();

    for (Offset node in nodes) {
      if ((size.width * progression / (nodeCount - 1)) >=
          (node.dx - nodeRadius)) {
        circlePath2.addOval(
          Rect.fromCircle(
            center: node,
            radius: nodeRadius,
          ),
        );
      }
    }
    canvas.drawPath(circlePath2, circlePaint2);
  }

  List<Offset> getAllNodes(final double width, final double height) {
    Offset trackPoint = Offset(0, height / 2);
    final List<Offset> nodes = [];
    double spacing = width / (nodeCount - 1);
    // Get Node Offsets
    for (int i = 0; i < nodeCount; i++) {
      nodes.add(Offset(trackPoint.dx, trackPoint.dy));
      trackPoint = trackPoint.translate(spacing, 0);
    }
    return nodes;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate is IndicatorPainter;
}
