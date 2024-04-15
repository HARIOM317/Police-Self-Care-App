import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:mp_police/components/primary_button.dart';
import 'package:mp_police/utils/constants.dart';
import 'package:mp_police/widget/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({Key? key}) : super(key: key);

  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  int adminId = -1;
  String adminImg = '';
  String adminName = '';
  String adminEmail = '';
  String adminPhone = '';
  String adminRole = '';

  Future<void> getAdminDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      adminId = prefs.getInt('adminId') ?? -1;
      adminImg = prefs.getString('adminImg') ?? '';
      adminName = prefs.getString('adminName') ?? '';
      adminEmail = prefs.getString('adminEmail') ?? '';
      adminPhone = prefs.getString('adminPhone') ?? '';
      adminRole = prefs.getString('adminRole') ?? '';
    });
  }

  Future<void> _handleRefresh() async {
    getAdminDataFromSharedPreferences();
    return await Future.delayed(const Duration(seconds: 3));
  }

  @override
  void initState() {
    super.initState();
    getAdminDataFromSharedPreferences();
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
                  child: ValueListenableBuilder<bool>(
                    valueListenable: UserSingleton.instance.languageNotifier,
                    builder: (context, isHindi, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // User Profile Image
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border:
                                      Border.all(width: 2, color: primaryColor),
                                ),
                                child: adminImg.isEmpty
                                    ? CircleAvatar(
                                        radius: 70,
                                        backgroundColor: secondaryColor,
                                        child: const Icon(
                                          CupertinoIcons.person_fill,
                                          size: 120,
                                          color: Colors.white,
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 70,
                                        backgroundColor: secondaryColor,
                                        backgroundImage: NetworkImage(adminImg),
                                      ),
                              ),
                              const SizedBox(height: 20),
                              // Name
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Text(
                                  adminName,
                                  style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),

                              // Role
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Text(
                                  adminRole,
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),

                              // Email
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Text(
                                  adminEmail,
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
                                  adminPhone,
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
                                child: ValueListenableBuilder<bool>(
                                  valueListenable:
                                      UserSingleton.instance.languageNotifier,
                                  builder: (context, isHindi, _) {
                                    return ElevatedButton(
                                      onPressed: () {
                                        goTo(context,
                                            const UpdateAdminInformation());
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                      ),
                                      child: Wrap(
                                        children: <Widget>[
                                          Icon(Icons.edit,
                                              color: Colors.white, size: 24.0),
                                          SizedBox(width: 10),
                                          Text(
                                            isHindi
                                                ? 'EDIT PROFILE'
                                                : 'प्रोफ़ाइल संपादित करें',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // Renew Platform Fees Button
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                height: 60,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton.instance.languageNotifier,
                                    builder: (context, isHindi, _) {
                                      return Wrap(
                                        children: <Widget>[
                                          Icon(Icons.autorenew,
                                              color: Colors.white, size: 24.0),
                                          SizedBox(width: 10),
                                          Text(
                                            isHindi
                                                ? 'RENEW PLATFORM FEES'
                                                : 'प्लेटफ़ॉर्म शुल्क को नवीनीकृत करें',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      );
                                    },
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
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton.instance.languageNotifier,
                                    builder: (context, isHindi, _) {
                                      return Wrap(
                                        children: <Widget>[
                                          Icon(Icons.track_changes,
                                              color: Colors.white, size: 24.0),
                                          SizedBox(width: 10),
                                          Text(
                                            isHindi
                                                ? 'TRACK PREVIOUS HELP'
                                                : 'पिछली सहायता को ट्रैक करें',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          )
                        ],
                      );
                    },
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
// Update Profile Page

class UpdateAdminInformation extends StatefulWidget {
  const UpdateAdminInformation({Key? key}) : super(key: key);

  @override
  State<UpdateAdminInformation> createState() => _UpdateAdminInformationState();
}

class _UpdateAdminInformationState extends State<UpdateAdminInformation> {
  bool isSaving = false;
  bool isImageSelect = false;

  late XFile? pickImage = null;

  int adminId = -1;
  String adminName = '';
  String adminEmail = '';
  String adminPhone = '';
  String adminImg = '';
  String adminGender = '';
  String adminBloodGroup = '';
  String adminCurrentAddress = '';
  String adminHomeAddress = '';
  String adminDistrict = '';
  String adminHomeDistrict = '';
  String adminState = '';
  String adminPost = '';
  String adminPostingDetails = '';
  String adminPostingOffice = '';

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

  Future<void> getAdminDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      adminId = prefs.getInt('adminId') ?? -1;
      adminName = prefs.getString('adminName') ?? '';
      adminEmail = prefs.getString('adminEmail') ?? '';
      adminPhone = prefs.getString('adminPhone') ?? '';
      adminImg = prefs.getString('adminImg') ?? '';
      adminGender = prefs.getString('adminGender') ?? '';
      adminBloodGroup = prefs.getString('adminBloodGroup') ?? '';
      adminCurrentAddress = prefs.getString('adminCurrentAddress') ?? '';
      adminHomeAddress = prefs.getString('adminHomeAddress') ?? '';
      adminDistrict = prefs.getString('adminDistrict') ?? '';
      adminHomeDistrict = prefs.getString('adminHomeDistrict') ?? '';
      adminState = prefs.getString('adminState') ?? '';
      adminPost = prefs.getString('adminPost') ?? '';
      adminPostingDetails = prefs.getString('adminPostingDetails') ?? '';
      adminPostingOffice = prefs.getString('adminPostingOffice') ?? '';

      nameController.text = adminName;
      emailController.text = adminEmail;
      phoneController.text = adminPhone;
      genderController.text = adminGender;
      bloodGroupController.text = adminBloodGroup;
      currentAddressController.text = adminCurrentAddress;
      homeAddressController.text = adminHomeAddress;
      districtController.text = adminDistrict;
      homeDistrictController.text = adminHomeDistrict;
      stateController.text = adminState;
      postController.text = adminPost;
      postingDetailsController.text = adminPostingDetails;
      postingOfficeController.text = adminPostingOffice;
    });
  }

  Future<void> updateUserInformation() async {
    // Your code for updating user information
  }

  Future<void> _handleRefresh() async {
    setState(() {
      getAdminDataFromSharedPreferences();
    });
    return await Future.delayed(const Duration(seconds: 3));
  }

  @override
  void initState() {
    super.initState();
    getAdminDataFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: isSaving
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
                                            width: 2, color: primaryColor),
                                      ),
                                      child: adminImg.isEmpty
                                          ? CircleAvatar(
                                              radius: 70,
                                              backgroundColor: secondaryColor,
                                              child: const Icon(
                                                Icons.person,
                                                size: 120,
                                                color: Colors.white,
                                              ),
                                            )
                                          : adminImg.contains("http")
                                              ? CircleAvatar(
                                                  radius: 70,
                                                  backgroundColor:
                                                      secondaryColor,
                                                  backgroundImage:
                                                      NetworkImage(adminImg),
                                                )
                                              : CircleAvatar(
                                                  radius: 70,
                                                  backgroundColor:
                                                      secondaryColor,
                                                  backgroundImage:
                                                      FileImage(File(adminImg)),
                                                ),
                                    ),
                                    Positioned(
                                      bottom: 5,
                                      right: 5,
                                      child: GestureDetector(
                                        onTap: () async {
                                          isImageSelect = true;
                                          pickImage =
                                              await ImagePicker().pickImage(
                                            source: ImageSource.gallery,
                                            imageQuality: 50,
                                          );

                                          if (pickImage != null) {
                                            setState(() {
                                              adminImg = pickImage!.path;
                                            });
                                          }
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 2, color: Colors.white),
                                            color: primaryColor,
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt_rounded,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: 30.0,
                                      bottom: 8.0,
                                      left: 8.0,
                                      right: 8.0,
                                    ),
                                    child: Text(
                                      'Personal Details',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                // Name
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 10, left: 10, right: 10),
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton.instance.languageNotifier,
                                    builder: (context, isHindi, _) {
                                      return TextFormField(
                                        controller: nameController,
                                        enabled: true,
                                        decoration: InputDecoration(
                                          fillColor:
                                              Colors.white.withOpacity(0.3),
                                          filled: true,
                                          prefixIcon: const Icon(Icons.person),
                                          suffixIcon: const Icon(Icons.edit),
                                          labelText: isHindi ? 'Name' : 'नाम',
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                              style: BorderStyle.solid,
                                              color: primaryColor,
                                              width: 2,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              style: BorderStyle.solid,
                                              color: Color(0xFF909A9E),
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                        style: const TextStyle(fontSize: 16),
                                        textAlign: TextAlign.left,
                                      );
                                    },
                                  ),
                                ),
                                // Phone
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 10,
                                        right: 10),
                                    child: ValueListenableBuilder<bool>(
                                        valueListenable: UserSingleton
                                            .instance.languageNotifier,
                                        builder: (context, isHindi, _) {
                                          return TextFormField(
                                            controller: phoneController,
                                            enabled: true,
                                            decoration: InputDecoration(
                                              fillColor:
                                                  Colors.white.withOpacity(0.3),
                                              filled: true,
                                              prefixIcon:
                                                  const Icon(Icons.phone),
                                              suffixIcon:
                                                  const Icon(Icons.edit),
                                              labelText:
                                                  isHindi ? 'Phone' : 'फ़ोन',
                                              border: InputBorder.none,
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                borderSide: BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: primaryColor,
                                                  width: 2,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                borderSide: const BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: Color(0xFF909A9E),
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                            style:
                                                const TextStyle(fontSize: 16),
                                            textAlign: TextAlign.left,
                                          );
                                        })),

                                // Email TextFormField
                                ValueListenableBuilder<bool>(
                                  valueListenable:
                                      UserSingleton.instance.languageNotifier,
                                  builder: (context, isHindi, _) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 10,
                                        right: 10,
                                      ),
                                      child: TextFormField(
                                        controller: emailController,
                                        enabled: true,
                                        decoration: InputDecoration(
                                          fillColor:
                                              Colors.white.withOpacity(0.3),
                                          filled: true,
                                          prefixIcon: const Icon(Icons.email),
                                          suffixIcon: const Icon(Icons.edit),
                                          labelText: isHindi ? 'Email' : 'ईमेल',
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                              style: BorderStyle.solid,
                                              color: primaryColor,
                                              width: 2,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              style: BorderStyle.solid,
                                              color: Color(0xFF909A9E),
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    );
                                  },
                                ),

                                // Gender
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 10),
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton.instance.languageNotifier,
                                    builder: (context, isHindi, _) {
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
                                          labelText:
                                              isHindi ? 'Gender' : 'लिंग',
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                              style: BorderStyle.solid,
                                              color: primaryColor,
                                              width: 2,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              style: BorderStyle.solid,
                                              color: Color(0xFF909A9E),
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                        style: const TextStyle(fontSize: 16),
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
                                        UserSingleton.instance.languageNotifier,
                                    builder: (context, isHindi, _) {
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
                                              ? 'Blood Group'
                                              : 'रक्त समूह',
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                              style: BorderStyle.solid,
                                              color: primaryColor,
                                              width: 2,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              style: BorderStyle.solid,
                                              color: Color(0xFF909A9E),
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                        style: const TextStyle(fontSize: 16),
                                        textAlign: TextAlign.left,
                                      );
                                    },
                                  ),
                                ),

// Address Details Label
                                // Address Details Label
                                ValueListenableBuilder<bool>(
                                  valueListenable:
                                      UserSingleton.instance.languageNotifier,
                                  builder: (context, isHindi, _) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 30.0,
                                          bottom: 8.0,
                                          left: 8.0,
                                          right: 8.0,
                                        ),
                                        child: Text(
                                          isHindi
                                              ? 'Address Details'
                                              : 'पता का विवरण',
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),

// Home address
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 10),
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton.instance.languageNotifier,
                                    builder: (context, isHindi, _) {
                                      return TextFormField(
                                        controller: homeAddressController,
                                        enabled: true,
                                        decoration: InputDecoration(
                                          fillColor:
                                              Colors.white.withOpacity(0.3),
                                          filled: true,
                                          prefixIcon: const Icon(Icons.home),
                                          suffixIcon: const Icon(Icons.edit),
                                          labelText: isHindi
                                              ? 'Home Address'
                                              : 'घर का पता',
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                              style: BorderStyle.solid,
                                              color: primaryColor,
                                              width: 2,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              style: BorderStyle.solid,
                                              color: Color(0xFF909A9E),
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                        style: const TextStyle(fontSize: 16),
                                        textAlign: TextAlign.left,
                                      );
                                    },
                                  ),
                                ),

// Current address
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 10),
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton.instance.languageNotifier,
                                    builder: (context, isHindi, _) {
                                      return TextFormField(
                                        controller: currentAddressController,
                                        enabled: true,
                                        decoration: InputDecoration(
                                          fillColor:
                                              Colors.white.withOpacity(0.3),
                                          filled: true,
                                          prefixIcon: const Icon(Icons.map),
                                          suffixIcon: const Icon(Icons.edit),
                                          labelText: isHindi
                                              ? 'Current Address'
                                              : 'वर्तमान पता',
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                              style: BorderStyle.solid,
                                              color: primaryColor,
                                              width: 2,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              style: BorderStyle.solid,
                                              color: Color(0xFF909A9E),
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                        style: const TextStyle(fontSize: 16),
                                        textAlign: TextAlign.left,
                                      );
                                    },
                                  ),
                                ),
// Add other TextFormField widgets wrapped with ValueListenableBuilder here

                                // District
                                // District
                                ValueListenableBuilder<bool>(
                                  valueListenable:
                                      UserSingleton.instance.languageNotifier,
                                  builder: (context, isHindi, _) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 10,
                                        right: 10,
                                      ),
                                      child: TextFormField(
                                        controller: districtController,
                                        enabled: true,
                                        decoration: InputDecoration(
                                          fillColor:
                                              Colors.white.withOpacity(0.3),
                                          filled: true,
                                          prefixIcon: const Icon(
                                              Icons.location_history),
                                          suffixIcon: const Icon(Icons.edit),
                                          labelText:
                                              isHindi ? 'District' : 'जिला',
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                              style: BorderStyle.solid,
                                              color: primaryColor,
                                              width: 2,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              style: BorderStyle.solid,
                                              color: Color(0xFF909A9E),
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    );
                                  },
                                ),

// Home District
                                ValueListenableBuilder<bool>(
                                  valueListenable:
                                      UserSingleton.instance.languageNotifier,
                                  builder: (context, isHindi, _) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 10,
                                        right: 10,
                                      ),
                                      child: TextFormField(
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
                                              ? 'Home District'
                                              : 'मुख्य जिला',
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                              style: BorderStyle.solid,
                                              color: primaryColor,
                                              width: 2,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              style: BorderStyle.solid,
                                              color: Color(0xFF909A9E),
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    );
                                  },
                                ),

// State
                                ValueListenableBuilder<bool>(
                                  valueListenable:
                                      UserSingleton.instance.languageNotifier,
                                  builder: (context, isHindi, _) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 10,
                                        right: 10,
                                      ),
                                      child: TextFormField(
                                        controller: stateController,
                                        enabled: true,
                                        decoration: InputDecoration(
                                          fillColor:
                                              Colors.white.withOpacity(0.3),
                                          filled: true,
                                          prefixIcon:
                                              const Icon(Icons.reduce_capacity),
                                          suffixIcon: const Icon(Icons.edit),
                                          labelText:
                                              isHindi ? 'State' : 'राज्य',
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                              style: BorderStyle.solid,
                                              color: primaryColor,
                                              width: 2,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              style: BorderStyle.solid,
                                              color: Color(0xFF909A9E),
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    );
                                  },
                                ),

                                // Update Button
                                ValueListenableBuilder<bool>(
                                  valueListenable:
                                      UserSingleton.instance.languageNotifier,
                                  builder: (context, isHindi, _) {
                                    return Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      child: PrimaryButton(
                                        title: isHindi
                                            ? "UPDATE PROFILE"
                                            : "प्रोफ़ाइल अपडेट करें",
                                        onPressed: () async {
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.question,
                                            animType: AnimType.topSlide,
                                            showCloseIcon: true,
                                            title: isHindi
                                                ? "Confirm Update"
                                                : "अपडेट की पुष्टि करें",
                                            titleTextStyle: TextStyle(
                                              color: Colors.green[900],
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            desc: isHindi
                                                ? "Are you sure you want to update your information?"
                                                : "क्या आप वाकई अपनी जानकारी अपडेट करना चाहते हैं?",
                                            descTextStyle: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            btnOkOnPress: () async {
                                              await updateUserInformation();
                                              Navigator.of(context).pop(false);
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Updating Your Information...");
                                            },
                                            btnOkText: isHindi
                                                ? "Confirm"
                                                : "पुष्टि करें",
                                            btnCancelOnPress: () {
                                              Fluttertoast.showToast(
                                                  msg: "Cancelled update");
                                            },
                                          ).show();
                                        },
                                      ),
                                    );
                                  },
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
