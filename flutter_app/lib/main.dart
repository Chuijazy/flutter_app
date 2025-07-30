import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_app/core/app_colors.dart';
import 'package:flutter_app/features/onboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimatedSplashScreen(
        duration: 3000,
        splash: LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.mainColor),
          backgroundColor: AppColors.darkBackgroundColor,
        ),
        nextScreen: Onboarding(),
        splashTransition: SplashTransition.scaleTransition,
        backgroundColor: Colors.white,
      ),
    );
  }
}
