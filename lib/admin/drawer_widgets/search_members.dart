import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:mp_police/admin/drawer_widgets/individual_search_user.dart';
import 'dart:convert';

import 'package:mp_police/utils/constants.dart';

class SearchUsersPage extends StatefulWidget {
  const SearchUsersPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchUsersPageState createState() => _SearchUsersPageState();
}

class _SearchUsersPageState extends State<SearchUsersPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  final bool _isLoading = false;

  Future<void> _searchUsers(String query) async {
    final String api = dotenv.env['SEARCH_MEMBERS_API']!;

    String url = '$api?q=$query';

    try {
      // Create an OPTIONS request object
      final request = http.Request('OPTIONS', Uri.parse(url));
      request.headers.addAll({'Content-Type': 'application/json'});

      // Send the request and handle the response
      final streamedResponse = await http.Client().send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Handle successful response (e.g., parse JSON data, update UI)
        final data = jsonDecode(response.body);
        setState(() {
          _searchResults = data;
        });
      } else {
        if (kDebugMode) {
          print(
              'Failed searchMembers request: ${response.statusCode} - ${response.reasonPhrase}');
        }
        // Handle unsuccessful request (e.g., display error message)
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error making searchMembers request: $error');
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
          "Search Users",
          style: TextStyle(
              color: primaryColor, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _searchUsers(_searchController.text);
                  },
                ),
              ),
            ),
          ),
          _isLoading
              ? const CircularProgressIndicator()
              : Expanded(
                  child: _searchController.text.isEmpty
                      ? ListView(
                          children: [
                            const SizedBox(
                              height: 100,
                            ),
                            Center(
                              child: Lottie.asset(
                                  "assets/animations/search_user.json",
                                  animate: true,
                                  width: double.infinity),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 24.0),
                              child: Center(
                                child: Text(
                                  "Search User",
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        )
                      : _searchResults.isEmpty
                          ? ListView(
                              children: [
                                const SizedBox(
                                  height: 100,
                                ),
                                Center(
                                  child: Lottie.asset(
                                      "assets/animations/no_user_found.json",
                                      animate: true,
                                      width: double.infinity),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 24.0),
                                  child: Center(
                                    child: Text(
                                      "No User Found!",
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    goTo(
                                        context,
                                        IndividualSearchUser(
                                          searchResults: _searchResults,
                                            index: index,
                                            id: _searchResults[index]['id'],
                                            imgUrl: _searchResults[index]
                                                ['img_url'],
                                            name: _searchResults[index]['name'],
                                            email: _searchResults[index]
                                                ['email'],
                                            banTime: _searchResults[index]
                                                ['Ban']));
                                  },
                                  child: ListTile(
                                    leading:
                                        _searchResults[index]['img_url'] == null
                                            ? CircleAvatar(
                                                backgroundColor: secondaryColor,
                                                child: const Icon(
                                                  CupertinoIcons.person_fill,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    _searchResults[index]
                                                        ['img_url']),
                                              ),
                                    title: Text(_searchResults[index]['name'] ??
                                        "Name not available"),
                                    subtitle: Text(_searchResults[index]
                                            ['email'] ??
                                        "Email not available"),
                                  ),
                                );
                              },
                            ),
                ),
        ],
      ),
    );
  }
}
