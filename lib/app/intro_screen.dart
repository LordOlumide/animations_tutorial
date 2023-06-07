import 'package:animations_tutorial/app/animation_screens/ex1_anim_builder_and_transform.dart';
import 'package:animations_tutorial/app/animation_screens/ex2_chained_anims_curves_and_clippers.dart';
import 'package:animations_tutorial/app/animation_screens/ex3_3d_stack_and_rotate.dart';
import 'package:animations_tutorial/app/animation_screens/ex4_hero_anim.dart';
import 'package:animations_tutorial/app/animation_screens/ex5_implicit_anims.dart';
import 'package:animations_tutorial/app/animation_screens/ex6_tween_anim_builder_and_clips.dart';
import 'package:animations_tutorial/app/animation_screens/ex7_custompaint_and_polygons.dart';
import 'package:animations_tutorial/app/animation_screens/ex8_3d_drawer.dart';
import 'package:animations_tutorial/app/animation_screens/ex9_animated_prompt.dart';
import 'package:animations_tutorial/app/animation_screens/p1_page_switching_animation.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  static const screenId = 'Intro screen';
  IntroScreen({Key? key}) : super(key: key);

  final List<Widget> _screens = [
    const Example1(),
    const Example2(),
    const Example3(),
    const Example4(),
    const Example5(),
    const Example6(),
    const Example7(),
    const Example8(),
    const Example9(),
    const PageViewScaffold(),
  ];

  @override
  Widget build(BuildContext context) {
    void navigateTo(Widget screen) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => screen));
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 0; i < _screens.length; i++)
                MaterialButton(
                  onPressed: () {
                    navigateTo(_screens[i]);
                  },
                  child: Text('Example $i'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
