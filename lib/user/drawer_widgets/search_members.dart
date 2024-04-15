import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'dart:convert';

import 'package:mp_police/utils/constants.dart';
import 'package:mp_police/widget/widget.dart';

class SearchUsersPage extends StatefulWidget {
  const SearchUsersPage({Key? key}) : super(key: key);

  @override
  _SearchUsersPageState createState() => _SearchUsersPageState();
}

class _SearchUsersPageState extends State<SearchUsersPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  Future<void> _searchUsers(String query) async {
    setState(() {
      _isLoading = true;
    });

    final String api = dotenv.env['SEARCH_MEMBERS_API']!;

    String url = '$api?q=$query';

    try {
      final request = http.Request('OPTIONS', Uri.parse(url));
      request.headers.addAll({'Content-Type': 'application/json'});

      final streamedResponse = await http.Client().send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _searchResults = data;
          _isLoading = false;
        });
      } else {
        if (kDebugMode) {
          print(
              'Failed searchMembers request: ${response.statusCode} - ${response.reasonPhrase}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error making searchMembers request: $error');
      }
    }
  }

  void _viewContributions(int userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserContributionsScreen(userId: userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: UserSingleton().languageNotifier,
            builder: (context, isHindi, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: isHindi ? 'खोजें' : 'Search',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        _searchUsers(_searchController.text);
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          _isLoading
              ? const CircularProgressIndicator()
              : Expanded(
                  child: _searchResults.isEmpty
                      ? ListView(
                          children: [
                            const SizedBox(
                              height: 100,
                            ),
                            Center(
                              child: Lottie.asset(
                                "assets/animations/no_user_found.json",
                                animate: true,
                                width: double.infinity,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 24.0),
                              child: Center(
                                child: ValueListenableBuilder<bool>(
                                  valueListenable:
                                      UserSingleton().languageNotifier,
                                  builder: (context, isHindi, child) {
                                    return Text(
                                      isHindi
                                          ? "कोई उपयोगकर्ता नहीं मिला!"
                                          : "No User Found!",
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                _viewContributions(_searchResults[index]['id']);
                              },
                              leading: _searchResults[index]['img_url'] == null
                                  ? CircleAvatar(
                                      backgroundColor: secondaryColor,
                                      child: const Icon(
                                        CupertinoIcons.person_fill,
                                        color: Colors.white,
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          _searchResults[index]['img_url']),
                                    ),
                              title: Text(_searchResults[index]['name'] ??
                                  ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton().languageNotifier,
                                    builder: (context, isHindi, child) {
                                      return Text(isHindi
                                          ? "नाम उपलब्ध नहीं है"
                                          : "Name not available");
                                    },
                                  )),
                              subtitle: Text(_searchResults[index]['email'] ??
                                  ValueListenableBuilder<bool>(
                                    valueListenable:
                                        UserSingleton().languageNotifier,
                                    builder: (context, isHindi, child) {
                                      return Text(isHindi
                                          ? "ईमेल उपलब्ध नहीं है"
                                          : "Email not available");
                                    },
                                  )),
                            );
                          },
                        ),
                ),
        ],
      ),
    );
  }
}

class UserContributionsScreen extends StatelessWidget {
  final int userId;

  UserContributionsScreen({Key? key, required this.userId}) : super(key: key);

  // Sample data for demonstration
  final List<Map<String, dynamic>> contributions = [
    {'date': '2022-03-13', 'amount': '100'},
    {'date': '2022-03-14', 'amount': '150'},
    {'date': '2022-03-15', 'amount': '200'},
    {'date': '2022-03-16', 'amount': '120'},
    {'date': '2022-03-17', 'amount': '180'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<bool>(
          valueListenable: UserSingleton().languageNotifier,
          builder: (context, isHindi, child) {
            return Text(isHindi ? 'योगदान' : 'Contributions');
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: UserSingleton().languageNotifier,
              builder: (context, isHindi, child) {
                return Text(
                  isHindi ? 'योगदान:' : 'Contributions:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: contributions.length,
                itemBuilder: (context, index) {
                  final contribution = contributions[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(Icons.monetization_on),
                      title: ValueListenableBuilder<bool>(
                        valueListenable: UserSingleton().languageNotifier,
                        builder: (context, isHindi, child) {
                          return Text(isHindi
                              ? 'तारीख: ${contribution['date']}'
                              : 'Date: ${contribution['date']}');
                        },
                      ),
                      subtitle: ValueListenableBuilder<bool>(
                        valueListenable: UserSingleton().languageNotifier,
                        builder: (context, isHindi, child) {
                          return Text(isHindi
                              ? 'राशि: \$${contribution['amount']}'
                              : 'Amount: \$${contribution['amount']}');
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
