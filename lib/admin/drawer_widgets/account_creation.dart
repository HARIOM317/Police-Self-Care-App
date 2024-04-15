// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mp_police/components/custom_textfield.dart';
import 'package:mp_police/components/primary_button.dart';
import 'package:mp_police/utils/constants.dart';

class AccountCreation extends StatefulWidget {
  const AccountCreation({super.key});

  @override
  State<AccountCreation> createState() => _AccountCreationState();
}

class _AccountCreationState extends State<AccountCreation> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  static String? selectedRole;
  bool isPasswordHide = true;
  List<Map<String, dynamic>> topThreeUsers = [];

  Future<void> createAccount(
      BuildContext context, String email, String password, String role) async {
    final String url = dotenv.env['ADMIN_ACCOUNT_CREATION_API']!;

    try {
      final optionsRequest = http.Request('OPTIONS', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json';

      final http.StreamedResponse optionsResponse =
          await http.Client().send(optionsRequest);

      if (optionsResponse.statusCode == 201) {
        if (kDebugMode) {
          print('OPTIONS request successful');
        }

        final postRequest = http.Request('OPTIONS', Uri.parse(url))
          ..headers['Content-Type'] = 'application/json'
          ..body = jsonEncode(<String, String>{
            'email': email,
            'password': password,
            'role': role,
          });

        final http.StreamedResponse postResponse =
            await http.Client().send(postRequest);

        if (postResponse.statusCode == 201) {
          if (kDebugMode) {
            print('Account created successfully');
          }
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.success,
                  animType: AnimType.topSlide,
                  showCloseIcon: true,
                  title: "Account Created Successfully",
                  titleTextStyle: TextStyle(
                      color: Colors.green[900],
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  desc: "$email\n$role",
                  descTextStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                  btnOkOnPress: () {})
              .show();
        } else {
          if (kDebugMode) {
            print('Failed to create account: ${postResponse.reasonPhrase}');
          }
        }
      } else {
        if (kDebugMode) {
          print('Failed OPTIONS request: ${optionsResponse.reasonPhrase}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error creating account: $error');
      }
    }
  }

  // Function to fetch top three recently registered user data
  Future<void> fetchData() async {
    try {
      final String url = dotenv.env['GET_ALL_USERS_API']!;

      final request = http.Request(
        'OPTIONS',
        Uri.parse(url),
      )..headers['Content-Type'] = 'application/json';

      final http.StreamedResponse response = await http.Client().send(request);

      if (response.statusCode == 200) {
        final data = jsonDecode(await utf8.decodeStream(response.stream));
        final List<dynamic> users = data['user'];

        List<Map<String, String>> newUsers = [];
        for (int i = 0; i < 3 && i < users.length; i++) {
          final user = users[i];
          newUsers.add({
            'name': user['name'],
            'email': user['email'],
            'img_url': user['img_url'],
          });
        }

        setState(() {
          topThreeUsers.clear();
          topThreeUsers.addAll(newUsers);
        });

        if (kDebugMode) {
          for (var user in topThreeUsers) {
            print('Name: ${user['name']}, Email: ${user['email']}');
          }
        }
      } else {
        if (kDebugMode) {
          print('Failed to load data: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.transparent,
          // Status bar brightness
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.dark, // For iOS (dark icons)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Account Creation",
          style: TextStyle(
              color: primaryColor, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // First Section
                  Column(
                    children: [
                      // Email text field
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LoginTextField(
                          hintText: "Email",
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          prefix: const Icon(Icons.person),
                        ),
                      ),

                      // Password text field
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LoginTextField(
                          hintText: "Password",
                          keyboardType: TextInputType.visiblePassword,
                          prefix: const Icon(Icons.fingerprint),
                          controller: passwordController,
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

                      // Dropdown for admin role
                      adminRoleDropdownList(
                          selectedRole: selectedRole,
                          callbackFunction: (String? newRole) {
                            setState(() {
                              selectedRole = newRole!;
                            });
                          }
                          ),

                      // Create Account Button
                      PrimaryButton(
                          title: "Create Account",
                          onPressed: () {
                            createAccount(context, emailController.text,
                                passwordController.text, selectedRole ?? '');
                          }
                      ),
                    ],
                  ),

                  // Second Section
                  Column(
                    children: [
                      // Label
                      Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Text(
                              "Latest Creation",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor
                              ),
                            ),
                          )),

                      // Latest User 1
                      ListTile(
                        leading: topThreeUsers.isEmpty
                            ? CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ))
                            : topThreeUsers[0]['img_url'] != null
                            ? CircleAvatar(
                          backgroundImage: NetworkImage(topThreeUsers[0]['img_url']),
                        )
                            : CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            )),
                        title: topThreeUsers.isEmpty
                            ? const Text("Loading...")
                            : Text(
                          topThreeUsers[0]['name']!,
                          style:
                          const TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        trailing: const Icon(
                          Icons.more_vert,
                          color: Colors.black,
                        ),
                        subtitle: topThreeUsers.isEmpty
                            ? const Text("Loading...")
                            : Text(
                          topThreeUsers[0]['email']!,
                          style: const TextStyle(color: Colors.black54),
                        ),
                        selected: true,
                      ),

                      // Latest User 2
                      ListTile(
                        leading: topThreeUsers.isEmpty
                            ? CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ))
                            : topThreeUsers[1]['img_url'] != null
                            ? CircleAvatar(
                          backgroundImage: NetworkImage(topThreeUsers[0]['img_url']),
                        )
                            : CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            )),
                        title: topThreeUsers.isEmpty
                            ? const Text("Loading...")
                            : Text(
                          topThreeUsers[1]['name']!,
                          style:
                          const TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        trailing: const Icon(
                          Icons.more_vert,
                          color: Colors.black,
                        ),
                        subtitle: topThreeUsers.isEmpty
                            ? const Text("Loading...")
                            : Text(
                          topThreeUsers[1]['email']!,
                          style: const TextStyle(color: Colors.black54),
                        ),
                        selected: true,
                      ),

                      // Latest User 3
                      ListTile(
                        leading: topThreeUsers.isEmpty
                            ? CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ))
                            : topThreeUsers[2]['img_url'] != null
                            ? CircleAvatar(
                          backgroundImage: NetworkImage(topThreeUsers[0]['img_url']),
                        )
                            : CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            )),
                        title: topThreeUsers.isEmpty
                            ? const Text("Loading...")
                            : Text(
                          topThreeUsers[2]['name']!,
                          style:
                          const TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        trailing: const Icon(
                          Icons.more_vert,
                          color: Colors.black,
                        ),
                        subtitle: topThreeUsers.isEmpty
                            ? const Text("Loading...")
                            : Text(
                          topThreeUsers[2]['email']!,
                          style: const TextStyle(color: Colors.black54),
                        ),
                        selected: true,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
