import 'package:flutter/material.dart';

class Example9 extends StatelessWidget {
  const Example9({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Prompt'),
      ),
      body: const Center(
        child: AnimatedPrompt(
          title: 'Thank you for your order!',
          subTitle: 'Order will be delivered in 2 days. Enjoy!',
          icon: Icon(Icons.check),
          iconBGColor: Colors.green,
        ),
      ),
    );
  }
}

class AnimatedPrompt extends StatefulWidget {
  final String title;
  final String subTitle;
  final Widget icon;
  final Color iconBGColor;

  const AnimatedPrompt({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.iconBGColor,
  }) : super(key: key);

  @override
  State<AnimatedPrompt> createState() => _AnimatedPromptState();
}

class _AnimatedPromptState extends State<AnimatedPrompt>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _iconScaleAnimation;
  late final Animation<double> _containerScaleAnimation;
  late final Animation<Offset> _containerYAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _containerYAnim = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.23),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _iconScaleAnimation = Tween<double>(begin: 7.0, end: 6.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _containerScaleAnimation = Tween<double>(begin: 2.0, end: 0.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller
      ..reset()
      ..forward();

    final BorderRadius borderRadius = BorderRadius.circular(20);

    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 100,
            minHeight: 100,
            maxWidth: MediaQuery.of(context).size.width * 0.8,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 160),
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.subTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: SlideTransition(
                  position: _containerYAnim,
                  child: ScaleTransition(
                    scale: _containerScaleAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.iconBGColor,
                      ),
                      child: ScaleTransition(
                        scale: _iconScaleAnimation,
                        child: widget.icon,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
