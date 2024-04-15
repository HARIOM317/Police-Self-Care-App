import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:mp_police/user/pages/notice_page.dart';
import 'package:mp_police/user/pages/previouswork_page.dart';
import 'package:mp_police/utils/constants.dart';
import 'package:mp_police/widget/widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  int index = 0;

  String? founderImage;
  String? previousImage1;
  String? previousImage2;
  String? previousImage1Text;
  String? previousImage2Text;
  String? noticeText;
  String? telegramLink;

  Future<void> fetchData() async {
    final String url = 'https://pscta.tdpvista.co.in/api/v1/home/landingdata';

    try {
      final request = http.Request('OPTIONS', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({
          'founder_img': founderImage,
          'previous_img_1': previousImage1,
          'previous_img_2': previousImage2,
          'previous_img_1_text': previousImage1Text,
          'previous_img_2_text': previousImage2Text,
          'notice_text': noticeText,
          'telegram_link': telegramLink,
        });

      final streamedResponse = await http.Client().send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['landingpageData'];

        setState(() {
          founderImage = data['founder_img'];
          previousImage1 = data['previous_img_1'];
          previousImage2 = data['previous_img_2'];
          previousImage1Text = data['previous_img_1_text'];
          previousImage2Text = data['previous_img_2_text'];
          noticeText = data['notice_text'];
          telegramLink = data['telegram_link'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void viewAllPreviousWork() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PreviousWorkPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    goTo(context, const ReminderAndNoticePage());
                  },
                  child: ValueListenableBuilder<bool>(
                    valueListenable: UserSingleton().languageNotifier,
                    builder: (context, isHindi, child) {
                      return Text(
                        isHindi ? "अनुस्मारक और सूचना" : "NOTICE",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomCard(
              noticeText: noticeText,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder<bool>(
                    valueListenable: UserSingleton().languageNotifier,
                    builder: (context, isHindi, child) {
                      return Text(
                        UserSingleton().isHindi
                            ? "पिछला कार्य विकल्प"
                            : "Previous Work",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      );
                    })
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    boxArea(context,
                        previousImage1 ?? 'assets/images/login.png', 0.45),
                    const SizedBox(height: 5),
                    Text(
                      previousImage1Text ?? "",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  children: [
                    boxArea(context, previousImage2 ?? "", 0.45),
                    const SizedBox(height: 5),
                    Text(
                      previousImage2Text ?? "",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: viewAllPreviousWork,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset:
                              const Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ValueListenableBuilder<bool>(
                        valueListenable: UserSingleton().languageNotifier,
                        builder: (context, isHindi, child) {
                          return Text(
                            UserSingleton().isHindi ? "सभी देखें" : "View All",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(founderImage ?? 'default_image_url'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            IconButton(
              onPressed: () async {
                if (telegramLink != null && await canLaunch(telegramLink!)) {
                  await launch(telegramLink!);
                } else {
                  throw 'Could not launch $telegramLink';
                }
              },
              icon: Icon(Icons.telegram, color: Colors.blue, size: 40),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String? noticeText;

  const CustomCard({
    Key? key,
    this.noticeText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 200,
      child: Card(
        color: Colors.green.shade50,
        elevation: 4, // Adjust elevation as needed
        shadowColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notice:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  noticeText ?? '',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// Shadow color
