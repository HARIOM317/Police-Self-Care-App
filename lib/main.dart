import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mp_police/admin/admin_navbar.dart';
import 'package:mp_police/pages/splash_screens/splash_screen.dart';
import 'package:mp_police/user/pages/registration_pending.dart';
import 'package:mp_police/user/user_navbar.dart';
import 'package:mp_police/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String userType = '';

  Future<void> getUserTypeFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    userType = prefs.getString('userType') ?? '';
  }

  @override
  void initState() {
    super.initState();
    getUserTypeFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    // stop auto rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return FutureBuilder<void>(
      future: getUserTypeFromSharedPreferences(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MP Police Seva',
            theme: ThemeData(
              fontFamily: 'Nunito-Regular',
              scaffoldBackgroundColor: Colors.white,
              colorScheme:
                  ColorScheme.fromSeed(seedColor: const Color(0xff718639)),
              useMaterial3: true,
            ),
            home: const SplashScreen(),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MP Police Seva',
            theme: ThemeData(
              fontFamily: 'Nunito-Regular',
              scaffoldBackgroundColor: Colors.white,
              colorScheme:
                  ColorScheme.fromSeed(seedColor: const Color(0xff718639)),
              useMaterial3: true,
            ),
            home: userType == ''
                ? const SplashScreen()
                : userType == "user"
                    ? UserNavbar()
                    : userType == "admin"
                        ? const AdminNavbar()
                        : Scaffold(
                            body: progressIndicator(context),
                          ),
          );
        }
      },
    );
  }
}
