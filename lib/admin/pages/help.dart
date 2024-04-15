import 'package:flutter/material.dart';
import 'package:mp_police/admin/pages/tabs/ended_tab.dart';
import 'package:mp_police/admin/pages/tabs/active_tab.dart';
import 'package:mp_police/admin/pages/tabs/approval_tab.dart';
import 'package:mp_police/utils/constants.dart';
import 'package:mp_police/widget/widget.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  ValueNotifier<bool> isHindiNotifier = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: UserSingleton().languageNotifier,
              builder: (context, isHindi, _) {
                return TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.center,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                      text: isHindi ? "Active" : "सक्रिय",
                    ),
                    Tab(
                      text: isHindi ? "Approval" : "मंजूरी",
                    ),
                    Tab(
                      text: isHindi ? "Ended" : "समाप्त",
                    ),
                  ],
                );
              },
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // 1st Tab
                  ActiveTab(),

                  // 2nd Tab
                  ApprovalTab(),

                  // 3rd Tab
                  EndedTab(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
