import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mp_police/pages/intro_pages/welcome_screen.dart';
import 'package:mp_police/user/drawer_widgets/terms_and_conditions.dart';
import 'package:mp_police/user/pages/donation_tracking_page.dart';
import 'package:mp_police/user/pages/password_change_screen.dart';
import 'package:mp_police/utils/constants.dart';
import 'package:mp_police/widget/widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';

import '../pages/profile_page.dart';

class AppSetting extends StatefulWidget {
  const AppSetting({super.key});

  @override
  State<AppSetting> createState() => _AppSettingState();
}

class _AppSettingState extends State<AppSetting> {
  Widget accountOption(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600]),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  // To logout user
  Future<void> _logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all data in shared preferences
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          UserSingleton.instance.isHindi ? "सेटिंग" : "Settings",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),

            GestureDetector(
              onTap: () {
                goTo(context, const UpdateUserInformation());
              },
              child: accountOption(
                UserSingleton.instance.isHindi
                    ? "प्रोफ़ाइल अपडेट करें"
                    : "Update Profile",
              ),
            ),

            GestureDetector(
              onTap: () {
                goTo(context, DonationTrackingPage());
              },
              child: accountOption(
                UserSingleton.instance.isHindi ? "दान अनुरोध" : "Help Request",
              ),
            ),

            GestureDetector(
                onTap: () {
                  goTo(context, PasswordChangeScreen());
                },
                child: accountOption("Change Password")),

            const Divider(
              height: 20,
              thickness: 1,
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // share button
                GestureDetector(
                  onTap: () async {
                    await Share.share('com.example.mp_police');
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      height: 90,
                      width: 130,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: primaryColor),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(CupertinoIcons.share,
                              color: Colors.white, size: 30),
                          Text(
                            "SHARE",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                // Rate Us Button
                GestureDetector(
                  onTap: () {
                    showRatingDialogBox();
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      height: 90,
                      width: 130,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: primaryColor),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(CupertinoIcons.star_fill,
                              color: Colors.white, size: 30),
                          Text(
                            "RATE US",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 30),

            // Sign Out Button
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  _logoutUser();
                  goTo(context, const WelcomeScreen());
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(15),
                    elevation: 2),
                child: Text(
                  UserSingleton.instance.isHindi ? "साइन आउट" : "Sign Out",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                ),
              ),
            ),

            const Divider(
              height: 20,
              thickness: 1,
            ),
            const SizedBox(height: 30),

            // Terms and Conditions
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 8, bottom: 8),
                child: RichText(
                  text: TextSpan(
                    // Default Style
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xff383838),
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: UserSingleton.instance.isHindi
                            ? "नियम और शर्तें"
                            : "Terms & Conditions",
                        style: TextStyle(
                          color: secondaryColor,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            goTo(context, const TermsAndConditions());
                          },
                      ),
                      const TextSpan(text: " "),
                      const TextSpan(text: "of using the product"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showRatingDialogBox() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return RatingDialog(
          title: Text(
            UserSingleton.instance.isHindi ? "हमें रेट करें" : "RATE US",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          message: const Text(
            "Share your experience",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          image: Image.asset(
            "assets/images/login.png",
            height: 100,
          ),
          submitButtonText: "SUBMIT",
          submitButtonTextStyle:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          starSize: 35,
          onSubmitted: (response) {
            if (response.rating < 3.0) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ), //this right here
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 400,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Lottie.asset(
                                  "assets/animations/improve_app.json",
                                  animate: true,
                                  width: 200,
                                ),
                              ),
                            ),
                            const TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'How can we improve our app?',
                              ),
                            ),
                            SizedBox(
                              width: 300.0,
                              height: 50.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  openEmail();
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: secondaryColor,
                                ),
                                child: const Text(
                                  "Write your issue",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              StoreRedirect.redirect(
                androidAppId: "com.example.mp_police",
                iOSAppId: "com.example.mp_police",
              );
            }
          },
        );
      },
    );
  }
}
