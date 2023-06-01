import 'package:animations_tutorial/app/screens/ex3_3d_stack_and_rotate.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      title: 'Animations tutorial',
      home: const Example3(),
    );
  }
}
