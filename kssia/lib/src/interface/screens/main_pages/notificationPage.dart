import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kssia/src/data/models/notification_model.dart';
import 'package:kssia/src/data/services/api_routes/notification_api.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/services/launch_url.dart';
import 'package:kssia/src/interface/common/loading.dart';
import 'package:kssia/src/data/services/deep_link_service.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

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
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        ref.invalidate(fetchUnreadNotificationsProvider);
      },
      canPop: true,
      child: Consumer(
        builder: (context, ref, child) {
          final asyncUnreadNotification =
              ref.watch(fetchUnreadNotificationsProvider(token, id));
          final asyncreadNotification =
              ref.watch(fetchReadNotificationsProvider(token, id));
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
                  asyncUnreadNotification.when(
                    data: (notifications) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          bool readed = false;
                          return _buildNotificationCard(
                            link: notifications[index].linkUrl ?? '',
                            readed: readed,
                            subject: notifications[index].subject!,
                            content: notifications[index].content!,
                            dateTime: notifications[index].updatedAt!,
                            fileUrl: notifications[index].fileUrl,
                            pageName: notifications[index].pageName,
                            itemId: notifications[index].itemId,
                          );
                        },
                        padding: EdgeInsets.all(0.0),
                      );
                    },
                    loading: () => Center(child: LoadingAnimation()),
                    error: (error, stackTrace) {
                      return Center(
                        child: LoadingAnimation(),
                      );
                    },
                  ),
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

  Widget _buildNotificationCard({
    required bool readed,
    required String subject,
    required String content,
    required DateTime dateTime,
    required String link,
    String? fileUrl,
    String? pageName,
    String? itemId,
  }) {
    String time = timeAgo(dateTime);

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
      child: InkWell(
        onTap: () {
          if (pageName != '') {
            final deepLinkService = ref.watch(deepLinkServiceProvider);

            if (pageName != null && pageName.isNotEmpty) {
              final deepLinkPath =
                  deepLinkService.getDeepLinkPath(pageName, id: itemId);
              if (deepLinkPath != null) {
                deepLinkService.handleDeepLink(Uri.parse(deepLinkPath));
              }
            } else {
              try {
                final uri = Uri.parse(link);
                if (uri.scheme == 'kssia') {
                  deepLinkService.handleDeepLink(uri);
                } else {
                  if (link != '') launchURL(link);
                }
              } catch (e) {
                if (link != '') launchURL(link);
              }
            }
          }
        },
        child: Card(
          elevation: 1,
          color: readed ? const Color(0xFFF2F2F2) : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (!readed)
                      const Icon(Icons.circle, color: Colors.blue, size: 12),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        subject,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
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
                            const Icon(Icons.broken_image,
                                size: 60, color: Colors.grey),
                      ),
                    ),
                  ),
                Text(
                  content,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(height: 8),
                if (link.isNotEmpty)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Link: ",
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      Expanded(
                        child: Text(
                          link,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 143, 139, 255),
                          ),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String timeAgo(DateTime pastDate) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(pastDate);

    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;

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
}
