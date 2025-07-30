import 'package:flutter/material.dart';
import 'package:flutter_app/core/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/language');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: 240,
          height: 6,
          child: LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.mainColor),
            backgroundColor: AppColors.darkBackgroundColor,
          ),
        ),
      ),
    );
  }
}
