import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:mp_police/pages/intro_pages/onboarding_screen.dart';
import 'package:mp_police/utils/constants.dart';

class SplashScreen extends StatelessWidget{
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/images/logo.png',
      nextScreen: const IntroScreen(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: bgColor,
      splashIconSize: 200,
      duration: 2500,
    );
  }
}