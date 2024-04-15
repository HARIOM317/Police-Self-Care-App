import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mp_police/utils/constants.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

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
                  child: Lottie.asset("assets/animations/self-care.json", animate: true, width: 225),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: introTextDesign1("Lorem ipsum, placeholder or dummy text used in typesetting and graphic design for previewing layouts.", fontSize: 22),
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
