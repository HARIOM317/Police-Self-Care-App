import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:mp_police/admin/pages/required_widgets/individual_donation_page.dart';
import 'package:mp_police/utils/constants.dart';
import 'package:mp_police/widget/widget.dart';

class ApprovalTab extends StatefulWidget {
  const ApprovalTab({super.key});

  @override
  State<ApprovalTab> createState() => _ApprovalTabState();
}

class _ApprovalTabState extends State<ApprovalTab> {
  List<Map<String, dynamic>> allDonations = [];
  bool isAllDonationsFetched = false;
  TextEditingController reasonController = TextEditingController();

  // To fetch all donations
  Future<void> fetchData() async {
    try {
      final String api = dotenv.env['GET_ALL_DONATIONS_API']!;

      final request = http.Request('OPTIONS', Uri.parse(api))
        ..headers['Content-Type'] = 'application/json';

      final http.StreamedResponse response = await http.Client().send(request);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Request successful");
        }

        final data = jsonDecode(await utf8.decodeStream(response.stream));
        final List<dynamic> donations = data['alldonations'];

        // Filter users based on approved_status
        allDonations = donations
            .where((donation) => donation['approval_status'] == 'pending')
            .map((donation) => donation as Map<String, dynamic>)
            .toList();

        setState(() {
          isAllDonationsFetched = true;
        }); // Update the UI with the filtered users
      } else {
        if (kDebugMode) {
          print('Failed to load data: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  // To approve request
  Future<void> approveDonation(String userId) async {
    try {
      const url = 'https://pscta.tdpvista.co.in/api/v1/donation/updatestatus';
      final body = jsonEncode({'id': userId});
      final request = http.Request('OPTIONS', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = body;

      final http.StreamedResponse response = await http.Client().send(request);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Donation approved successfully!');
        }

        AwesomeDialog(
          // ignore: use_build_context_synchronously
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.topSlide,
          showCloseIcon: true,
          title: "Donation Approved Successfully",
          desc: "The donation request has been approved successfully",
          btnOkText: "OK",
          btnOkOnPress: () {
            // Refresh the user list
            fetchData();
          },
        ).show();
      } else {
        if (kDebugMode) {
          print('Failed to approval donation: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  // To reject request
  Future<void> rejectDonation(String userId) async {
    try {
      const url = 'https://pscta.tdpvista.co.in/api/v1/donation/update';
      final body = jsonEncode({
        'id': userId,
        'approval_status': 'rejected',
        'rejected_reason': reasonController.text.toString()
      });
      final request = http.Request('OPTIONS', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = body;

      final http.StreamedResponse response = await http.Client().send(request);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Donation rejected successfully!');
        }

        // Check if filteredUsers is not empty
        if (allDonations.isNotEmpty) {
          // Find the index of the user with the specified userId
          final rejectedIndex = allDonations.indexWhere(
              (donation) => donation['approval_status'] == 'rejected');
          // If user is found, remove from filteredUsers and add to approvedUsersList
          if (rejectedIndex != -1) {
            setState(() {
              allDonations.removeAt(rejectedIndex);
            });
          }

          AwesomeDialog(
            // ignore: use_build_context_synchronously
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            title: "Donation Rejected Successfully",
            desc: "The donation request has been rejected successfully",
            btnOkText: "OK",
            btnOkOnPress: () {
              // Refresh the user list
              fetchData();
            },
          ).show();
        }
      } else {
        if (kDebugMode) {
          print(
              'Failed to update user approval status: ${response.statusCode}');
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
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return isAllDonationsFetched
        ? allDonations.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "No Any Donation Found!",
                  style: TextStyle(color: Colors.green, fontSize: 20),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemCount: allDonations.length,
                itemBuilder: (context, index) {
                  final donation = allDonations[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: const BorderSide(
                            width: 1, color: Color(0xffe8dfec)),
                      ),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 4.0),
                                child: ValueListenableBuilder<bool>(
                                  valueListenable:
                                      UserSingleton.instance.languageNotifier,
                                  builder: (context, isHindi, _) {
                                    return Text(
                                      isHindi ? "Name" : "नाम",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 4.0),
                                child: Text(
                                    donation['upi_id_holder_name'] ?? "Null",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 4.0),
                                child: ValueListenableBuilder<bool>(
                                  valueListenable:
                                      UserSingleton.instance.languageNotifier,
                                  builder: (context, isHindi, _) {
                                    return Text(
                                      isHindi
                                          ? "Donated Amount"
                                          : "दान की राशि",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 4.0),
                                child: Text(
                                    donation['donated_amount'] ?? "Null",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 4.0),
                                child: ValueListenableBuilder<bool>(
                                  valueListenable:
                                      UserSingleton.instance.languageNotifier,
                                  builder: (context, isHindi, _) {
                                    return Text(
                                      isHindi ? "Date" : "तारीख",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 4.0),
                                child: Text(donation['created_at'] ?? "Null",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Button 1
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 2.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    approveDonation(donation['id'].toString());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.lightGreenAccent.shade700,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton.instance.languageNotifier,
                                    builder: (context, isHindi, _) {
                                      return Text(
                                        isHindi ? "Approve" : "मंजूर",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              // Button 2
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 2.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          title: Center(
                                              child: Text(
                                            'Reason for Rejection',
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontWeight: FontWeight.bold),
                                          )),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              TextField(
                                                maxLines: 3,
                                                controller: reasonController,
                                                decoration: InputDecoration(
                                                  labelText: 'Write Reason',
                                                ),
                                                onChanged: (value) {},
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            // Cancel button
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.orange,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 4),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: ValueListenableBuilder<
                                                    bool>(
                                                  valueListenable: UserSingleton
                                                      .instance
                                                      .languageNotifier,
                                                  builder:
                                                      (context, isHindi, _) {
                                                    return Text(
                                                      isHindi
                                                          ? "Cancel"
                                                          : "रद्द करें",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    );
                                                  },
                                                )),

                                            // Reject button
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 4),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  if (reasonController.text ==
                                                      "") {
                                                    AwesomeDialog(
                                                      // ignore: use_build_context_synchronously
                                                      context: context,
                                                      dialogType:
                                                          DialogType.error,
                                                      animType:
                                                          AnimType.topSlide,
                                                      showCloseIcon: true,
                                                      title:
                                                          "Reason is missing",
                                                      desc:
                                                          "Please write the reason before reject the request!",
                                                      btnOkText: "OK",
                                                      btnOkOnPress: () {
                                                        // Refresh the user list
                                                        fetchData();
                                                      },
                                                    ).show();
                                                  } else {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      rejectDonation(
                                                              donation['id']
                                                                  .toString())
                                                          .then((_) {
                                                        fetchData();
                                                      });
                                                    });
                                                  }
                                                },
                                                child: ValueListenableBuilder<
                                                    bool>(
                                                  valueListenable: UserSingleton
                                                      .instance
                                                      .languageNotifier,
                                                  builder:
                                                      (context, isHindi, _) {
                                                    return Text(
                                                      isHindi
                                                          ? "Reject"
                                                          : "अस्वीकृत",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    );
                                                  },
                                                )),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton.instance.languageNotifier,
                                    builder: (context, isHindi, _) {
                                      return Text(
                                        isHindi ? "Reject" : "अस्वीकृत",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              // Button 3
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 2.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    goTo(
                                        context,
                                        IndividualDonationPage(
                                            id: donation['id']));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton.instance.languageNotifier,
                                    builder: (context, isHindi, _) {
                                      return Text(
                                        isHindi ? "Track" : "ट्रैक",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
        : Center(
            child: Lottie.asset("assets/animations/loading.json",
                animate: true, width: 250),
          );
  }
}
