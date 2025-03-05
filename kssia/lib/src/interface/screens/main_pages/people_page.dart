import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/services/api_routes/chat_api.dart';
import 'package:kssia/src/data/services/api_routes/subscription_api.dart';
import 'package:kssia/src/interface/common/components/app_bar.dart';
import 'package:kssia/src/interface/screens/feed/feed_view.dart';
import 'package:kssia/src/interface/screens/main_pages/menuPage.dart';
import 'package:kssia/src/interface/screens/main_pages/notificationPage.dart';
import 'package:kssia/src/interface/screens/people/chat/chat.dart';
import 'package:kssia/src/interface/screens/people/members.dart';

class PeoplePage extends ConsumerStatefulWidget {
  final int initialTabIndex;s
  
  const PeoplePage({super.key, this.initialTabIndex = 0});

  @override
  ConsumerState<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends ConsumerState<PeoplePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialTabIndex);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.invalidate(fetchStatusProvider);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        iselevationNeeded: false,
      ),
      body: Column(
        children: [
          PreferredSize(
            preferredSize: const Size.fromHeight(20),
            child: Container(
              margin: const EdgeInsets.only(top: 0),
              child: SizedBox(
                height: 40,
                child: TabBar(
                  controller: _tabController,
                  enableFeedback: true,
                  isScrollable: false,
                  indicatorColor: const Color(0xFF004797),
                  indicatorWeight: 3.0,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: const Color(0xFF004797),
                  unselectedLabelColor: Colors.grey,
                  labelStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: const [
                    Tab(text: "FEED"),
                    Tab(text: "CHAT"),
                    Tab(text: "MEMBERS"),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children:  [
                FeedView(),
                ChatPage(),
                MembersPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
