import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mp_police/utils/constants.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  List<Map<String, dynamic>> filteredUsers = [];
  List<Map<String, dynamic>> approvedUsersList = [];
  bool isApprovedRequestFetched = false;
  bool isApprovedDataFetched = false;

  // To fetch approval request
  Future<void> fetchData() async {
    try {
      final String url = dotenv.env['GET_ALL_USERS_API']!;

      final request = http.Request(
          'OPTIONS', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json';

      final http.StreamedResponse response = await http.Client().send(request);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Request successful");
        }

        final data = jsonDecode(await utf8.decodeStream(response.stream));
        final List<dynamic> users = data['user'];

        // Filter users based on approved_status
        filteredUsers = users
            .where((user) => user['approved_status'] == '0')
            .map((user) => user as Map<String, dynamic>)
            .toList();

        setState(() {
          isApprovedRequestFetched = true;
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
  Future<void> updateUserApproval(String userId) async {
    try {
      final String url = dotenv.env['UPDATE_USER_API']!;
      final body = jsonEncode({'id': userId, 'approved_status': '1'});
      final request = http.Request('OPTIONS', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = body;

      final http.StreamedResponse response = await http.Client().send(request);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('User approval status updated to approved');
        }

        // Check if filteredUsers is not empty
        if (filteredUsers.isNotEmpty) {
          // Find the index of the user with the specified userId
          final userIndex =
              filteredUsers.indexWhere((user) => user['id'] == userId);
          // If user is found, remove from filteredUsers and add to approvedUsersList
          if (userIndex != -1) {
            setState(() {
              final removedUser = filteredUsers.removeAt(userIndex);
              approvedUsersList.add(removedUser);
            });
          }
        }

        // Refresh the user list
        fetchData();
        approvedUsers();
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

  // To reject request
  Future<void> rejectUserApproval(String userId) async {
    try {
      final String url = dotenv.env['UPDATE_USER_API']!;
      final body = jsonEncode({'id': userId, 'approved_status': '2'});
      final request = http.Request('OPTIONS', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = body;

      final http.StreamedResponse response = await http.Client().send(request);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('User approval status updated to reject');
        }
        // Check if filteredUsers is not empty
        if (filteredUsers.isNotEmpty) {
          // Find the index of the user with the specified userId
          final userIndex =
              filteredUsers.indexWhere((user) => user['id'] == userId);
          // If user is found, remove from filteredUsers and add to approvedUsersList
          if (userIndex != -1) {
            setState(() {
              filteredUsers.removeAt(userIndex);
            });
          }
        }
        // Refresh the user list
        fetchData();
        approvedUsers();
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

  // To fetch approved users
  Future<void> approvedUsers() async {
    try {
      final String url = dotenv.env['GET_ALL_USERS_API']!;
      final request = http.Request(
          'OPTIONS', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json';

      final http.StreamedResponse response = await http.Client().send(request);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Request successful");
        }

        final data = jsonDecode(await utf8.decodeStream(response.stream));
        final List<dynamic> users = data['user'];

        // Filter users based on approved_status
        approvedUsersList = users
            .where((user) => user['approved_status'] == '1')
            .map((user) => user as Map<String, dynamic>)
            .toList();

        setState(() {
          isApprovedDataFetched = true;
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
    approvedUsers();
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
          "Account",
          style: TextStyle(
              color: primaryColor, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: <Widget>[
            const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "Approval Required",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                  ),
                )),
            isApprovedRequestFetched
                ? filteredUsers.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "No Approval Request Found 😊",
                          style: TextStyle(color: Colors.green, fontSize: 20),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              user['img_url'] == null
                                  ? CircleAvatar(
                                  backgroundColor:
                                  Theme.of(context).primaryColor,
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ))
                                  : CircleAvatar(
                                backgroundImage:
                                NetworkImage(user['img_url']),
                              ),

                              Card(
                                elevation: 1,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: BorderSide(
                                        width: 0.5, color: Colors.blueGrey.shade200
                                    )
                                ),
                                child: SizedBox(
                                  width: 260,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        // Row for name
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                  user['name'] ?? "Name",
                                                  style: const TextStyle(
                                                      color: Colors.black54,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14)),
                                            ),
                                          ],
                                        ),

                                        // Row for mobile
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4.0, horizontal: 4.0),
                                              child: Text(
                                                "Mobile",
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
                                                  user['mobile'] ?? "Mobile",
                                                  style: const TextStyle(
                                                      color: Colors.black54,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14)),
                                            ),
                                          ],
                                        ),

                                        // Row for post
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4.0, horizontal: 4.0),
                                              child: Text(
                                                "Post",
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
                                                  user['post'] ?? "Post",
                                                  style: const TextStyle(
                                                      color: Colors.black54,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14)),
                                            ),
                                          ],
                                        ),

                                        // Row for batch id
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4.0, horizontal: 4.0),
                                              child: Text(
                                                "Batch ID",
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
                                                  user['batch_id'] ?? "Batch ID",
                                                  style: const TextStyle(
                                                      color: Colors.black54,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14)),
                                            ),
                                          ],
                                        ),

                                        // Row for buttons
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 4),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(8.0),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    updateUserApproval(
                                                        user['id'].toString());
                                                  });
                                                },
                                                child: const Text(
                                                  "Approve",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold),
                                                )),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 22,
                                                      vertical: 4),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(8.0),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    rejectUserApproval(
                                                        user['id'].toString());
                                                  });
                                                },
                                                child: const Text(
                                                  "Reject",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold),
                                                ))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ]
                          );
                        }
                      )
                : Center(
                    child: Lottie.asset("assets/animations/loading.json",
                        animate: true, width: 250),
                  ),
            const SizedBox(
              height: 30,
            ),
            const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "Approved",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                )),
            isApprovedDataFetched == true
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: approvedUsersList.length,
                    itemBuilder: (context, index) {
                      final user = approvedUsersList[index];
                      return ListTile(
                        leading: user['img_url'] == null
                            ? CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ))
                            : CircleAvatar(
                                backgroundImage: NetworkImage(user['img_url']),
                              ),
                        title: Card(
                            elevation: 1,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(
                                    width: 0.5, color: Colors.blueGrey.shade200
                                )
                            ),
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 12.0),
                          child: Column(
                            children: [
                              // Row for name
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
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
                                        user['name'] ?? "Name",
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14)),
                                  ),
                                ],
                              ),

                              // Row for role
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 4.0),
                                    child: Text(
                                      "Role",
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
                                        user['role'] ?? "Role",
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                        trailing: const Icon(Icons.more_vert),
                      );
                    },
                  )
                : Center(
                    child: Lottie.asset("assets/animations/loading.json",
                        animate: true, width: 250),
                  ),
          ],
        ),
      ),
    );
  }
}
