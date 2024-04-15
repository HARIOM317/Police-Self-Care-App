import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mp_police/utils/constants.dart';

class IntroPage5 extends StatelessWidget {
  const IntroPage5({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
          color: bgColor
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Lottie.asset("assets/animations/security.json", animate: true, width: 225),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: introTextDesign1("Your security is our priority", fontSize: 22),
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
