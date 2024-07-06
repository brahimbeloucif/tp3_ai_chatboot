import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FullScreenLottie extends StatelessWidget {
  final Function onEnd;

  FullScreenLottie({required this.onEnd});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/ani 2.json', 
          onLoaded: (composition) {
            Future.delayed(Duration(seconds: 3), () {
              onEnd();
            });
          },
        ),
      ),
    );
  }
}
