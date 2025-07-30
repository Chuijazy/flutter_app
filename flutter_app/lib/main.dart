import 'package:flutter/material.dart';
import 'package:flutter_app/screens/auth_screens/auth_screen.dart';
import 'package:flutter_app/screens/splash_and_onboard/onboarding.dart';
import 'package:flutter_app/screens/splash_and_onboard/language_screen.dart';
import 'package:flutter_app/screens/splash_and_onboard/splash_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/language': (context) => const LanguageScreen(),
        '/onboarding': (context) => const Onboarding(),
        '/auth': (context) => const AuthScreen(),
      },
    );
  }
}
