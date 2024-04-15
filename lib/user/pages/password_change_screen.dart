import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mp_police/widget/widget.dart';

class PasswordChangeScreen extends StatefulWidget {
  @override
  _PasswordChangeScreenState createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _changePassword({required String userId}) async {
    final url =
        Uri.parse('https://pscta.tdpvista.co.in/api/v1/user/changepassword');
    final requestBody = json.encode({
      "id": userId,
      "current_password": _currentPasswordController.text,
      "new_password": _newPasswordController.text,
    });

    final request = http.Request('OPTIONS', url);
    request.headers.addAll(<String, String>{
      'Content-Type': 'application/json',
    });
    request.body = requestBody;

    final streamedResponse = await http.Client().send(request);
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      // Options request successful
      print('Options request successful');
    } else {
      // Failed to make options request
      print('Failed to make options request');
      throw Exception('Failed to make options request');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(UserSingleton().languageNotifier.value
            ? 'पासवर्ड बदलें'
            : 'Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: _currentPasswordController,
                decoration: InputDecoration(
                  labelText: UserSingleton().languageNotifier.value
                      ? 'वर्तमान पासवर्ड'
                      : 'Current Password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showCurrentPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _showCurrentPassword = !_showCurrentPassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(),
                ),
                obscureText: !_showCurrentPassword,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: UserSingleton().languageNotifier.value
                      ? 'नया पासवर्ड'
                      : 'New Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showNewPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _showNewPassword = !_showNewPassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(),
                ),
                obscureText: !_showNewPassword,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: UserSingleton().languageNotifier.value
                      ? 'नया पासवर्ड की पुष्टि करें'
                      : 'Confirm New Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(),
                ),
                obscureText: !_showConfirmPassword,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_newPasswordController.text !=
                      _confirmPasswordController.text) {
                    // Passwords don't match
                    print('Passwords do not match');
                    return;
                  }
                  print('userId: ${UserSingleton().getUserId()}');
                  _changePassword(userId: UserSingleton().getUserId());
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  UserSingleton().languageNotifier.value
                      ? 'पासवर्ड बदलें'
                      : 'Change Password',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
