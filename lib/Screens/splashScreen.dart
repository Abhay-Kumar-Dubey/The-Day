import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  final minWidth = 400.0;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController and Animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // Start the animation
    _controller.forward();

    // Navigate after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      context.go('/signIn'); // Navigate to the sign-in screen
    });
  }

  @override
  void dispose() {
    // Dispose of the AnimationController
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: FadeTransition(
          opacity: _opacity,
          child: Container(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: max(screenWidth, minWidth),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.asset(
                          'assets/animations/The Day.png',
                          height: 130,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            'THE DAY',
                            style: TextStyle(
                                fontSize: 120,
                                fontFamily: 'AmericanCaptain',
                                color: Colors.white),
                          ),
                          Text(
                            'Track It Till You Make It',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      )
                    ],
                  ))
            ]),
          )),

      backgroundColor:
          Colors.black, // Duration of the splash screen in milliseconds
    );
  }
}
