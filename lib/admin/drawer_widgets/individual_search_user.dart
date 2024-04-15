import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';
import 'package:mp_police/components/primary_button.dart';
import 'package:mp_police/utils/constants.dart';
import 'package:http/http.dart' as http;

class IndividualSearchUser extends StatefulWidget {
  final List<dynamic> searchResults;
  final int index;
  final int id;
  final String imgUrl;
  final String name;
  final String email;
  final String banTime;
  IndividualSearchUser(
      {super.key,
        required this.searchResults,
      required this.index,
      required this.id,
      required this.imgUrl,
      required this.name,
      required this.email,
      required this.banTime});

  @override
  State<IndividualSearchUser> createState() => _IndividualSearchUserState();
}

class _IndividualSearchUserState extends State<IndividualSearchUser> {
  String? selectedDays;

  // function to add dropdown list to ban user
  Widget builtBanDropdownList(
      {required String? selectedTime,
      required Function(String? banTime) callbackFunction}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(width: 1.5, color: Colors.grey),
            boxShadow: const <BoxShadow>[
              BoxShadow(color: Color(0xffafafaf), blurRadius: 1)
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          child: Center(
            child: DropdownButton<String>(
                borderRadius: BorderRadius.circular(30),
                isExpanded: true,
                hint: const Text("Choose Time"),
                value: selectedTime,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  size: 35,
                ),
                dropdownColor: Colors.white,
                underline: Container(), //empty line
                style: TextStyle(fontSize: 18, color: primaryColor),
                iconEnabledColor: primaryColor,
                items: const [
                  DropdownMenuItem<String>(
                      value: "1 day", child: Text("1 day")),
                  DropdownMenuItem<String>(
                      value: "3 days", child: Text("3 days")),
                  DropdownMenuItem<String>(
                      value: "15 days", child: Text("15 days")),
                  DropdownMenuItem<String>(
                      value: "30 days", child: Text("30 days")),
                  DropdownMenuItem<String>(
                      value: "Always", child: Text("Always")),
                ],
                onChanged: callbackFunction),
          ),
        ),
      ),
    );
  }

  // To ban user
  Future<void> banUser(String userId, String time) async {
    try {
      final String url = dotenv.env['BAN_UPDATE_OVER_A_USER_API']!;

      final body = jsonEncode({'id': userId, 'ban': time});
      final request = http.Request('OPTIONS', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = body;

      final http.StreamedResponse response = await http.Client().send(request);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(
              'User with id = ${widget.id} has Baned successfully for $selectedDays!');
        }

        AwesomeDialog(
          // ignore: use_build_context_synchronously
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.topSlide,
          showCloseIcon: true,
          title: "User Baned Successfully",
          desc:
              "The user with id ${widget.id} has been baned successfully for $selectedDays",
          btnOkText: "OK",
          btnOkOnPress: () {
            Navigator.pop(context);
          },
        ).show();
      } else {
        if (kDebugMode) {
          print('Failed to ban user: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Individual User",
          style: TextStyle(
              color: primaryColor, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: widget.banTime == "None" || widget.banTime == ""
          ? Center(
              child: CustomScrollView(
                scrollDirection: Axis.vertical,
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // First Column
                        Column(
                          children: [
                            // profile
                            Container(
                                margin: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 2, color: primaryColor)),
                                child: widget.imgUrl == ""
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
                                            NetworkImage(widget.imgUrl),
                                      )),

                            const SizedBox(
                              height: 30,
                            ),

                            // Name
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: Text(
                                widget.name,
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
                                widget.email,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black54),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        // Second Column
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: builtBanDropdownList(
                                  selectedTime: selectedDays,
                                  callbackFunction: (String? newTime) {
                                    setState(() {
                                      selectedDays = newTime!;
                                    });
                                  }),
                            ),
                            PrimaryButton(
                                title: "Ban",
                                onPressed: () {
                                  if (selectedDays == null) {
                                    AwesomeDialog(
                                      // ignore: use_build_context_synchronously
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.topSlide,
                                      showCloseIcon: true,
                                      title: "Time not selected",
                                      desc:
                                          "Please select the time to ban user!",
                                      btnOkText: "OK",
                                      btnOkOnPress: () {},
                                    ).show();
                                  } else {
                                    banUser(
                                        widget.id.toString(), selectedDays!);
                                  }
                                }),
                            PrimaryButton(
                                title: "Show All Details",
                                onPressed: () {
                                  goTo(context, ShowAllMemberDetails(searchResults: widget.searchResults, index: widget.index,));
                                }),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Lottie.asset("assets/animations/blocked_user.json",
                        animate: true, width: 225),
                  ),
                ),
                Text(
                  "This user has been banned for ${widget.banTime}",
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                )
              ],
            ),
    );
  }
}


// class to show all details of searched member
class ShowAllMemberDetails extends StatefulWidget {
  final List<dynamic> searchResults;
  final int index;

  ShowAllMemberDetails({super.key, required this.searchResults, required this.index});

  @override
  State<ShowAllMemberDetails> createState() => _ShowAllMemberDetailsState();
}

class _ShowAllMemberDetailsState extends State<ShowAllMemberDetails> {
  var idController = TextEditingController();
  var roleController = TextEditingController();
  var nameController = TextEditingController();
  var imgController = TextEditingController();
  var mobileController = TextEditingController();
  var emailController = TextEditingController();
  var currentAddressController = TextEditingController();
  var cugMobileController = TextEditingController();
  var genderController = TextEditingController();
  var bloodGroupController = TextEditingController();
  var batchIDController = TextEditingController();
  var postController = TextEditingController();
  var postingDetailsController = TextEditingController();
  var postingOfficeController = TextEditingController();
  var districtController = TextEditingController();
  var stateController = TextEditingController();
  var homeAddressController = TextEditingController();
  var homeDistrictController = TextEditingController();
  var isDiseaseController = TextEditingController();
  var approvedStatusController = TextEditingController();
  var profileCompletedController = TextEditingController();
  var banController = TextEditingController();
  var renewFeePayedDateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    setState(() {
      idController.text = widget.searchResults[widget.index]['id'].toString();
      roleController.text = widget.searchResults[widget.index]['role'].toString();
      nameController.text = widget.searchResults[widget.index]['name'].toString();
      imgController.text = widget.searchResults[widget.index]['img_url'].toString();
      mobileController.text = widget.searchResults[widget.index]['mobile'].toString();
      emailController.text = widget.searchResults[widget.index]['email'].toString();
      currentAddressController.text = widget.searchResults[widget.index]['current_address'].toString();
      cugMobileController.text = widget.searchResults[widget.index]['cug_mobile'].toString();
      genderController.text = widget.searchResults[widget.index]['gender'].toString();
      bloodGroupController.text = widget.searchResults[widget.index]['blood_group'].toString();
      batchIDController.text = widget.searchResults[widget.index]['batch_id'].toString();
      postController.text = widget.searchResults[widget.index]['post'].toString();
      postingDetailsController.text = widget.searchResults[widget.index]['posting_details'].toString();
      postingOfficeController.text = widget.searchResults[widget.index]['posting_office'].toString();
      districtController.text = widget.searchResults[widget.index]['district'].toString();
      stateController.text = widget.searchResults[widget.index]['state'].toString();
      homeAddressController.text = widget.searchResults[widget.index]['home_address'].toString();
      homeDistrictController.text = widget.searchResults[widget.index]['home_district'].toString();
      isDiseaseController.text = widget.searchResults[widget.index]['is_disease'].toString();
      approvedStatusController.text = widget.searchResults[widget.index]['approved_status'].toString();
      profileCompletedController.text = widget.searchResults[widget.index]['profile_completed'].toString();
      banController.text = widget.searchResults[widget.index]['Ban'].toString();
      renewFeePayedDateController.text = widget.searchResults[widget.index]['renew_fee_payed_date'].toString();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "User Details",
          style: TextStyle(
              color: primaryColor, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: ListView(
          children: [
            // Id
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 10, left: 10, right: 10),
              child: TextFormField(
                controller: idController,
                enabled: true,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor:
                  Colors.white.withOpacity(0.3),
                  filled: true,
                  labelText: 'ID',
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(30),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xFF909A9E),
                      width: 1.5,
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
              ),
            ),

            // Role
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 10, left: 10, right: 10),
              child: TextFormField(
                controller: roleController,
                enabled: true,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor:
                  Colors.white.withOpacity(0.3),
                  filled: true,
                  labelText: 'Role',
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(30),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xFF909A9E),
                      width: 1.5,
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
              ),
            ),

            // Name
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 10, left: 10, right: 10),
              child: TextFormField(
                controller: nameController,
                enabled: true,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor:
                  Colors.white.withOpacity(0.3),
                  filled: true,
                  labelText: 'Name',
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(30),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xFF909A9E),
                      width: 1.5,
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
              ),
            ),

            // Mobile
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 10, left: 10, right: 10),
              child: TextFormField(
                controller: mobileController,
                enabled: true,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor:
                  Colors.white.withOpacity(0.3),
                  filled: true,
                  labelText: 'Mobile',
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(30),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xFF909A9E),
                      width: 1.5,
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
              ),
            ),

            // Email
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 10, left: 10, right: 10),
              child: TextFormField(
                controller: emailController,
                enabled: true,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor:
                  Colors.white.withOpacity(0.3),
                  filled: true,
                  labelText: 'Email',
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(30),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xFF909A9E),
                      width: 1.5,
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
              ),
            ),

            // Current Address
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 10, left: 10, right: 10),
              child: TextFormField(
                controller: currentAddressController,
                enabled: true,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor:
                  Colors.white.withOpacity(0.3),
                  filled: true,
                  labelText: 'Current Address',
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(30),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xFF909A9E),
                      width: 1.5,
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
              ),
            ),

            // Cug Mobile
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 10, left: 10, right: 10),
              child: TextFormField(
                controller: cugMobileController,
                enabled: true,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor:
                  Colors.white.withOpacity(0.3),
                  filled: true,
                  labelText: 'Cug Mobile',
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(30),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xFF909A9E),
                      width: 1.5,
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
              ),
            ),

            // Gender
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 10, left: 10, right: 10),
              child: TextFormField(
                controller: genderController,
                enabled: true,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor:
                  Colors.white.withOpacity(0.3),
                  filled: true,
                  labelText: 'Gender',
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(30),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xFF909A9E),
                      width: 1.5,
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
              ),
            ),

            // Blood Group
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 10, left: 10, right: 10),
              child: TextFormField(
                controller: bloodGroupController,
                enabled: true,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor:
                  Colors.white.withOpacity(0.3),
                  filled: true,
                  labelText: 'Blood Group',
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(30),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xFF909A9E),
                      width: 1.5,
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
              ),
            ),

            // Batch ID
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 10, left: 10, right: 10),
              child: TextFormField(
                controller: batchIDController,
                enabled: true,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor:
                  Colors.white.withOpacity(0.3),
                  filled: true,
                  labelText: 'Batch ID',
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(30),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xFF909A9E),
                      width: 1.5,
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
              ),
            ),

            // Post
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 10, left: 10, right: 10),
              child: TextFormField(
                controller: postController,
                enabled: true,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor:
                  Colors.white.withOpacity(0.3),
                  filled: true,
                  labelText: 'Post',
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(30),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xFF909A9E),
                      width: 1.5,
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
              ),
            ),

            // Posting Details
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 10, left: 10, right: 10),
              child: TextFormField(
                controller: postingDetailsController,
                enabled: true,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor:
                  Colors.white.withOpacity(0.3),
                  filled: true,
                  labelText: 'Posting Details',
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(30),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xFF909A9E),
                      width: 1.5,
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
              ),
            ),

            // Posting Office
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 10, left: 10, right: 10),
              child: TextFormField(
                controller: postingOfficeController,
                enabled: true,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor:
                  Colors.white.withOpacity(0.3),
                  filled: true,
                  labelText: 'Posting Office',
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(30),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xFF909A9E),
                      width: 1.5,
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
              ),
            ),

            // District
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 10, left: 10, right: 10),
              child: TextFormField(
                controller: districtController,
                enabled: true,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor:
                  Colors.white.withOpacity(0.3),
                  filled: true,
                  labelText: 'District',
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(30),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xFF909A9E),
                      width: 1.5,
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
              ),
            ),

            // State
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 10, left: 10, right: 10),
              child: TextFormField(
                controller: stateController,
                enabled: true,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor:
                  Colors.white.withOpacity(0.3),
                  filled: true,
                  labelText: 'State',
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(30),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xFF909A9E),
                      width: 1.5,
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
              ),
            ),

            // Home Address
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 10, left: 10, right: 10),
              child: TextFormField(
                controller: homeAddressController,
                enabled: true,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor:
                  Colors.white.withOpacity(0.3),
                  filled: true,
                  labelText: 'Home Address',
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(30),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xFF909A9E),
                      width: 1.5,
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
              ),
            ),

            // Home District
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 10, left: 10, right: 10),
              child: TextFormField(
                controller: homeDistrictController,
                enabled: true,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor:
                  Colors.white.withOpacity(0.3),
                  filled: true,
                  labelText: 'Home District',
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(30),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xFF909A9E),
                      width: 1.5,
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
              ),
            ),

            // Is Disease
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 10, left: 10, right: 10),
              child: TextFormField(
                controller: isDiseaseController,
                enabled: true,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor:
                  Colors.white.withOpacity(0.3),
                  filled: true,
                  labelText: 'Is Disease',
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(30),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xFF909A9E),
                      width: 1.5,
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
              ),
            ),

            // Approval Status
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 10, left: 10, right: 10),
              child: TextFormField(
                controller: approvedStatusController,
                enabled: true,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor:
                  Colors.white.withOpacity(0.3),
                  filled: true,
                  labelText: 'Approval Status',
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(30),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xFF909A9E),
                      width: 1.5,
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
              ),
            ),

            // Profile Completed
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 10, left: 10, right: 10),
              child: TextFormField(
                controller: profileCompletedController,
                enabled: true,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor:
                  Colors.white.withOpacity(0.3),
                  filled: true,
                  labelText: 'Profile Completed',
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(30),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xFF909A9E),
                      width: 1.5,
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
              ),
            ),

            // Ban
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 10, left: 10, right: 10),
              child: TextFormField(
                controller: banController,
                enabled: true,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor:
                  Colors.white.withOpacity(0.3),
                  filled: true,
                  labelText: 'Ban',
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(30),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xFF909A9E),
                      width: 1.5,
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
              ),
            ),

            // Renew fee payed date
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 10, left: 10, right: 10),
              child: TextFormField(
                controller: renewFeePayedDateController,
                enabled: true,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor:
                  Colors.white.withOpacity(0.3),
                  filled: true,
                  labelText: 'Renew Fees Date',
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(30),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: Color(0xFF909A9E),
                      width: 1.5,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

