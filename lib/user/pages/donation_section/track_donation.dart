import 'package:flutter/material.dart';
import 'package:mp_police/user/pages/donation_section/second_tab.dart';
import 'package:mp_police/user/pages/donation_section/third_tab.dart';
import 'package:mp_police/user/pages/donation_tracking_page.dart';
import 'package:mp_police/widget/widget.dart';

class TrackDonations extends StatefulWidget {
  const TrackDonations({super.key});

  @override
  State<TrackDonations> createState() => _TrackDonationsState();
}

class _TrackDonationsState extends State<TrackDonations> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          body: Column(
            children: [
              TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.center,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    ValueListenableBuilder<bool>(
                      valueListenable: UserSingleton().languageNotifier,
                      builder: (context, isHindi, child) {
                        return Tab(
                          text: isHindi ? "सक्रिय" : "Active",
                        );
                      },
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: UserSingleton().languageNotifier,
                      builder: (context, isHindi, child) {
                        return Tab(
                          text: isHindi ? "योगदान किया" : "Contributed",
                        );
                      },
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: UserSingleton().languageNotifier,
                      builder: (context, isHindi, child) {
                        return Tab(
                          text: isHindi ? "समाप्त" : "Ended",
                        );
                      },
                    ),
                  ]),
              Expanded(
                child: TabBarView(children: [
                  // 1st Tab

                  // 2nd Tab
                  SecondTab(),

                  // 3rd Tab
                  ThirdTab(),

                  DonationTrackingPage(),
                ]),
              )
            ],
          ),
        ));
  }
}
