import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kssia/src/data/api_routes/events_api.dart';
import 'package:kssia/src/data/api_routes/news_api.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/events_model.dart';
import 'package:kssia/src/data/models/news_model.dart';
import 'package:kssia/src/interface/common/components/app_bar.dart';
import 'package:kssia/src/interface/common/loading.dart';
import 'package:kssia/src/interface/screens/event_news/event.dart';
import 'package:kssia/src/interface/screens/event_news/news.dart';
import 'package:kssia/src/interface/screens/people/chat/chat.dart';
import 'package:kssia/src/interface/screens/people/members.dart';

class Event_News_Page extends StatefulWidget {
  @override
  _Event_News_PageState createState() => _Event_News_PageState();
}

class _Event_News_PageState extends State<Event_News_Page>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final newsAsyncValue = ref.watch(fetchNewsProvider(token));
        final eventsAsyncValue = ref.watch(fetchEventsProvider(token));

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: App_bar(),
            body: Column(
              children: [
                Center(
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: false, // Disable scroll to center the tabs
                    indicatorColor:
                        Color(0xFF004797), // Set to AppPalette.kPrimaryColor
                    indicatorWeight: 2.0,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    tabs: [
                      Tab(text: "News"),
                      Tab(text: "Events"),
                    ],
                  ),
                ),
                Expanded(
                  child: newsAsyncValue.when(
                    data: (news) => eventsAsyncValue.when(
                      data: (events) {
                        return TabBarView(
                          controller: _tabController,
                          children: [
                            NewsPage(news: news),
                            EventPage(events: events),
                          ],
                        );
                      },
                      loading: () => Center(child: LoadingAnimation()),
                      error: (error, stack) => Center(
                        child: Text('Error loading events: $error'),
                      ),
                    ),
                    loading: () => Center(child: LoadingAnimation()),
                    error: (error, stack) => Center(
                      child: Text('Error loading news: $error'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
