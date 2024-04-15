// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mp_police/user/signUpandAuth/nominee_details.dart';
import 'package:http/http.dart' as http;
import 'package:mp_police/widget/widget.dart';

class MemberDetailsPage extends StatefulWidget {
  final String userId;
  const MemberDetailsPage({
    super.key,
    required this.userId,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MemberDetailsPageState createState() => _MemberDetailsPageState();
}

class _MemberDetailsPageState extends State<MemberDetailsPage> {
  final TextEditingController _batchIdController = TextEditingController();
  final TextEditingController _postingDetailsController =
      TextEditingController();
  final TextEditingController _postingOfficeController =
      TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postController =
      TextEditingController(); // Changed to post

  Future<void> checkOptions(
    String userId,
    String batchId,
    String postingDetails,
    String postingOffice,
    String district,
    String state,
    String post, // Changed to post
  ) async {
    final String url = dotenv.env['UPDATE_USER_API']!;

    try {
      final request = http.Request('OPTIONS', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({
          'id': userId,
          'batch_id': batchId,
          'posting_details': postingDetails,
          'posting_office': postingOffice,
          'district': district,
          'state': state,
          'post': post, // Changed to post
        });

      final streamedResponse = await http.Client().send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Handle success
        nextScreen(
            context,
            NomineeDetailsPage(
              userId: userId.toString(),
            ));
      } else {
        // Handle failure
        if (kDebugMode) {
          print('Failed to save member details');
        }
      }
    } catch (error) {
      // Handle error
      if (kDebugMode) {
        print('Error saving member details: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Batch ID',
                  style: TextStyle(
                    fontFamily: 'robot',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _batchIdController,
                decoration: InputDecoration(
                  hintText: "Batch ID",
                  labelText: "Batch ID",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                ),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Post', // Changed to Post
                  style: TextStyle(
                    fontFamily: 'robot',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _postController, // Changed to postController
                decoration: InputDecoration(
                  hintText: "Post", // Changed to Post
                  labelText: "Post", // Changed to Post
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                ),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Posting Details',
                  style: TextStyle(
                    fontFamily: 'robot',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _postingDetailsController,
                decoration: InputDecoration(
                  hintText: "Posting Details",
                  labelText: "Posting Details",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                ),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Posting Office',
                  style: TextStyle(
                    fontFamily: 'robot',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _postingOfficeController,
                decoration: InputDecoration(
                  hintText: "Posting Office",
                  labelText: "Posting Office",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                ),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'District',
                  style: TextStyle(
                    fontFamily: 'robot',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _districtController,
                decoration: InputDecoration(
                  hintText: "District",
                  labelText: "District",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                ),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'State',
                  style: TextStyle(
                    fontFamily: 'robot',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _stateController,
                decoration: InputDecoration(
                  hintText: "State",
                  labelText: "State",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: ElevatedButton(
                      onPressed: () {
                        checkOptions(
                          widget.userId,
                          _batchIdController.text,
                          _postingDetailsController.text,
                          _postingOfficeController.text,
                          _districtController.text,
                          _stateController.text,
                          _postController
                              .text, // Changed to _postController.text
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.green[900], // Changed to dark green
                        minimumSize: const Size(double.infinity, 40),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(
                            fontSize: 20, // Increased font size
                            fontFamily: 'robot',
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
