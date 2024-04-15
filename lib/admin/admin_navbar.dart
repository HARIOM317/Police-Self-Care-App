import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mp_police/admin/drawer_widgets/account_creation.dart';
import 'package:mp_police/admin/drawer_widgets/edit_rules_and_regulations.dart';
import 'package:mp_police/admin/drawer_widgets/search_members.dart';
import 'package:mp_police/admin/pages/admin_chat_page.dart';
import 'package:mp_police/admin/pages/help.dart';
import 'package:mp_police/admin/pages/admin_home_page.dart';
import 'package:mp_police/admin/pages/admin_profile_page.dart';
import 'package:mp_police/admin/pages/required_widgets/group_chat_update_info.dart';
import 'package:mp_police/pages/intro_pages/welcome_screen.dart';
import 'package:mp_police/pages/request_donation.dart';
import 'package:mp_police/utils/constants.dart';
import 'package:mp_police/widget/widget.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'drawer_widgets/account.dart';
import 'drawer_widgets/edit_about_us.dart';
import 'drawer_widgets/edit_contact_us.dart';
import 'drawer_widgets/edit_faqs.dart';

class AdminNavbar extends StatefulWidget {
  const AdminNavbar({super.key});

  @override
  State<AdminNavbar> createState() => _AdminNavbarState();
}

class _AdminNavbarState extends State<AdminNavbar> {
  int _selectedIndex = 0;
  bool isHindi = true; // Language state
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String adminName = '';
  String adminEmail = '';
  String adminPhone = '';
  String adminImg = '';

  static const List<String> _appBarTitles = [
    'Home',
    'Chat',
    'Help',
    'Profile',
  ];

  static const List<String> _appBarHindiTitles = [
    'मुखपृष्ठ',
    'बातचीत',
    'मदद',
    'प्रोफाइल',
  ];

  static const List<Widget> _widgetOptions = <Widget>[
    AdminHomePage(),
    AdminChatPage(),
    HelpPage(),
    AdminProfilePage(),
  ];

  Future<void> getAdminDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      adminName = prefs.getString('adminName') ?? '';
      adminEmail = prefs.getString('adminEmail') ?? '';
      adminPhone = prefs.getString('adminPhone') ?? '';
      adminImg = prefs.getString('adminImg') ?? '';
    });
  }

  // function to disable back button
  Future<bool> _onPop() async {
    return false;
  }

  // To logout user
  Future<void> _logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all data in shared preferences
  }

  Future<void> _editTermsAndConditions() async {
    final Uri url = Uri.parse(
        'https://sites.google.com/d/1A-_Pt5eij03NkQ4DMcPhC3_hg9SZpbyO/p/1ofeNgds9E_o6h3oJ6UpI39FeBE3hc1-g/edit');
    if (!await launchUrl(url)) {
      throw Exception('Unable to launch URL');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getAdminDataFromSharedPreferences();
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
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: _selectedIndex == 1 ? false : true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: _selectedIndex == 1
            ? GestureDetector(
                onTap: () {
                  goTo(context, const GroupChatUpdateInfo());
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
                    Text(
                      isHindi
                          ? _appBarTitles[_selectedIndex]
                          : _appBarHindiTitles[_selectedIndex],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
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
            onPressed: () {},
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
            tabBackgroundColor: Theme.of(context).primaryColor,
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
                adminImg == ''
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
                        backgroundImage: NetworkImage(adminImg),
                      ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  adminName,
                  style: const TextStyle(fontSize: 28, color: Colors.white),
                ),
                Text(
                  adminEmail,
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
              Text(UserSingleton().isHindi ? "Help Request" : "दान अनुरोध"),
              onTap: () {
                Navigator.pop(context);
                goTo(context, const RequestDonation());
              },
            ),

            // Expandable
            ExpansionTile(
              textColor: Colors.green.shade900,
              collapsedTextColor: Colors.black,
              title: Text(UserSingleton().isHindi ? "Members" : "सदस्य"),
              leading: const Icon(CupertinoIcons.person_3_fill),
              childrenPadding: const EdgeInsets.only(left: 20),
              children: [
                ListTile(
                  leading: const Icon(CupertinoIcons.search),
                  title: Text(
                    UserSingleton().isHindi ? 'Search Members' : 'सदस्य खोजें',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchUsersPage()));
                  },
                ),
                ListTile(
                  leading: const Icon(CupertinoIcons.person),
                  title: Text(
                    UserSingleton().isHindi ? 'Account' : 'खाता',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Account()));
                  },
                ),
              ],
            ),

            ExpansionTile(
              textColor: Colors.green.shade900,
              collapsedTextColor: Colors.black,
              title:
                  Text(UserSingleton().isHindi ? "App Setting" : "ऐप सेटिंग"),
              leading: const Icon(CupertinoIcons.settings_solid),
              childrenPadding: const EdgeInsets.only(left: 20),
              children: [
                ListTile(
                  leading: const Icon(CupertinoIcons.info),
                  title: Text(UserSingleton().isHindi
                      ? "Edit About Us"
                      : "हमारे बारे में संपादित करें"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EditAboutUs()));
                  },
                ),
                ListTile(
                  leading: const Icon(CupertinoIcons.phone),
                  title: Text(UserSingleton().isHindi
                      ? "Edit Contact Us"
                      : "हमसे संपर्क को संपादित करेंं"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditContactUs()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.rule),
                  title:
                      Text(isHindi ? "Edit Rules" : "नियम-विनियम संपादित करें"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditRulesAndRegulations()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text(UserSingleton().isHindi
                      ? "Edit T&C"
                      : "नियम एवं शर्तें संपादित करेंं"),
                  onTap: () {
                    Navigator.pop(context);
                    _editTermsAndConditions();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: Text(UserSingleton().isHindi
                      ? "Edit FAQs"
                      : "प्रश्न संपादित करेंं"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditFAQs(),
                      ),
                    );
                  },
                ),
              ],
            ),

            // Non-expandable
            const Divider(),

            ListTile(
              leading: const Icon(Icons.translate),
              title:
                  Text(UserSingleton().isHindi ? "Translate" : "अनुवाद करें"),
              onTap: () {
                UserSingleton.instance.toggleLanguage(); // Toggle language
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(UserSingleton().isHindi
                  ? "Account Creation"
                  : "खाता निर्माण"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccountCreation()));
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(UserSingleton().isHindi ? "Logout" : "लॉग आउट"),
              onTap: () {
                _logoutUser();
                goTo(
                  context,
                  const WelcomeScreen(),
                );
              },
            ),
          ],
        ),
      );
}
