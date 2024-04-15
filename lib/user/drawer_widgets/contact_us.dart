import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:mp_police/widget/widget.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  // Controller for text fields
  TextEditingController contactNumber1Controller = TextEditingController();
  TextEditingController contactNumber2Controller = TextEditingController();
  TextEditingController emailAddress1Controller = TextEditingController();
  TextEditingController emailAddress2Controller = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // To get contact us data
  Future<void> fetchData() async {
    final String url = dotenv.env['GET_CONTACT_US_API']!;

    final response = await http.Client().send(http.Request('OPTIONS',
        Uri.parse(url)));
    if (response.statusCode == 200) {
      final responseData = jsonDecode(await response.stream.bytesToString());
      final contactUs = responseData['contactus'][0];
      setState(() {
        contactNumber1Controller.text = contactUs['contact_number1'];
        contactNumber2Controller.text = contactUs['contact_number2'];
        emailAddress1Controller.text = contactUs['email1'];
        emailAddress2Controller.text = contactUs['email2'];
        addressController.text = contactUs['address'];
      });
    } else {
      throw Exception('Failed to load contact us information');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: ValueListenableBuilder<bool>(
          valueListenable: UserSingleton().languageNotifier,
          builder: (context, isHindi, child) {
            return Text(
              isHindi ? "हमसे संपर्क करें" : "Contact Us",
              style: TextStyle(
                color: Colors.black,
              ),
            );
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
            buildTextField(contactNumber1Controller, "Contact 1", Icons.phone),
            buildTextField(contactNumber2Controller, "Contact 2", Icons.phone),
            buildTextField(emailAddress1Controller, "Email 1", Icons.email),
            buildTextField(emailAddress2Controller, "Email 2", Icons.email),
            buildTextField(addressController, "Address", Icons.location_on),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller, String labelText, IconData prefixIcon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: TextField(
        readOnly: true,
        controller: controller,
        maxLines: 1,
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon),
          labelText: labelText,
        ),
      ),
    );
  }
}
