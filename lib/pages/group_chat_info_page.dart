import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mp_police/utils/constants.dart';

// GroupChatInfoPage -- to view group information
class GroupChatInfoPage extends StatefulWidget {
  const GroupChatInfoPage({super.key});

  @override
  State<GroupChatInfoPage> createState() => _GroupChatInfoPageState();
}

class _GroupChatInfoPageState extends State<GroupChatInfoPage> {
  String aboutGroup = "";
  // To fetch group about data
  Future<String> fetchAboutGroup() async {
    try {
      final String api = dotenv.env['GET_GROUP_ABOUT_US_API']!;

      final request = http.Request(
        'OPTIONS',
        Uri.parse(api),
      )..headers['Content-Type'] = 'application/json';

      final http.StreamedResponse response =
      await http.Client().send(request);
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

  @override
  void initState() {
    super.initState();
    fetchAboutGroup().then((value) {
      setState(() {
        aboutGroup = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffffffff),

        // group creating date
        floatingActionButton: const Padding(
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

        // body
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                          border: Border.all(width: 3, color: Colors.white)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const CircleAvatar(
                          radius: 70,
                          backgroundImage: AssetImage("assets/images/logo.png"),
                        ),
                      ),
                    ),

                    // for adding some space
                    const SizedBox(height: 10),

                    // group name label
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Text("Group Name",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              fontFamily: "PTSans-Regular")),
                    ),

                    // group official email address
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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

              // for adding some space
              const SizedBox(height: 30),

              // about label
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Text(
                    'About',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              // about group
              aboutGroup == "" ? Center(child: CircularProgressIndicator(color: primaryColor, backgroundColor: secondaryColor,)) : Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Expanded(
                  child: Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 10),
                    elevation: 0.5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(5))),
                    color: Color(0xfffff8f7),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10.0, bottom: 30.0),
                      child: Text(aboutGroup,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: "PTSans-Regular")),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
