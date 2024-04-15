// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:mp_police/user/signUpandAuth/member_detail.dart';
import 'package:mp_police/widget/widget.dart';

class MoreDetailsPage extends StatefulWidget {
  final String userId;
  const MoreDetailsPage({super.key, required this.userId});

  @override
  _MoreDetailsPageState createState() => _MoreDetailsPageState();
}

class _MoreDetailsPageState extends State<MoreDetailsPage> {
  final TextEditingController _homeAddressController = TextEditingController();
  final TextEditingController _homeDistrictController = TextEditingController();
  final TextEditingController _diseaseController = TextEditingController();
  final TextEditingController _causeOfIllnessController =
  TextEditingController();
  bool _showCauseOfIllness = false;

  Future<void> checkOptions(
      String userId,
      String homeAddress,
      String homeDistrict,
      String disease,
      ) async {
    final String url = dotenv.env['UPDATE_USER_API']!;

    try {
      final request = http.Request('OPTIONS', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({
          'id': userId,
          'home_address': homeAddress,
          'home_district': homeDistrict,
          'is_disease': disease,
        });
      final response = await http.Client().send(request);

      if (response.statusCode == 200) {
        // Handle success case
        // Proceed with navigation or any other action
        nextScreen(context, MemberDetailsPage(userId: userId.toString()));
      } else {
        // Handle failure case
        if (kDebugMode) {
          print('Failed OPTIONS request: ${response.reasonPhrase}');
        }
      }
    } catch (error) {
      // Handle error case
      if (kDebugMode) {
        print('Error making OPTIONS request: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Lottie.asset("assets/animations/register.json",
                    animate: true, width: double.infinity),
              ),
              const SizedBox(height: 20),
              const Text(
                'Home Address',
                style: TextStyle(
                  fontFamily: 'robot',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _homeAddressController,
                decoration: InputDecoration(
                  hintText: "Home Address",
                  labelText: "Home Address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Home District',
                style: TextStyle(
                  fontFamily: 'robot',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _homeDistrictController,
                decoration: InputDecoration(
                  hintText: "Home District",
                  labelText: "Home District",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Disease',
                style: TextStyle(
                  fontFamily: 'robot',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _diseaseController,
                onChanged: (value) {
                  setState(() {
                    _showCauseOfIllness = value.isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Disease",
                  labelText: "Disease",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                ),
              ),
              Visibility(
                visible: _showCauseOfIllness,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Cause of Illness',
                      style: TextStyle(
                        fontFamily: 'robot',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _causeOfIllnessController,
                      decoration: InputDecoration(
                        hintText: "Cause of Illness",
                        labelText: "Cause of Illness",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Proceed with saving personal details
                  String homeAddress = _homeAddressController.text;
                  String homeDistrict = _homeDistrictController.text;
                  String disease = _diseaseController.text;
                  checkOptions(
                    widget.userId,
                    homeAddress,
                    homeDistrict,
                    disease,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(
                      fontSize: 18, fontFamily: 'robot', color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
