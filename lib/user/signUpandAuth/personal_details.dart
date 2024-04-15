import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mp_police/user/signUpandAuth/more_details.dart';
import 'package:mp_police/widget/widget.dart';

class PersonalDetailsPage extends StatefulWidget {
  final String userId;
  const PersonalDetailsPage({
    super.key,
    required this.userId,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PersonalDetailsPageState createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _cugNumberController = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  void selectImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  Future<void> checkOptions(
    String userId,
    String imageBase64,
    String gender,
    String bloodGroup,
    String cugNumber,
  ) async {
    final String url = dotenv.env['UPDATE_USER_API']!;

    try {
      final request = http.Request('OPTIONS', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({
          'id': userId,
          'img_url': imageBase64,
          'gender': gender,
          'blood_group': bloodGroup,
          'cug_mobile': cugNumber,
        });
      final response = await http.Client().send(request);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('OPTIONS request successful');
        }
        // Handle success case
        // Proceed with registration or any other action
        // ignore: use_build_context_synchronously
        nextScreen(context, MoreDetailsPage(userId: userId.toString()));
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
        title: const Text('Personal Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _image == null
                              ? Icon(
                                  Icons.account_circle,
                                  size: 100,
                                  color: Colors.grey[600],
                                )
                              : Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.add_a_photo,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Gender',
                  style: TextStyle(
                    fontFamily: 'robot',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _genderController,
                readOnly: true,
                onTap: () {
                  _showGenderList();
                },
                decoration: InputDecoration(
                  hintText: 'Select Gender',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  suffixIcon: const Icon(Icons.keyboard_arrow_down),
                ),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Blood Group',
                  style: TextStyle(
                    fontFamily: 'robot',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _bloodGroupController,
                readOnly: true,
                onTap: () {
                  _showBloodGroupList();
                },
                decoration: InputDecoration(
                  hintText: 'Select Blood Group',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  suffixIcon: const Icon(Icons.keyboard_arrow_down),
                ),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'CUG Number',
                  style: TextStyle(
                    fontFamily: 'robot',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _cugNumberController,
                decoration: InputDecoration(
                  hintText: 'Enter CUG Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter CUG Number';
                  } else if (!isNumeric(value)) {
                    return 'CUG Number should contain only numbers';
                  } else if (value.length != 10) {
                    return 'CUG Number should be 10 digits long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.1,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_image != null &&
                            _genderController.text.isNotEmpty &&
                            _bloodGroupController.text.isNotEmpty &&
                            _cugNumberController.text.isNotEmpty) {
                          String imageBase64 =
                              base64Encode(_image!.readAsBytesSync());
                          String gender = _genderController.text;
                          String bloodGroup = _bloodGroupController.text;
                          String cugNumber = _cugNumberController.text;

                          checkOptions(widget.userId, imageBase64, gender,
                              bloodGroup, cugNumber);
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Incomplete Data'),
                                content: const Text(
                                    'Please select image, gender, blood group, and CUG number before saving.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        minimumSize: const Size(double.infinity, 40),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(
                            fontSize: 18,
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

  void _showGenderList() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: _genders.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(_genders[index],
                  style: const TextStyle(fontSize: 18, fontFamily: 'robot')),
              onTap: () {
                setState(() {
                  _genderController.text = _genders[index];
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _showBloodGroupList() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: _bloodGroups.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(_bloodGroups[index],
                  style: const TextStyle(fontSize: 18, fontFamily: 'robot')),
              onTap: () {
                setState(() {
                  _bloodGroupController.text = _bloodGroups[index];
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }
}
