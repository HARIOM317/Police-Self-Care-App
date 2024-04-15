import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class ThirdTab extends StatefulWidget {
  const ThirdTab({super.key});

  @override
  State<ThirdTab> createState() => _ThirdTabState();
}

class _ThirdTabState extends State<ThirdTab> {
  List<Map<String, dynamic>> allDonations = [];
  bool isAllDonationsFetched = false;

  // To fetch all donations
  Future<void> fetchData() async {
    try {
      final String url = dotenv.env['GET_ALL_DONATIONS_API']!;

      final request = http.Request('OPTIONS', Uri.parse(url))
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
                    parent: AlwaysScrollableScrollPhysics()),
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
                                width: 1, color: Color(0xffe8dfec))),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 4.0),
                                  child: Text(
                                    "Name",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 4.0),
                                  child: Text(
                                      donation['upi_id_holder_name'] ?? "Null",
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 4.0),
                                  child: Text(
                                    "Donated Amount",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 4.0),
                                  child: Text(
                                      donation['donated_amount'] ?? "Null",
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 4.0),
                                  child: Text(
                                    "Date",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 4.0),
                                  child: Text(donation['created_at'] ?? "Null",
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                ),
                              ],
                            ),
                          ],
                        )),
                  );
                },
              )
        : Center(
            child: Lottie.asset("assets/animations/loading.json",
                animate: true, width: 250),
          );
  }
}
