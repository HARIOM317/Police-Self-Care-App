import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_faq/flutter_faq.dart';
import 'package:lottie/lottie.dart';
import 'package:mp_police/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:mp_police/widget/widget.dart';

class FAQs extends StatefulWidget {
  const FAQs({super.key});

  @override
  State<FAQs> createState() => _FAQsState();
}

class _FAQsState extends State<FAQs> {
  List<Map<String, dynamic>> filteredFAQs = [];
  bool isFAQFetched = false;

  Future<void> fetchData() async {
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
        final List<dynamic> faqs = data['allFaqs'];

        filteredFAQs = faqs
            .where((allFaqs) => allFaqs['is_deleted'] == 'false')
            .map((allFaqs) => allFaqs as Map<String, dynamic>)
            .toList();

        setState(() {
          isFAQFetched = true;
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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Widget frequentlyAskedQuestion(String ques, String ans) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: FAQ(
        question: ques,
        answer: ans,
        showDivider: false,
        queDecoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            color: const Color(0xffffffff),
            border: Border.all(width: 1, color: Colors.black26)),
        ansDecoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            color: const Color(0xffffffff),
            border: Border.all(width: 1, color: Colors.black12)),
        queStyle: const TextStyle(fontSize: 16),
        ansStyle: const TextStyle(fontSize: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: ValueListenableBuilder<bool>(
          valueListenable: UserSingleton().languageNotifier,
          builder: (context, isHindi, child) {
            return Text(
              isHindi ? "सामान्य प्रश्न" : "FAQs",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            );
          },
        ),
      ),
      body: isFAQFetched
          ? filteredFAQs.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "No Any FAQ!",
                    style: TextStyle(color: Colors.green, fontSize: 20),
                  ),
                )
              : ListView.builder(
                  itemCount: filteredFAQs.length,
                  itemBuilder: (context, index) {
                    final faq = filteredFAQs[index];
                    return frequentlyAskedQuestion(
                        faq['question'], faq['answer']);
                  })
          : Center(
              child: Lottie.asset("assets/animations/loading.json",
                  animate: true, width: 250),
            ),
    );
  }
}
