import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'dart:convert';

import 'package:mp_police/utils/constants.dart';

class EditFAQs extends StatefulWidget {
  const EditFAQs({super.key});

  @override
  State<EditFAQs> createState() => _EditFAQsState();
}

class _EditFAQsState extends State<EditFAQs> {
  List<EditFAQItem> faqs = [];

  @override
  void initState() {
    super.initState();
    fetchFAQs();
  }

  // To get all FAQ
  Future<void> fetchFAQs() async {
    try {
      final String url = dotenv.env['GET_ALL_FAQ_API']!;

      final request = http.Request(
          'OPTIONS', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json';

      final http.StreamedResponse response = await http.Client().send(request);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Request successful");
        }

        final data = jsonDecode(await utf8.decodeStream(response.stream));
        final List<dynamic> allFAQs = data['allFaqs'];

        setState(() {
          faqs = allFAQs.map((item) => EditFAQItem.fromJson(item)).toList();
        });

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

  // To add new FAQ
  void addNewFAQ() async {
    String question = '';
    String answer = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(child: Text('Add New FAQ', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Question',
                ),
                onChanged: (value) {
                  question = value;
                },
              ),
              TextField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Answer',
                ),
                onChanged: (value) {
                  answer = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            // Cancel button
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:
                  const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(6.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),

            // Add button
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                  const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(6.0),
                  ),
                ),
                onPressed: () async {
                  if(question == '' && answer == '') {
                    Fluttertoast.showToast(msg: "Empty Question and Answer Field!");
                  } else {
                    final String url = dotenv.env['CREATE_FAQ_API']!;

                    final body = jsonEncode({'question': question, 'answer': answer});

                    final request = http.Request('OPTIONS', Uri.parse(url))
                      ..headers['Content-Type'] = 'application/json'
                      ..body = body;

                    final http.StreamedResponse response = await http.Client().send(request);

                    if (response.statusCode == 200) {
                      setState(() {
                        faqs.add(EditFAQItem(question: question, answer: answer, id: ''));
                      });
                      if (kDebugMode) {
                        print('FAQ added successfully!');
                      }
                    } else {
                      if (kDebugMode) {
                        print('Failed to add FAQ : ${response.statusCode}');
                      }
                    }

                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  "Add",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
          ],
        );
      },
    );
  }

  // To update FAQ
  Future<void> updateFAQ(EditFAQItem faq, String id) async {
    try {
      final index = faqs.indexOf(faq);
      final String url = dotenv.env['UPDATE_FAQ_API']!;

      final body = jsonEncode({
        'id': id,
        'question': faq.question,
        'answer': faq.answer,
      });
      final request = http.Request('OPTIONS', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = body;

      final http.StreamedResponse response = await http.Client().send(request);
      final http.Response streamedResponse = await http.Response.fromStream(response);

      if (streamedResponse.statusCode == 200) {
        if (kDebugMode) {
          print('FAQ has updated successfully!');
        }
        setState(() {
          faqs[index] = faq;
        });
      } else {
        if (kDebugMode) {
          print('Failed to update FAQ : ${streamedResponse.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  // To create FAQ Widget
  Widget buildFAQItem(EditFAQItem faq) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            initialValue: faq.question,
            decoration: const InputDecoration(
              labelText: 'Question',
            ),
            onChanged: (value) {
              faq.question = value;
            },
          ),
          TextFormField(
            initialValue: faq.answer,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Answer',
            ),
            onChanged: (value) {
              faq.answer = value;
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                padding:
                const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () => updateFAQ(faq, faq.id),
              child: const Text(
                "Update",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // To refresh FAQs page
  Future<void> _handleRefresh() async {
    setState(() {
      fetchFAQs();
    });
    return await Future.delayed(const Duration(seconds: 3));
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
          "Edit FAQs",
          style: TextStyle(
              color: primaryColor, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: addNewFAQ,
          ),
        ],
      ),
      body: SafeArea(
        child: LiquidPullToRefresh(
          onRefresh: _handleRefresh,
          color: Colors.transparent,
          backgroundColor: primaryColor,
          height: 300,
          animSpeedFactor: 3,
          showChildOpacityTransition: true,
          child: ListView(
            children: [
              for (var faq in faqs) buildFAQItem(faq),
            ],
          ),
        ),
      ),
    );
  }
}

class EditFAQItem {
  String question;
  String answer;
  String id;

  EditFAQItem({required this.question, required this.answer, required this.id});

  factory EditFAQItem.fromJson(Map<String, dynamic> json) {
    return EditFAQItem(
      id: json['id'].toString(),
      question: json['question'],
      answer: json['answer'],
    );
  }
}

