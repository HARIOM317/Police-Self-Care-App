import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:mp_police/admin/pages/required_widgets/individual_donation_page.dart';
import 'package:mp_police/utils/constants.dart';
import 'package:mp_police/widget/widget.dart';

class EndedTab extends StatefulWidget {
  const EndedTab({super.key});

  @override
  State<EndedTab> createState() => _EndedTabState();
}

class _EndedTabState extends State<EndedTab> {
  List<Map<String, dynamic>> allDonations = [];
  bool isAllDonationsFetched = false;

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
            .where((donation) => donation['approval_status'] == 'ended')
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // View Details Button
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 12.0),
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
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                    child: ValueListenableBuilder<bool>(
                                      valueListenable: UserSingleton
                                          .instance.languageNotifier,
                                      builder: (context, isHindi, _) {
                                        return Text(
                                          isHindi
                                              ? "View Details"
                                              : "विवरण देखें",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        );
                                      },
                                    )),
                              ),
                            ],
                          )
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
