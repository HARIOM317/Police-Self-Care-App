import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mp_police/pages/group_chat_info_page.dart';
import 'package:mp_police/user/drawer_widgets/about_us.dart';
import 'package:mp_police/user/drawer_widgets/contact_us.dart';
import 'package:mp_police/user/drawer_widgets/faqs.dart';
import 'package:mp_police/pages/request_donation.dart';
import 'package:mp_police/user/drawer_widgets/search_members.dart';
import 'package:mp_police/user/drawer_widgets/settings.dart';
import 'package:mp_police/user/drawer_widgets/terms_and_conditions.dart';
import 'package:mp_police/user/pages/chat_page.dart';
import 'package:mp_police/user/pages/donation_section/track_donation.dart';
import 'package:mp_police/user/pages/home_page.dart';
import 'package:mp_police/user/pages/notify_page.dart';
import 'package:mp_police/user/pages/profile_page.dart';
import 'package:mp_police/user/pages/rules_page.dart';
import 'package:mp_police/utils/constants.dart';
import 'package:mp_police/widget/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class UserNavbar extends StatefulWidget {
  const UserNavbar({
    super.key,
  });

  @override
  State<UserNavbar> createState() => _UserNavbarState();
}

class _UserNavbarState extends State<UserNavbar> {
  int _selectedIndex = 0;
  bool isHindi = true;

  String userName = '';
  String userEmail = '';
  String userPhone = '';
  String userImg = '';

  static const List<String> _appBarTitles = [
    'Home',
    'Chat',
    'Help',
    'Search',
    'Profile',
  ];

  static const List<String> _appBarHindiTitles = [
    'मुखपृष्ठ',
    'बातचीत',
    'दान',
    'सूचनाएं',
    'प्रोफाइल',
  ];

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ChatPage(),
    TrackDonations(),
    SearchUsersPage(),
    UserProfilePage(),
  ];

  Future<void> getUserDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
      userEmail = prefs.getString('userEmail') ?? '';
      userPhone = prefs.getString('userPhone') ?? '';
      userImg = prefs.getString('userImg') ?? '';
    });
  }

  // function to disable back button
  Future<bool> _onPop() async {
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getUserDataFromSharedPreferences();
    });

    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize("f1acefda-fa34-48ec-be5d-745394910077");
    OneSignal.Notifications.requestPermission(true).then((value) {
      Fluttertoast.showToast(msg: "Notification Initialized Successfully!");
      if (kDebugMode) {
        print("Signal Value : $value");
        print("Notification Initialized Successfully!");
      }
    });

    OneSignal.User.pushSubscription.addObserver((state) {
      Fluttertoast.showToast(msg: "Message Received !");
      if (kDebugMode) {
        print(OneSignal.User.pushSubscription.optedIn);
        print(OneSignal.User.pushSubscription.id);
        print(OneSignal.User.pushSubscription.token);
        print(state.current.jsonRepresentation());
      }
    });

    OneSignal.Notifications.addPermissionObserver((state) {
      Fluttertoast.showToast(msg: "Message Received !");
      if (kDebugMode) {
        print("Has permission $state");
      }
    });

    OneSignal.Notifications.addClickListener((event) {
      if (kDebugMode) {
        print('NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $event');
      }
      setState(() {
        Fluttertoast.showToast(msg: "Message Received !");
      });
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      if (kDebugMode) {
        print('NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $event');
      }
      Fluttertoast.showToast(msg: "Message Received !");
    });

    OneSignal.InAppMessages.addClickListener((event) {
      Fluttertoast.showToast(msg: "Message Received !");
    });
    OneSignal.InAppMessages.addWillDisplayListener((event) {
      Fluttertoast.showToast(msg: "Message Received !");
      if (kDebugMode) {
        print("ON WILL DISPLAY IN APP MESSAGE ${event.message.messageId}");
      }
    });
    OneSignal.InAppMessages.addDidDisplayListener((event) {
      Fluttertoast.showToast(msg: "Message Received !");
      if (kDebugMode) {
        print("ON DID DISPLAY IN APP MESSAGE ${event.message.messageId}");
      }
    });
    OneSignal.InAppMessages.addWillDismissListener((event) {
      Fluttertoast.showToast(msg: "Message Received !");
      if (kDebugMode) {
        print("ON WILL DISMISS IN APP MESSAGE ${event.message.messageId}");
      }
    });
    OneSignal.InAppMessages.addDidDismissListener((event) {
      Fluttertoast.showToast(msg: "Message Received !");
      if (kDebugMode) {
        print("ON DID DISMISS IN APP MESSAGE ${event.message.messageId}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: _selectedIndex == 1 ? false : true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: _selectedIndex == 1
            ? GestureDetector(
                onTap: () {
                  goTo(context, const GroupChatInfoPage());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage("assets/images/logo.png"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: UserSingleton().languageNotifier,
                      builder: (context, isHindi, child) {
                        return Text(
                          isHindi
                              ? _appBarHindiTitles[_selectedIndex]
                              : _appBarTitles[_selectedIndex],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
            : Text(
                isHindi
                    ? _appBarTitles[_selectedIndex]
                    : _appBarHindiTitles[_selectedIndex],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
        actions: [
          IconButton(
            onPressed: () {
              goTo(context, const NotifyPage());
            },
            icon: const Icon(
              Icons.notifications,
              color: Colors.black,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: _onPop,
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border(
                top:
                    BorderSide(color: Colors.black.withOpacity(0.1), width: 1)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.1))
            ]),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 14, top: 8),
          child: GNav(
            color: Colors.black54,
            activeColor: Colors.white,
            tabBackgroundColor: primaryColor,
            gap: 10,
            iconSize: 24,
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
            duration: const Duration(milliseconds: 800),
            tabs: [
              GButton(
                icon: _selectedIndex == 0
                    ? CupertinoIcons.house_fill
                    : CupertinoIcons.house,
                text: 'Home',
              ),
              GButton(
                icon: _selectedIndex == 1
                    ? CupertinoIcons.chat_bubble_text_fill
                    : CupertinoIcons.chat_bubble_text,
                text: 'Chat',
              ),
              GButton(
                icon: _selectedIndex == 2
                    ? CupertinoIcons.money_dollar
                    : CupertinoIcons.money_dollar,
                text: 'Help',
              ),
              GButton(
                icon: _selectedIndex == 3
                    ? CupertinoIcons.search_circle_fill
                    : CupertinoIcons.search,
                text: 'Search',
              ),
              GButton(
                icon: _selectedIndex == 4
                    ? CupertinoIcons.person_fill
                    : CupertinoIcons.person,
                text: 'Profile',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Material(
        color: primaryColor,
        child: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.only(
                top: 24 + MediaQuery.of(context).padding.top, bottom: 24),
            child: Column(
              children: [
                userImg == ''
                    ? CircleAvatar(
                        backgroundColor: secondaryColor,
                        radius: 52,
                        child: const Icon(
                          Icons.person,
                          size: 65,
                          color: Colors.white,
                        ),
                      )
                    : CircleAvatar(
                        radius: 52,
                        backgroundImage: NetworkImage(userImg),
                      ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  userName,
                  style: const TextStyle(fontSize: 28, color: Colors.white),
                ),
                Text(
                  userEmail,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          runSpacing: 16,
          children: [
            ListTile(
              leading: const Icon(CupertinoIcons.money_dollar),
              title:
                  Text(UserSingleton().isHindi ? "दान अनुरोध" : "Help Request"),
              onTap: () {
                Navigator.pop(context);
                goTo(context, const RequestDonation());
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(CupertinoIcons.person),
              title:
                  Text(UserSingleton().isHindi ? "हमारे बारे में" : "About Us"),
              onTap: () {
                Navigator.pop(context);
                goTo(context, const AboutUs());
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.phone),
              title: Text(
                  UserSingleton().isHindi ? "हमसे संपर्क करें" : "Contact Us"),
              onTap: () {
                Navigator.pop(context);
                goTo(context, const ContactUs());
              },
            ),
            ListTile(
              leading: const Icon(Icons.translate),
              title:
                  Text(UserSingleton().isHindi ? "अनुवाद करें" : "Translate"),
              onTap: () {
                UserSingleton().toggleLanguage();
                setState(() {});
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: Text(
                  UserSingleton().isHindi ? "पूछे जाने वाले प्रश्न" : "FAQs"),
              onTap: () {
                Navigator.pop(context);
                goTo(context, const FAQs());
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: Text(UserSingleton().isHindi
                  ? "नियम और शर्तें"
                  : "Terms and Conditions"),
              onTap: () {
                Navigator.pop(context);
                goTo(context, const TermsAndConditions());
              },
            ),
            ListTile(
              leading: const Icon(Icons.rule),
              title: Text(UserSingleton().isHindi
                  ? "नियम और शर्तें"
                  : "Rules and Regulation "),
              onTap: () {
                Navigator.pop(context);
                goTo(context, RulesAndRegulationsScreen());
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(CupertinoIcons.settings),
              title: Text(UserSingleton().isHindi ? "सेटिंग" : "Setting"),
              onTap: () {
                Navigator.pop(context);
                goTo(context, const AppSetting());
              },
            ),
          ],
        ),
      );
}
