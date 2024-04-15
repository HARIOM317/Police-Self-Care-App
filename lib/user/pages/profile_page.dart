import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:mp_police/components/primary_button.dart';
import 'package:mp_police/user/pages/donation_tracking_page.dart';
import 'package:mp_police/user/pages/pay_for_donation.dart';
import 'package:mp_police/utils/constants.dart';
import 'package:mp_police/widget/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  int userId = -1;
  String userImg = '';
  String userName = '';
  String userEmail = '';
  String userPhone = '';
  bool isRenewalPending = true; // Assuming renewal is pending by default

  Future<void> getUserDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId') ?? -1;
      userImg = prefs.getString('userImg') ?? '';
      userName = prefs.getString('userName') ?? '';
      userEmail = prefs.getString('userEmail') ?? '';
      userPhone = prefs.getString('userPhone') ?? '';
    });
  }

  Future<void> _handleRefresh() async {
    getUserDataFromSharedPreferences();
    return await Future.delayed(const Duration(seconds: 3));
  }

  @override
  void initState() {
    super.initState();
    getUserDataFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: LiquidPullToRefresh(
            onRefresh: _handleRefresh,
            color: Colors.transparent,
            backgroundColor: primaryColor,
            height: 300,
            animSpeedFactor: 3,
            showChildOpacityTransition: true,
            child: CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // User Profile Image
                          Container(
                            margin: const EdgeInsets.all(0),
                            width: double.infinity,
                            height: 250,
                            child: userImg == ""
                                ? CircleAvatar(
                                    backgroundColor: secondaryColor,
                                    radius: 125,
                                    child: Icon(
                                      CupertinoIcons.person_fill,
                                      size: 150,
                                      color: Colors.white,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 125,
                                    backgroundImage: NetworkImage(userImg),
                                  ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // Name
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: Text(
                              userName,
                              style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),

                          // Email
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: Text(
                              userEmail,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black54),
                            ),
                          ),

                          // Phone
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: Text(
                              userPhone,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          // Edit Button
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            height: 60,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                goTo(context, const UpdateUserInformation());
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              child: Wrap(
                                children: <Widget>[
                                  Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 24.0,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton().languageNotifier,
                                    builder: (context, isHindi, child) {
                                      return Text(
                                          isHindi
                                              ? "प्रोफ़ाइल संपादित करें"
                                              : "EDIT PROFILE",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Renew Platform Fees Button
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            height: 60,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // goTo(context, PayForDonationPage(id: null,));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              child: Wrap(
                                children: <Widget>[
                                  Icon(
                                    Icons.autorenew,
                                    color: Colors.white,
                                    size: 24.0,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton().languageNotifier,
                                    builder: (context, isHindi, child) {
                                      return Text(
                                          isHindi
                                              ? "प्लेटफ़ॉर्म शुल्क नवीकरण करें"
                                              : "RENEW PLATFORM FEES",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Donation Tracking Button
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            height: 60,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                goTo(context, const DonationTrackingPage());
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              child: Wrap(
                                children: <Widget>[
                                  Icon(
                                    Icons.track_changes,
                                    color: Colors.white,
                                    size: 24.0,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton().languageNotifier,
                                    builder: (context, isHindi, child) {
                                      return Text(
                                          isHindi
                                              ? "पिछले दान को ट्रैक करें"
                                              : "TRACK PREVIOUS HELP",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UpdateUserInformation extends StatefulWidget {
  const UpdateUserInformation({super.key});

  @override
  State<UpdateUserInformation> createState() => _UpdateUserInformationState();
}

class _UpdateUserInformationState extends State<UpdateUserInformation> {
  bool isSaving = false;

  int userId = -1;
  String userName = '';
  String userEmail = '';
  String userPhone = '';
  String userImg = '';
  String userGender = '';
  String userBloodGroup = '';
  String userCurrentAddress = '';
  String userHomeAddress = '';
  String userDistrict = '';
  String userHomeDistrict = '';
  String userState = '';
  String userPost = '';
  String userPostingDetails = '';
  String userPostingOffice = '';

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var genderController = TextEditingController();
  var bloodGroupController = TextEditingController();
  var currentAddressController = TextEditingController();
  var homeAddressController = TextEditingController();
  var districtController = TextEditingController();
  var homeDistrictController = TextEditingController();
  var stateController = TextEditingController();
  var postController = TextEditingController();
  var postingDetailsController = TextEditingController();
  var postingOfficeController = TextEditingController();

  Future<void> getUserDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId') ?? -1;
      userName = prefs.getString('userName') ?? '';
      userEmail = prefs.getString('userEmail') ?? '';
      userPhone = prefs.getString('userPhone') ?? '';
      userImg = prefs.getString('userImg') ?? '';
      userGender = prefs.getString('userGender') ?? '';
      userBloodGroup = prefs.getString('userBloodGroup') ?? '';
      userCurrentAddress = prefs.getString('userCurrentAddress') ?? '';
      userHomeAddress = prefs.getString('userHomeAddress') ?? '';
      userDistrict = prefs.getString('userDistrict') ?? '';
      userHomeDistrict = prefs.getString('userHomeDistrict') ?? '';
      userState = prefs.getString('userState') ?? '';
      userPost = prefs.getString('userPost') ?? '';
      userPostingDetails = prefs.getString('userPostingDetails') ?? '';
      userPostingOffice = prefs.getString('userPostingOffice') ?? '';

      nameController.text = userName;
      emailController.text = userEmail;
      phoneController.text = userPhone;
      genderController.text = userGender;
      bloodGroupController.text = userBloodGroup;
      currentAddressController.text = userCurrentAddress;
      homeAddressController.text = userHomeAddress;
      districtController.text = userDistrict;
      homeDistrictController.text = userHomeDistrict;
      stateController.text = userState;
      postController.text = userPost;
      postingDetailsController.text = userPostingDetails;
      postingOfficeController.text = userPostingOffice;
    });
  }

  Future<void> updateUserInformation() async {
    try {
      final String url = dotenv.env['UPDATE_USER_API']!;

      final body = jsonEncode({
        'id': userId,
        'name': nameController.text,
        'email': emailController.text,
        'mobile': phoneController.text,
        'img_url': userImg,
        'gender': genderController.text,
        'blood_group': bloodGroupController.text,
        'current_address': currentAddressController.text,
        'home_address': homeAddressController.text,
        'district': districtController.text,
        'home_district': homeDistrictController.text,
        'state': stateController.text,
        'post': postController.text,
        'posting_details': postingDetailsController.text,
        'posting_office': postingOfficeController.text
      });
      final request = http.Request('OPTIONS', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = body;

      final http.StreamedResponse response = await http.Client().send(request);

      if (response.statusCode == 200) {
        // Update user information in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('userName', nameController.text);
        prefs.setString('userEmail', emailController.text);
        prefs.setString('userPhone', phoneController.text);
        // prefs.setString('userImg', phoneController.text);
        prefs.setString('userGender', genderController.text);
        prefs.setString('userBloodGroup', bloodGroupController.text);
        prefs.setString('userCurrentAddress', currentAddressController.text);
        prefs.setString('userHomeAddress', homeAddressController.text);
        prefs.setString('userDistrict', districtController.text);
        prefs.setString('userHomeDistrict', homeDistrictController.text);
        prefs.setString('userState', stateController.text);
        prefs.setString('userPost', postController.text);
        prefs.setString('userPostingDetails', postingDetailsController.text);
        prefs.setString('userPostingOffice', postingOfficeController.text);

        // Show a toast message to indicate successful update
        Fluttertoast.showToast(msg: 'User information updated successfully');
      } else {
        // Show a toast message to indicate update failure
        Fluttertoast.showToast(msg: 'Failed to update user information');
      }
    } catch (e) {
      // Show a toast message for any error that occurs during the request
      Fluttertoast.showToast(msg: 'Error updating user information: $e');
    }
  }

  Future<void> _handleRefresh() async {
    getUserDataFromSharedPreferences();
    return await Future.delayed(const Duration(seconds: 3));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getUserDataFromSharedPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Hide keyboard to tap on screen
      onTap: () => FocusScope.of(context).unfocus(),

      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: isSaving == true
              ? const Center(child: CircularProgressIndicator())
              : LiquidPullToRefresh(
                  onRefresh: _handleRefresh,
                  color: Colors.transparent,
                  backgroundColor: primaryColor,
                  height: 300,
                  animSpeedFactor: 3,
                  showChildOpacityTransition: true,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            border: Border.all(
                                                width: 2, color: primaryColor)),
                                        child: userImg == ""
                                            ? CircleAvatar(
                                                radius: 70,
                                                backgroundColor: secondaryColor,
                                                child: const Icon(
                                                  Icons.person,
                                                  size: 120,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : CircleAvatar(
                                                radius: 70,
                                                backgroundColor: secondaryColor,
                                                backgroundImage:
                                                    NetworkImage(userImg),
                                              )),
                                    Positioned(
                                        bottom: 5,
                                        right: 5,
                                        child: GestureDetector(
                                          onTap: () async {},
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    width: 2,
                                                    color: Colors.white),
                                                color: primaryColor),
                                            child: const Icon(
                                              Icons.camera_alt_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )),
                                  ],
                                ),

                                // Personal Details Label
                                ValueListenableBuilder<bool>(
                                  valueListenable:
                                      UserSingleton().languageNotifier,
                                  builder: (context, isHindi, child) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 30.0,
                                            bottom: 8.0,
                                            left: 8.0,
                                            right: 8.0),
                                        child: Text(
                                          isHindi
                                              ? 'व्यक्तिगत विवरण'
                                              : 'Personal Details',
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                // Name
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 10, left: 10, right: 10),
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton().languageNotifier,
                                    builder: (context, isHindi, child) {
                                      return TextFormField(
                                        controller: nameController,
                                        enabled: true,
                                        decoration: InputDecoration(
                                          fillColor:
                                              Colors.white.withOpacity(0.3),
                                          filled: true,
                                          prefixIcon: const Icon(Icons.person),
                                          suffixIcon: const Icon(Icons.edit),
                                          labelText: isHindi
                                              ? "नाम"
                                              : "Name", // Language-specific label
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: primaryColor,
                                                  width: 2)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: Color(0xFF909A9E),
                                                  width: 1.5)),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      );
                                    },
                                  ),
                                ),

                                // Phone
                                // Phone
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 10),
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton().languageNotifier,
                                    builder: (context, isHindi, child) {
                                      return TextFormField(
                                        controller: phoneController,
                                        enabled: true,
                                        decoration: InputDecoration(
                                          fillColor:
                                              Colors.white.withOpacity(0.3),
                                          filled: true,
                                          prefixIcon: const Icon(Icons.phone),
                                          suffixIcon: const Icon(Icons.edit),
                                          labelText: isHindi
                                              ? "फ़ोन"
                                              : "Phone", // Language-specific label
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: primaryColor,
                                                  width: 2)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: Color(0xFF909A9E),
                                                  width: 1.5)),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      );
                                    },
                                  ),
                                ),

// Email
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 10),
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton().languageNotifier,
                                    builder: (context, isHindi, child) {
                                      return TextFormField(
                                        controller: emailController,
                                        enabled: true,
                                        decoration: InputDecoration(
                                          fillColor:
                                              Colors.white.withOpacity(0.3),
                                          filled: true,
                                          prefixIcon: const Icon(Icons.email),
                                          suffixIcon: const Icon(Icons.edit),
                                          labelText: isHindi
                                              ? "ईमेल"
                                              : "Email", // Language-specific label
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: primaryColor,
                                                  width: 2)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: Color(0xFF909A9E),
                                                  width: 1.5)),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      );
                                    },
                                  ),
                                ),

// Gender
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 10),
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton().languageNotifier,
                                    builder: (context, isHindi, child) {
                                      return TextFormField(
                                        controller: genderController,
                                        enabled: true,
                                        decoration: InputDecoration(
                                          fillColor:
                                              Colors.white.withOpacity(0.3),
                                          filled: true,
                                          prefixIcon:
                                              const Icon(Icons.female_sharp),
                                          suffixIcon: const Icon(Icons.edit),
                                          labelText: isHindi
                                              ? "लिंग"
                                              : "Gender", // Language-specific label
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: primaryColor,
                                                  width: 2)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: Color(0xFF909A9E),
                                                  width: 1.5)),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      );
                                    },
                                  ),
                                ),

// Blood Group
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 10),
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton().languageNotifier,
                                    builder: (context, isHindi, child) {
                                      return TextFormField(
                                        controller: bloodGroupController,
                                        enabled: true,
                                        decoration: InputDecoration(
                                          fillColor:
                                              Colors.white.withOpacity(0.3),
                                          filled: true,
                                          prefixIcon:
                                              const Icon(Icons.bloodtype),
                                          suffixIcon: const Icon(Icons.edit),
                                          labelText: isHindi
                                              ? "रक्त समूह"
                                              : "Blood Group", // Language-specific label
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: primaryColor,
                                                  width: 2)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: Color(0xFF909A9E),
                                                  width: 1.5)),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      );
                                    },
                                  ),
                                ),

                                // Home District
                                // Home District
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 10),
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton().languageNotifier,
                                    builder: (context, isHindi, child) {
                                      return TextFormField(
                                        controller: homeDistrictController,
                                        enabled: true,
                                        decoration: InputDecoration(
                                          fillColor:
                                              Colors.white.withOpacity(0.3),
                                          filled: true,
                                          prefixIcon:
                                              const Icon(Icons.location_city),
                                          suffixIcon: const Icon(Icons.edit),
                                          labelText: isHindi
                                              ? "गृह जिला"
                                              : "Home District", // Language-specific label
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: primaryColor,
                                                  width: 2)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: Color(0xFF909A9E),
                                                  width: 1.5)),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      );
                                    },
                                  ),
                                ),

// State
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 10),
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton().languageNotifier,
                                    builder: (context, isHindi, child) {
                                      return TextFormField(
                                        controller: stateController,
                                        enabled: true,
                                        decoration: InputDecoration(
                                          fillColor:
                                              Colors.white.withOpacity(0.3),
                                          filled: true,
                                          prefixIcon:
                                              const Icon(Icons.reduce_capacity),
                                          suffixIcon: const Icon(Icons.edit),
                                          labelText: isHindi
                                              ? "राज्य"
                                              : "State", // Language-specific label
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: primaryColor,
                                                  width: 2)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: Color(0xFF909A9E),
                                                  width: 1.5)),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      );
                                    },
                                  ),
                                ),

// Post
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 10),
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton().languageNotifier,
                                    builder: (context, isHindi, child) {
                                      return TextFormField(
                                        controller: postController,
                                        enabled: true,
                                        decoration: InputDecoration(
                                          fillColor:
                                              Colors.white.withOpacity(0.3),
                                          filled: true,
                                          prefixIcon:
                                              const Icon(Icons.portrait_sharp),
                                          suffixIcon: const Icon(Icons.edit),
                                          labelText: isHindi
                                              ? "पोस्ट"
                                              : "Post", // Language-specific label
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: primaryColor,
                                                  width: 2)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: Color(0xFF909A9E),
                                                  width: 1.5)),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      );
                                    },
                                  ),
                                ),

// Posting Office
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 10),
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton().languageNotifier,
                                    builder: (context, isHindi, child) {
                                      return TextFormField(
                                        controller: postingOfficeController,
                                        enabled: true,
                                        decoration: InputDecoration(
                                          fillColor:
                                              Colors.white.withOpacity(0.3),
                                          filled: true,
                                          prefixIcon: const Icon(Icons.room),
                                          suffixIcon: const Icon(Icons.edit),
                                          labelText: isHindi
                                              ? "पोस्टिंग ऑफ़िस"
                                              : "Posting Office", // Language-specific label
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: primaryColor,
                                                  width: 2)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: Color(0xFF909A9E),
                                                  width: 1.5)),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      );
                                    },
                                  ),
                                ),

// Posting Details
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 10),
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton().languageNotifier,
                                    builder: (context, isHindi, child) {
                                      return TextFormField(
                                        controller: postingDetailsController,
                                        enabled: true,
                                        maxLines: 3,
                                        decoration: InputDecoration(
                                          fillColor:
                                              Colors.white.withOpacity(0.3),
                                          filled: true,
                                          labelText: isHindi
                                              ? "पोस्टिंग विवरण"
                                              : "Posting Details", // Language-specific label
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: primaryColor,
                                                  width: 2)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: Color(0xFF909A9E),
                                                  width: 1.5)),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      );
                                    },
                                  ),
                                ),

// Update Button
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton().languageNotifier,
                                    builder: (context, isHindi, child) {
                                      return PrimaryButton(
                                        title: isHindi
                                            ? "प्रोफ़ाइल अपडेट करें"
                                            : "UPDATE PROFILE", // Language-specific label
                                        onPressed: () async {
                                          AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.question,
                                              animType: AnimType.topSlide,
                                              showCloseIcon: true,
                                              title: isHindi
                                                  ? "अपडेट की पुष्टि करें"
                                                  : "Confirm Update", // Language-specific title
                                              titleTextStyle: TextStyle(
                                                  color: Colors.green[900],
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                              desc: isHindi
                                                  ? "क्या आप वाकई अपनी जानकारी को अपडेट करना चाहते हैं?"
                                                  : "Are you sure you want to update your information?", // Language-specific description
                                              descTextStyle: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                              btnOkOnPress: () async {
                                                await updateUserInformation();
                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context)
                                                    .pop(false);
                                                Fluttertoast.showToast(
                                                    msg: isHindi
                                                        ? "आपकी जानकारी अपडेट हो रही है..."
                                                        : "Updating Your Information..."); // Language-specific toast message
                                              },
                                              btnOkText: isHindi
                                                  ? "पुष्टि करें"
                                                  : "Confirm", // Language-specific button text
                                              btnCancelOnPress: () {
                                                Fluttertoast.showToast(
                                                    msg: isHindi
                                                        ? "अपडेट कैंसिल किया गया"
                                                        : "Cancelled update"); // Language-specific toast message
                                              }).show();
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
