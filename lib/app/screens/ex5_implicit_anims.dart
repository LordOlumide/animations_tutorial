import 'package:flutter/material.dart';

class Example5 extends StatefulWidget {
  const Example5({Key? key}) : super(key: key);

  @override
  State<Example5> createState() => _Example5State();
}

const double defaultWidth = 150.0;

class _Example5State extends State<Example5> {
  bool _isZoomedIn = false;
  double _width = defaultWidth;

  @override
  Widget build(BuildContext context) {
    String buttonTitle = _isZoomedIn ? 'Zoom out' : 'Zoom in';

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                width: _width,
                duration: const Duration(milliseconds: 370),
                curve: _isZoomedIn ? Curves.bounceInOut : Curves.bounceOut,
                child: Image.asset('assets/images/dummy_img.jpg'),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isZoomedIn = !_isZoomedIn;
                _width = _isZoomedIn
                    ? MediaQuery.of(context).size.width
                    : defaultWidth;
              });
            },
            child: Text(buttonTitle),
          ),
        ],
      ),
    );
  }
}
