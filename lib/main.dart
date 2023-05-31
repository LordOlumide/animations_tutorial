import 'package:flutter/material.dart';

import 'app/screens/ex2_chained_anims_curves_and_clippers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Animations tutorial',
      home: Example2(),
    );
  }
}
