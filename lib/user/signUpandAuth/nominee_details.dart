import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mp_police/user/pages/registration_pending.dart';

import 'package:mp_police/user/user_navbar.dart';
import 'package:mp_police/widget/widget.dart';

class NomineeDetailsPage extends StatefulWidget {
  final String userId;
  const NomineeDetailsPage({super.key, required this.userId});

  @override
  // ignore: library_private_types_in_public_api
  _NomineeDetailsPageState createState() => _NomineeDetailsPageState();
}

class _NomineeDetailsPageState extends State<NomineeDetailsPage> {
  final List<Map<String, TextEditingController>> _nominees = [];

  @override
  void initState() {
    super.initState();
    // Initialize with one set of dummy data
    _nominees.add({
      'name': TextEditingController(),
      'relation': TextEditingController(),
      'mobile': TextEditingController(),
    });
  }

  Future<void> checkOptions(
      String userId, List<Map<String, String>> nominees) async {
    final List<Map<String, String>> formattedNominees = [];

    for (final nominee in nominees) {
      final Map<String, String> formattedNominee = {
        'name': nominee['name']!,
        'phone': nominee['mobile']!,
        'relation': nominee['relation']!,
      };
      formattedNominees.add(formattedNominee);
    }

    final String url = dotenv.env['UPDATE_USER_API']!;

    try {
      final request = http.Request('OPTIONS', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({
          'id': userId,
          'nominee': formattedNominees,
        });

      final streamedResponse = await http.Client().send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Handle success
        // ignore: use_build_context_synchronously
        UserSingleton.instance.userId = userId;

        nextScreen(
            context,
            RegistrationPendingScreen(
              userId: userId,
            ));
      } else {
        // Handle failure
        if (kDebugMode) {
          print('Failed to save nominee details');
        }
      }
    } catch (error) {
      // Handle error
      if (kDebugMode) {
        print('Error saving nominee details: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nominee Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _nominees.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Nominee ${index + 1}',
                        style: const TextStyle(
                          fontFamily: 'robot',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _nominees[index]['name']!,
                        decoration: InputDecoration(
                          hintText: "Nominee Name",
                          labelText: "Nominee Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16.0),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _nominees[index]['relation']!,
                        decoration: InputDecoration(
                          hintText: "Relation",
                          labelText: "Relation",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16.0),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _nominees[index]['mobile']!,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "Mobile Number",
                          labelText: "Mobile Number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16.0),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _nominees.add({
                          'name': TextEditingController(),
                          'relation': TextEditingController(),
                          'mobile': TextEditingController(),
                        });
                      });
                    },
                    child: const Text('Add Nominee'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Convert the list of nominees into the required format
                      final List<Map<String, String>> nominees =
                          _nominees.map((nominee) {
                        return {
                          'name': nominee['name']!.text,
                          'mobile': nominee['mobile']!.text,
                          'relation': nominee['relation']!.text,
                        };
                      }).toList();

                      // Call the function to send OPTIONS request with nominee details
                      checkOptions(widget.userId, nominees);
                    },
                    child: const Text('Go to Next Page'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
