import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kssia/src/data/models/notification_model.dart';
import 'package:kssia/src/data/services/api_routes/notification_api.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/services/launch_url.dart';
import 'package:kssia/src/interface/common/loading.dart';

class NotificationPage extends ConsumerStatefulWidget {
  final List<NotificationModel> notifcations;
  const NotificationPage({required this.notifcations, super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  @override
  Widget build(BuildContext context) {
    return PopScope(onPopInvokedWithResult: (didPop, result) {
          ref.invalidate(fetchUnreadNotificationsProvider);
    },
      canPop: true,
      // onWillPop: () async {
      //   return true;
      // },
      child: Consumer(
        builder: (context, ref, child) {
          // final asyncUnreadNotification =
          //     ref.watch(fetchUnreadNotificationsProvider(token,id));
          // final asyncreadNotification =
          //     ref.watch(fetchReadNotificationsProvider(token,id));
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                "Notifications",
                style: TextStyle(fontSize: 17),
              ),
              backgroundColor: Colors.white,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // asyncUnreadNotification.when(
                  //   data: (unreadNotifications) {
                  //     return 
                      
                      ListView.builder(
                        shrinkWrap: true, // Added this line
                        physics:
                            NeverScrollableScrollPhysics(), // Prevents scrolling within the ListView
                        itemCount: widget.notifcations .length,
                        itemBuilder: (context, index) {
                          bool readed = false;
                          return _buildNotificationCard(
                            link: widget.notifcations[index].linkUrl ?? '',
                            readed: readed,
                            subject: widget.notifcations[index].subject!,
                            content: widget.notifcations[index].content!,
                            dateTime: widget.notifcations[index].updatedAt!,
                            fileUrl: widget.notifcations[index].fileUrl,
                          );
                        },
                        padding: EdgeInsets.all(0.0),
                      )
                  //   },
                  //   loading: () => Center(child: LoadingAnimation()),
                  //   error: (error, stackTrace) {
                  //     return Center(
                  //       child: LoadingAnimation(),
                  //     );
                  //   },
                  // ),
                  // asyncreadNotification.when(
                  //   data: (readNotifications) {
                  //     return ListView.builder(
                  //       shrinkWrap: true, // Added this line
                  //       physics:
                  //           NeverScrollableScrollPhysics(), // Prevents scrolling within the ListView
                  //       itemCount: readNotifications.length,
                  //       itemBuilder: (context, index) {
                  //         bool readed = true;
                  //         return _buildNotificationCard(
                  //           readed: readed,
                  //           subject: readNotifications[index].subject ?? '',
                  //           content: readNotifications[index].content ?? '',
                  //           dateTime: readNotifications[index].updatedAt!,
                  //           link: readNotifications[index].linkUrl ?? '',
                  //         );
                  //       },
                  //       padding: EdgeInsets.all(0.0),
                  //     );
                  //   },
                  //   loading: () => Center(child: LoadingAnimation()),
                  //   error: (error, stackTrace) {
                  //     return Center(
                  //       child: LoadingAnimation(),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(
      {required bool readed,
      required String subject,
      required String content,
      required DateTime dateTime,
      required String link,
      String? fileUrl}) {
    String time = timeAgo(dateTime);
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
      child: InkWell(
        onTap: () {
          if (link != '') {
            launchURL(link);
          }
        },
        child: Card(
          elevation: 1,
          color: readed ? Color(0xFFF2F2F2) : Colors.white,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (!readed)
                      Icon(Icons.circle, color: Colors.blue, size: 12),
                    SizedBox(width: 8),
                    Text(
                      subject,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                if (fileUrl != null && fileUrl.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        fileUrl,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image, size: 60, color: Colors.grey),
                      ),
                    ),
                  ),
                Text(
                  content,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                SizedBox(height: 8),
                if(link!=null && link!='')
                Row(
                  children: [
                    Text(
                      "Link: ",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    Text(
                      link,
                      style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 143, 139, 255)),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String timeAgo(DateTime pastDate) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(pastDate);

  // Get the number of days, hours, and minutes
  int days = difference.inDays;
  int hours = difference.inHours % 24;
  int minutes = difference.inMinutes % 60;

  // Generate a human-readable string based on the largest unit
  if (days > 0) {
    return '$days day${days > 1 ? 's' : ''} ago';
  } else if (hours > 0) {
    return '$hours hour${hours > 1 ? 's' : ''} ago';
  } else if (minutes > 0) {
    return '$minutes minute${minutes > 1 ? 's' : ''} ago';
  } else {
    return 'Just now';
  }
}
