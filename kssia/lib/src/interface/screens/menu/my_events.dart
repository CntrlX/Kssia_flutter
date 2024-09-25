import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kssia/src/data/models/events_model.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/data/services/launch_url.dart';
import 'package:kssia/src/interface/common/loading.dart';

class MyEventsPage extends StatelessWidget {
  const MyEventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncEvents = ref.watch(fetchUserRsvpdEventsProvider);
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Events'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            // actions: [
            //   IconButton(
            //     icon: FaIcon(FontAwesomeIcons.whatsapp),
            //     onPressed: () {
            //       // WhatsApp action
            //     },
            //   ),
            // ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: Colors.grey,
                height: 1.0,
              ),
            ),
          ),
          body: asyncEvents.when(
            data: (registeredEvents) {
              print(registeredEvents);
              return ListView.builder(
                itemCount: registeredEvents.length,
                itemBuilder: (context, index) {
                  return eventCard(
                      context: context, event: registeredEvents[index]);
                },
              );
            },
            loading: () => Center(child: LoadingAnimation()),
            error: (error, stackTrace) {
              // Handle error state
              return Center(
                child: LoadingAnimation(),
              );
            },
          ),
        );
      },
    );
  }

  Widget eventCard({required BuildContext context, required Event event}) {
    log(event.status.toString());
    String startTime = DateFormat('hh:mm a').format(event.startTime!);
    String startDate = DateFormat('yyyy-MM-dd').format(event.startDate!);
    String endDate = DateFormat('hh:mm a').format(event.endDate!);
    String endTime = DateFormat('yyyy-MM-dd').format(event.endTime!);
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                event.image ?? 'https://via.placeholder.com/400x200',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              const Icon(Icons.play_circle_fill, size: 64, color: Colors.white),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  color: const Color(0xFFA9F3C7),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Text(event.status!,
                      style: TextStyle(color: Color(0xFF0F7036), fontSize: 14)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  event.type!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF3F0A9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 20, color: Color(0xFF700F0F)),
                          const SizedBox(width: 5),
                          Text(
                            startDate,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF700F0F),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFAED0E9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 20, color: Color(0xFF0E1877)),
                          const SizedBox(width: 5),
                          Text(
                            startTime,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF0E1877),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      event.name!,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      event.description!,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (event.status != 'completed')
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        launchURL(event.meetingLink ?? '');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004797),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              4), // Adjust the value to make the edge less circular
                        ),
                        minimumSize: const Size(
                            150, 40), // Adjust the width of the button
                      ),
                      child: const Text('JOIN',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
