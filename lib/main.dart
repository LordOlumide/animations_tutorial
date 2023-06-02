import 'package:animations_tutorial/app/screens/ex9_animated_prompt.dart';
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
      home: const Example9(),
    );
  }
}
