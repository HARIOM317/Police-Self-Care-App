import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mp_police/utils/constants.dart';

class EditAboutUs extends StatefulWidget {
  const EditAboutUs({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditAboutUsState createState() => _EditAboutUsState();
}

class _EditAboutUsState extends State<EditAboutUs> {
  // Controller for text fields
  TextEditingController description1Controller = TextEditingController();
  TextEditingController description2Controller = TextEditingController();
  TextEditingController description3Controller = TextEditingController();
  TextEditingController description4Controller = TextEditingController();

  bool isEditModeOn = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // To get about us data
  Future<void> fetchData() async {
    final String url = dotenv.env['GET_ABOUT_US_API']!;

    final response = await http.Client().send(http.Request('OPTIONS',
        Uri.parse(url)));
    if (response.statusCode == 200) {
      final responseData = jsonDecode(await response.stream.bytesToString());
      final aboutUs = responseData['aboutus'][0];
      setState(() {
        description1Controller.text = aboutUs['description1'];
        description2Controller.text = aboutUs['description2'];
        description3Controller.text = aboutUs['description3'];
        description4Controller.text = aboutUs['description4'];
      });
    } else {
      throw Exception('Failed to load about us information');
    }
  }

  // To update about us data
  Future<void> updateData() async {
    final String url = dotenv.env['ABOUT_US_UPDATE_API']!;

    final request = http.Request('OPTIONS',
        Uri.parse(url));
    request.headers['Content-Type'] = 'application/json';
    request.body = jsonEncode({
      'description1': description1Controller.text,
      'description2': description2Controller.text,
      'description3': description3Controller.text,
      'description4': description4Controller.text,
    });

    final response = await http.Client().send(request);
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(msg: "data updated successfully!");
      AwesomeDialog(
        // ignore: use_build_context_synchronously
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: "Information Updated",
        titleTextStyle: TextStyle(
            color: Colors.green[900], fontSize: 20, fontWeight: FontWeight.bold),
        desc: "Your about us information has been updated successfully",
        descTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        btnOkOnPress: () {
          setState(() {
            isEditModeOn = false;
          });
        },
        btnOkText: "OK",
      ).show();
    } else {
      Fluttertoast.showToast(msg: "Failed to update about us information");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          "Edit About Us",
          style: TextStyle(
              color: primaryColor, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        child: ListView(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage("assets/images/logo.png"),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 16),
              child: Center(
                  child: Text("Police Self Care", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
              ),
            ),

            // Description 1
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: TextField(
                readOnly: isEditModeOn ? false : true,
                controller: description1Controller,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Description 1",
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: primaryColor,
                          width: 2)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        style: BorderStyle.solid,
                        color: Color(0xFF909A9E),
                        width: 1.5),
                  ),
                ),
              ),
            ),

            // Description 2
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: TextField(
                controller: description2Controller,
                maxLines: 3,
                readOnly: isEditModeOn ? false : true,
                decoration: InputDecoration(
                  labelText: "Description 2",
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: primaryColor,
                          width: 2)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        style: BorderStyle.solid,
                        color: Color(0xFF909A9E),
                        width: 1.5),
                  ),
                ),
              ),
            ),

            // Description 3
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: TextField(
                controller: description3Controller,
                maxLines: 3,
                readOnly: isEditModeOn ? false : true,
                decoration: InputDecoration(
                  labelText: "Description 3",
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: primaryColor,
                          width: 2)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        style: BorderStyle.solid,
                        color: Color(0xFF909A9E),
                        width: 1.5),
                  ),
                ),
              ),
            ),

            // Description 4
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: TextField(
                controller: description4Controller,
                maxLines: 3,
                readOnly: isEditModeOn ? false : true,
                decoration: InputDecoration(
                  labelText: "Description 4",
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: primaryColor,
                          width: 2)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        style: BorderStyle.solid,
                        color: Color(0xFF909A9E),
                        width: 1.5),
                  ),
                ),
              ),
            ),

            // Update button
            Container(
              margin: const EdgeInsets.all(20),
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isEditModeOn = !isEditModeOn;
                  });
                  if (!isEditModeOn) {
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.question,
                        animType: AnimType.topSlide,
                        showCloseIcon: true,
                        title: "Confirm Update Information",
                        titleTextStyle: TextStyle(
                            color: Colors.green[900],
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        desc: "Are you sure you want to update about us information?",
                        descTextStyle:
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        btnOkOnPress: () {
                          updateData();
                        },
                        btnOkText: "Update",
                        btnCancelOnPress: () {
                          setState(() {
                            isEditModeOn = false;
                          });
                        })
                        .show();
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: isEditModeOn ? primaryColor : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: Text(
                  isEditModeOn ? 'Update' : "Edit",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isEditModeOn ? Colors.white : Colors.black45),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
