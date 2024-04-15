// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mp_police/admin/admin_navbar.dart';
import 'package:mp_police/components/custom_textfield.dart';
import 'package:mp_police/components/primary_button.dart';
import 'package:mp_police/components/secondary_button.dart';
import 'package:mp_police/user/signUpandAuth/sign_up.dart';
import 'package:mp_police/user/user_navbar.dart';
import 'package:mp_police/utils/constants.dart';
import 'package:mp_police/utils/custom_page_route.dart';
import 'package:mp_police/widget/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController idController = TextEditingController();

  bool isPasswordHide = true;
  // final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  bool isLoading = false;

  Future<void> login(BuildContext context, String email, String password) async {
    final String url = dotenv.env['LOGIN_API']!;

    try {
      final request = http.Request('OPTIONS', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({'email': email, 'password': password});

      final http.StreamedResponse response = await http.Client().send(request);

      if (response.statusCode == 200) {
        final jsonResponse = await http.Response.fromStream(response);
        final responseData = jsonDecode(jsonResponse.body);

        final userData = responseData['user'];
        final userRole = responseData['user']['role'];
        String userId = responseData['user']['id'].toString();
        UserSingleton().setUserId(userId.toString());

        if (userRole == '7') {
          // Save user data to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userType', "user");
          await prefs.setInt('userId', userData['id'] ?? -1);
          await prefs.setString('userName', userData['name'] ?? "");
          await prefs.setString('userEmail', email);
          await prefs.setString('userPassword', password);
          await prefs.setString('userPhone', userData['mobile'] ?? "");
          await prefs.setString('userImg', userData['img_url'] ?? "");
          await prefs.setString('userGender', userData['gender'] ?? "");
          await prefs.setString(
              'userBloodGroup', userData['blood_group'] ?? "");
          await prefs.setString(
              'userCurrentAddress', userData['current_address'] ?? "");
          await prefs.setString(
              'userHomeAddress', userData['home_address'] ?? "");
          await prefs.setString('userDistrict', userData['district'] ?? "");
          await prefs.setString(
              'userHomeDistrict', userData['home_district'] ?? "");
          await prefs.setString('userState', userData['state'] ?? "");
          await prefs.setString('userPost', userData['post'] ?? "");
          await prefs.setString(
              'userPostingDetails', userData['posting_details'] ?? "");
          await prefs.setString(
              'userPostingOffice', userData['posting_office'] ?? "");

          // MySharedPreference.saveUserType('user');
          nextScreen(context, const UserNavbar());
        } else {
          // Save user data to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userType', "admin");
          await prefs.setInt('adminId', userData['id'] ?? -1);
          await prefs.setString('adminName', userData['name'] ?? "");
          await prefs.setString('adminRole', userData['role'] ?? "");
          await prefs.setString('adminEmail', email);
          await prefs.setString('adminPassword', password);
          await prefs.setString('adminPhone', userData['mobile'] ?? "");
          await prefs.setString('adminImg', userData['img_url'] ?? "");
          await prefs.setString('adminGender', userData['gender'] ?? "");
          await prefs.setString(
              'adminBloodGroup', userData['blood_group'] ?? "");
          await prefs.setString(
              'adminCurrentAddress', userData['current_address'] ?? "");
          await prefs.setString(
              'adminHomeAddress', userData['home_address'] ?? "");
          await prefs.setString('adminDistrict', userData['district'] ?? "");
          await prefs.setString(
              'adminHomeDistrict', userData['home_district'] ?? "");
          await prefs.setString('adminState', userData['state'] ?? "");
          await prefs.setString('adminPost', userData['post'] ?? "");
          await prefs.setString(
              'adminPostingDetails', userData['posting_details'] ?? "");
          await prefs.setString(
              'adminPostingOffice', userData['posting_office'] ?? "");

          // MySharedPreference.saveUserType('admin');
          nextScreen(context, const AdminNavbar());
        }
      } else {
        if (kDebugMode) {
          print('Failed request: ${response.reasonPhrase}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error making request: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Mp Police Seva',
          style: TextStyle(
            fontFamily: 'robot',
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              // app icon
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 120,
                ),
              ),

              // login text
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Welcome",
                  style: TextStyle(
                      fontSize: 30,
                      color: primaryColor,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: LoginTextField(
                  hintText: "Email",
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  prefix: const Icon(Icons.person),
                  validate: (email) {
                    if (email!.isEmpty ||
                        email.length < 8 ||
                        !email.contains("@") ||
                        email.contains(" ")) {
                      return "Invalid email address";
                    } else {
                      return null;
                    }
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: LoginTextField(
                  hintText: "Password",
                  keyboardType: TextInputType.visiblePassword,
                  prefix: const Icon(Icons.fingerprint),
                  controller: passwordController,
                  onSave: (password) {
                    _formData['password'] = password ?? "";
                  },
                  validate: (password) {
                    if (password!.isEmpty ||
                        password.length < 8 ||
                        password.contains(" ")) {
                      return "Incorrect password";
                    } else {
                      return null;
                    }
                  },
                  isPassword: isPasswordHide,
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordHide = !isPasswordHide;
                      });
                    },
                    icon: isPasswordHide
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                  ),
                ),
              ),

              // forgot password button
              Padding(
                padding: const EdgeInsets.only(
                    top: 5, bottom: 10, left: 15, right: 15),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),

              // login button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PrimaryButton(
                  title: "Login",
                  onPressed: () {
                    login(
                        context, emailController.text, passwordController.text);
                  },
                ),
              ),

              // create new account button
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                    ),
                    SecondaryButton(
                        title: "Create new account",
                        onPressed: () {
                          Navigator.push(
                              context, CustomPageRoute(child: const SignUp()));
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
