import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mp_police/utils/constants.dart';
import 'package:mp_police/widget/widget.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  // Controller for text fields
  TextEditingController description1Controller = TextEditingController();
  TextEditingController description2Controller = TextEditingController();
  TextEditingController description3Controller = TextEditingController();
  TextEditingController description4Controller = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: ValueListenableBuilder<bool>(
          valueListenable: UserSingleton().languageNotifier,
          builder: (context, isHindi, child) {
            return Text(
              isHindi ? "हमारे बारे में" : "About Us",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            );
          },
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
                child: Text(
                  "Police Self Care",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            buildDescriptionTextField(description1Controller, "Description 1"),
            buildDescriptionTextField(description2Controller, "Description 2"),
            buildDescriptionTextField(description3Controller, "Description 3"),
            buildDescriptionTextField(description4Controller, "Description 4"),
          ],
        ),
      ),
    );
  }

  Widget buildDescriptionTextField(
      TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: TextField(
        readOnly: true,
        controller: controller,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: labelText,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: primaryColor,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              style: BorderStyle.solid,
              color: Color(0xFF909A9E),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
