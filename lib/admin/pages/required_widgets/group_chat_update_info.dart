import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mp_police/components/primary_button.dart';
import 'package:mp_police/utils/constants.dart';

// GroupChatInfoPage -- to view group information
class GroupChatUpdateInfo extends StatefulWidget {
  const GroupChatUpdateInfo({super.key});

  @override
  State<GroupChatUpdateInfo> createState() => _GroupChatUpdateInfoState();
}

class _GroupChatUpdateInfoState extends State<GroupChatUpdateInfo> {
  String aboutGroup = "";
  final TextEditingController _controller = TextEditingController();

  // To fetch group about data
  Future<String> fetchAboutGroup() async {
    try {
      final String api = dotenv.env['GET_GROUP_ABOUT_US_API']!;

      final request = http.Request(
        'OPTIONS',
        Uri.parse(api),
      )..headers['Content-Type'] = 'application/json';

      final http.StreamedResponse response = await http.Client().send(request);
      final responseString = await response.stream.bytesToString();
      final responseData = jsonDecode(responseString);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Request successful");
        }

        return responseData['aboutus']['group_aboutus'].toString();
      } else {
        if (kDebugMode) {
          print('Failed to load data: ${response.statusCode}');
        }
        return ''; // Return empty string or handle error as needed
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return ''; // Return empty string or handle error as needed
    }
  }

  // To update group about data
  Future<void> updateAboutGroup(String newAboutGroup) async {
    try {
      final String url = dotenv.env['UPDATE_GROUP_ABOUT_US_API']!;
      final body = jsonEncode({'group_aboutus': newAboutGroup});

      final request = http.Request('OPTIONS', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = body;

      final http.StreamedResponse response = await http.Client().send(request);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Update successful");
        }
      } else {
        if (kDebugMode) {
          print('Failed to update data: ${response.statusCode}');
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
    fetchAboutGroup().then((value) {
      setState(() {
        aboutGroup = value;
        _controller.text = value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffffffff),

        // body
        body: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      // Top section
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[primaryColor, secondaryColor]),
                        ),
                        child: Column(
                          children: [
                            // for adding some space
                            const SizedBox(height: 50),

                            // back button
                            Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(
                                    CupertinoIcons.back,
                                    color: Color(0xfffff3f3),
                                    size: 30,
                                  )),
                            ),

                            // for adding some space
                            const SizedBox(width: 30, height: 30),

                            // Group icon
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border:
                                      Border.all(width: 3, color: Colors.white)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: const CircleAvatar(
                                  radius: 70,
                                  backgroundImage:
                                      AssetImage("assets/images/logo.png"),
                                ),
                              ),
                            ),

                            // for adding some space
                            const SizedBox(height: 10),

                            // group name label
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: Text("Group Name",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      fontFamily: "PTSans-Regular")),
                            ),

                            // group official email address
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: Text("policeselfcare@gmaiul.com",
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                      fontFamily: "PTSans-Regular")),
                            ),

                            // for adding some space
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),

                      // Input field
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 10, left: 10, right: 10),
                        child: TextFormField(
                          controller: _controller,
                          maxLines: 4,
                          enabled: true,
                          // restriction to use at max 60 words in group about
                          inputFormatters: [
                            WordLimitTextInputFormatter(60),
                          ],
                          decoration: InputDecoration(
                            fillColor: Colors.white.withOpacity(0.3),
                            filled: true,
                            labelText: "About Group",
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    style: BorderStyle.solid,
                                    color: primaryColor,
                                    width: 2)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  style: BorderStyle.solid,
                                  color: Color(0xFF909A9E),
                                  width: 1.5),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      // Update button
                      PrimaryButton(
                      title: "UPDATE",
                          onPressed: () {
                            updateAboutGroup(_controller.text).then((value) => {
                              AwesomeDialog(
                                // ignore: use_build_context_synchronously
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.topSlide,
                                showCloseIcon: true,
                                title: "Successfully Updated",
                                desc:
                                "Group description has been updated successfully!",
                                btnOkText: "OK",
                                btnOkOnPress: () {
                                  Navigator.pop(context);
                                },
                              ).show()
                            });
                          }
                      ),

                      // Created at
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Created at: ',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  fontFamily: "PTSans-Regular"),
                            ),
                            Text("Group Time",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontFamily: "PTSans-Regular")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

// class to restrict about description.
class WordLimitTextInputFormatter extends TextInputFormatter {
  final int maxWords;

  WordLimitTextInputFormatter(this.maxWords);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;
    final wordCount = newText.split(' ').length;

    if (wordCount <= maxWords) {
      return newValue;
    } else {
      Fluttertoast.showToast(msg: "Can not use more then 60 words in about.");
      // If the word count exceeds the limit, return the old value
      return oldValue;
    }
  }
}

