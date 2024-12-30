import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class FinalHappyScreen extends ConsumerWidget {
  const FinalHappyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goal'),
        leading: IconButton(
            onPressed: () {
              context.push('/home');
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Text('Congratulations On Completing your Goal',
                  style: TextStyle(fontSize: 30)),
            ),
            Lottie.asset('assets/animations/Happy.json'),
          ],
        ),
      ),
    );
  }
}

class FinalExerciseScreen extends ConsumerWidget {
  const FinalExerciseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goal'),
        leading: IconButton(
            onPressed: () {
              context.push('/home');
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'No Worries , Keep Grinding',
              style: TextStyle(fontSize: 30),
            ),
            Lottie.asset('assets/animations/Exercise.json'),
          ],
        ),
      ),
    );
  }
}
