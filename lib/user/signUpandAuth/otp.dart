import 'package:flutter/material.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController1 = TextEditingController();
  final TextEditingController _otpController2 = TextEditingController();
  final TextEditingController _otpController3 = TextEditingController();
  final TextEditingController _otpController4 = TextEditingController();

  late FocusNode _focusNode1;
  late FocusNode _focusNode2;
  late FocusNode _focusNode3;
  late FocusNode _focusNode4;

  @override
  void initState() {
    super.initState();
    _focusNode1 = FocusNode();
    _focusNode2 = FocusNode();
    _focusNode3 = FocusNode();
    _focusNode4 = FocusNode();
  }

  @override
  void dispose() {
    _otpController1.dispose();
    _otpController2.dispose();
    _otpController3.dispose();
    _otpController4.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30.0),
              Image.asset(
                'assets/images/login.png',
                width: 200,
                height: 150,
              ),
              const SizedBox(height: 30.0),
              const Text(
                'Enter the OTP sent to your mobile number',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OTPDigitField(
                    controller: _otpController1,
                    focusNode: _focusNode1,
                    nextFocusNode: _focusNode2,
                  ),
                  OTPDigitField(
                    controller: _otpController2,
                    focusNode: _focusNode2,
                    nextFocusNode: _focusNode3,
                  ),
                  OTPDigitField(
                    controller: _otpController3,
                    focusNode: _focusNode3,
                    nextFocusNode: _focusNode4,
                  ),
                  OTPDigitField(
                    controller: _otpController4,
                    focusNode: _focusNode4,
                    nextFocusNode: null,
                  ),
                ],
              ),
              const SizedBox(height: 50.0), // Adjust spacing as needed
              ElevatedButton(
                onPressed: () {
                  // Action to resend OTP
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Change button color to green
                  minimumSize: const Size(double.infinity, 50), // Make button bigger
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(fontSize: 20), // Increase text size
                ),
              ),
              const SizedBox(height: 20.0), // Adjust spacing as needed
              ElevatedButton(
                onPressed: () {
                  // Action for Done Button
                },
                child: const Text('Resend OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OTPDigitField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;

  const OTPDigitField({super.key,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      height: 50.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          counterText: '', // Hide character counter
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.isNotEmpty && nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
      ),
    );
  }
}
