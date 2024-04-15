import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';
import 'package:mp_police/user/signUpandAuth/personal_details.dart';
import 'package:http/http.dart' as http;
import 'package:mp_police/widget/widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  bool _isObscure = true; // State variable to toggle password visibility

  bool validatePhoneNumber(String? phoneNumber) {
    const pattern = r'^[0-9]{10}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(phoneNumber!);
  }

  bool isValidEmail(String email) {
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  bool isValidPassword(String password) {
    const pattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }

  Future<void> checkOptions(
    String name,
    String email,
    String password,
    String mobile,
  ) async {
    final String url = dotenv.env['REGISTER_USER_API']!;

    try {
      final request = http.Request('OPTIONS', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'mobile': mobile,
        });
      final streamedResponse = await http.Client().send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        if (kDebugMode) {
          print('OPTIONS request successful');
        }

        final userId = jsonDecode(response.body)['user']['id'];
        if (kDebugMode) {
          print('userID: $userId');
        }

        if (kDebugMode) {
          print(response.body);
        }
        // ignore: use_build_context_synchronously
        nextScreen(context, PersonalDetailsPage(userId: userId.toString()));
      } else {
        if (kDebugMode) {
          print('Failed OPTIONS request: ${response.reasonPhrase}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error making OPTIONS request: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Police Selfcare Team'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Lottie.asset("assets/animations/register.json",
                    animate: true, width: double.infinity),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: usernameController,
                labelText: 'Full Name',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: emailController,
                labelText: 'Email',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  } else if (!isValidEmail(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              _buildPhoneNumberField(),
              const SizedBox(height: 15),
              _buildPasswordField(), // Add password field
              const SizedBox(height: 4),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      // Action for Forgot Password
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    checkOptions(usernameController.text, emailController.text,
                        passwordController.text, _phoneNumberController.text);
                  }
                },
                label: 'Register',
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: labelText,
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.green,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.red, // Change border color to red
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      controller: _phoneNumberController,
      decoration: InputDecoration(
        hintText: 'Phone Number',
        labelText: 'Phone Number',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.red, // Change border color to red if not valid
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
      ),
      onChanged: (value) {
        setState(() {
          // Force re-evaluation of validation state when the text changes
        });
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a phone number';
        } else if (!validatePhoneNumber(value)) {
          return 'Please enter a valid 10-digit phone number';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: _isObscure,
      decoration: InputDecoration(
        hintText: 'Password',
        labelText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.red, // Change border color to red if not valid
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
        suffixIcon: IconButton(
          icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure; // Toggle password visibility
            });
          },
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a password';
        } else if (!isValidPassword(value)) {
          return 'Password must contain at least one uppercase letter, one lowercase letter, one number, one special character and be at least 8 characters long';
        }
        return null;
      },
    );
  }

  Widget _buildElevatedButton({
    required VoidCallback onPressed,
    required String label,
  }) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.0,
        height: 50,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[900], // Dark green color
            minimumSize: const Size(double.infinity, 40),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 20, // Larger text size
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
