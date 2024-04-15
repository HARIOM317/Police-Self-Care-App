import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mp_police/widget/widget.dart';

class DonationTrackingPage extends StatefulWidget {
  const DonationTrackingPage({Key? key}) : super(key: key);

  @override
  _DonationTrackingPageState createState() => _DonationTrackingPageState();
}

class _DonationTrackingPageState extends State<DonationTrackingPage> {
  late Future<List<Map<String, dynamic>>> _futureDonations;

  @override
  void initState() {
    super.initState();
    _futureDonations = _fetchDonations();
  }

  Future<List<Map<String, dynamic>>> _fetchDonations() async {
    final String api = dotenv.env['GET_DONATION_BY_USER_ID_URL']!;
    final String endPoint = dotenv.env['GET_DONATION_BY_USER_ID_ENDPOINT']!;

    String userId = UserSingleton().getUserId();
    final url = Uri.https(api, endPoint, {'userId': userId});

    try {
      final request = http.Request('OPTIONS', url);
      final streamedResponse = await http.Client().send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final List<dynamic> donations = jsonData['donations'] as List<dynamic>;
        return donations.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load donations');
      }
    } catch (error) {
      throw Exception('Error fetching donations: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureDonations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final donations = snapshot.data ?? [];
            return ListView.builder(
              itemCount: donations.length,
              itemBuilder: (context, index) {
                final donation = donations[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: ListTile(
                      title: Text(
                        donation['title'] ?? 'No title',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            UserSingleton().languageNotifier.value
                                ? 'लाइव: ${donation['live_by_date'] ?? 'N/A'}'
                                : 'Live by: ${donation['live_by_date'] ?? 'N/A'}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          Text(
                            UserSingleton().languageNotifier.value
                                ? 'निर्मित: ${donation['created_on'] ?? 'N/A'}'
                                : 'Created on: ${donation['created_on'] ?? 'N/A'}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          Text(
                            UserSingleton().languageNotifier.value
                                ? 'स्थिति: ${donation['status'] ?? 'N/A'}'
                                : 'Status: ${donation['status'] ?? 'N/A'}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      onTap: () {
                        // Handle onTap event if needed
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
