import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mp_police/user/user_navbar.dart';
import 'package:mp_police/widget/widget.dart';

class RegistrationPendingScreen extends StatefulWidget {
  final String userId;

  RegistrationPendingScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _RegistrationPendingScreenState createState() =>
      _RegistrationPendingScreenState();
}

class _RegistrationPendingScreenState extends State<RegistrationPendingScreen> {
  bool _isLoading = true;
  bool _isApproved = false;

  @override
  void initState() {
    super.initState();
    _checkRegistrationStatus();
  }

  Future<void> _checkRegistrationStatus() async {
    final url = Uri.https('pscta.tdpvista.co.in',
        '/api/v1/user/approval/status/get', {'id': widget.userId});
    print("UserID: ${widget.userId}");

    try {
      final request = http.Request('OPTIONS', url);
      final streamedResponse = await http.Client().send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        print(jsonData);
        final userList = jsonData["User"] as List<dynamic>;
        if (userList.isNotEmpty) {
          final user = userList.first as Map<String, dynamic>;
          final approvedStatus = user["approved_status"] as String;
          if (approvedStatus == '1') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserNavbar()),
            );
          } else {
            setState(() {
              _isLoading = false;
            });
          }
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Pending'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _isApproved
              ? UserNavbar() // Navigate to home page if approved
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/login.png', // Replace with your image asset
                        width: 200,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Your registration is pending',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'It will be approved within 24 hours. Please be patient.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                          });
                          _checkRegistrationStatus();
                        },
                        child: Text('Refresh'), // Add your button text
                      ),
                    ],
                  ),
                ),
    );
  }
}
