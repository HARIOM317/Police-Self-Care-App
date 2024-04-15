import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mp_police/components/primary_button.dart';
import 'dart:convert';

import 'package:mp_police/utils/constants.dart';

class EditRulesAndRegulations extends StatefulWidget {
  const EditRulesAndRegulations({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditRulesAndRegulationsState createState() => _EditRulesAndRegulationsState();
}

class _EditRulesAndRegulationsState extends State<EditRulesAndRegulations> {
  // Controller for text fields
  TextEditingController rule1Controller = TextEditingController();
  TextEditingController rule2Controller = TextEditingController();
  TextEditingController rule3Controller = TextEditingController();
  TextEditingController rule4Controller = TextEditingController();

  bool isEditModeOn = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // To get rules and regulations
  Future<void> fetchData() async {
    final String url = dotenv.env['GET_RULES_AND_REGULATIONS_API']!;

    final response = await http.Client().send(http.Request('OPTIONS', Uri.parse(url)));
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final rules = jsonDecode(responseData)['rulesregulations'];
      setState(() {
        rule1Controller.text = rules['rule1'];
        rule2Controller.text = rules['rule2'];
        rule3Controller.text = rules['rule3'];
        rule4Controller.text = rules['rule4'];
      });
    } else {
      throw Exception('Failed to load rule & regulations information');
    }
  }

  // To update rules and regulations
  Future<void> updateData() async {
    final String url = dotenv.env['UPDATE_RULES_AND_REGULATIONS_API']!;

    final request = http.Request('OPTIONS',
        Uri.parse(url));
    request.headers['Content-Type'] = 'application/json';
    request.body = jsonEncode({
      'rule1': rule1Controller.text,
      'rule2': rule2Controller.text,
      'rule3': rule3Controller.text,
      'rule4': rule4Controller.text,
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
        title: "Rules Updated",
        titleTextStyle: TextStyle(
            color: Colors.green[900], fontSize: 20, fontWeight: FontWeight.bold),
        desc: "Your rules and regulations has been updated successfully",
        descTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        btnOkOnPress: () {
          setState(() {
            isEditModeOn = false;
          });
        },
        btnOkText: "OK",
      ).show();
    } else {
      Fluttertoast.showToast(msg: "Failed to update rules and regulations");
    }
  }

  // To update pdf
  Future<void> uploadPDF(File file) async {
    final String api = dotenv.env['GET_RULES_AND_REGULATION_UPLOAD_PDF_API']!;

    var url = Uri.parse(api);

    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('pdf', file.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('PDF uploaded successfully');
      AwesomeDialog(
        // ignore: use_build_context_synchronously
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: "PDF Uploaded",
        titleTextStyle: TextStyle(
            color: Colors.green[900], fontSize: 20, fontWeight: FontWeight.bold),
        desc: "Your rules and regulations pdf has been updated successfully",
        descTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        btnOkOnPress: () {

        },
        btnOkText: "OK",
      ).show();
    } else {
      print('Failed to upload PDF. Status code: ${response.statusCode}');
      Fluttertoast.showToast(msg: "Failed to upload PDF");

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
          "Edit Rules & Regulations",
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

            // Rule 1
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: TextField(
                readOnly: isEditModeOn ? false : true,
                controller: rule1Controller,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Rule 1",
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

            // Rule 2
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: TextField(
                controller: rule2Controller,
                maxLines: 3,
                readOnly: isEditModeOn ? false : true,
                decoration: InputDecoration(
                  labelText: "Rule 2",
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

            // Rule 3
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: TextField(
                controller: rule3Controller,
                maxLines: 3,
                readOnly: isEditModeOn ? false : true,
                decoration: InputDecoration(
                  labelText: "Rule 3",
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

            // Rule 4
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: TextField(
                controller: rule4Controller,
                maxLines: 3,
                readOnly: isEditModeOn ? false : true,
                decoration: InputDecoration(
                  labelText: "Rule 4",
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
                        title: "Confirm Update Rules",
                        titleTextStyle: TextStyle(
                            color: Colors.green[900],
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        desc: "Are you sure you want to update rules & regulations?",
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

            PrimaryButton(title: "Upload PDF", onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf'],
              );

              if (result != null) {
                File file = File(result.files.single.path!);
                await uploadPDF(file);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('File selection canceled')));
              }
            })
          ],
        ),
      ),
    );
  }
}
