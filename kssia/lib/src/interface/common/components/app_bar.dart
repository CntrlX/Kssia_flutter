// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class App_bar extends StatelessWidget implements PreferredSizeWidget {

//   const App_bar({Key? key, }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       leading:SvgPicture.asset(
//   'assets/icons/ackafLogo.svg',
//   semanticsLabel: 'ackaf Logo'
// ),
//       actions: [
//         IconButton(
//           icon: Icon(Icons.notifications), // Replace with your notification icon
//           onPressed: () {
//             // Add your notification icon's onPressed functionality here
//           },
//         ),
//         IconButton(
//           icon: Icon(Icons.menu), // Replace with your hamburger icon
//           onPressed: () {
//             // Add your hamburger icon's onPressed functionality here
//           },
//         ),
//       ],
//     );
//   }

//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/services/api_routes/notification_api.dart';
import 'package:kssia/src/interface/screens/main_pages/menuPage.dart';
import 'package:kssia/src/interface/screens/main_pages/notificationPage.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool iselevationNeeded;
  const CustomAppBar({Key? key, this.iselevationNeeded = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: iselevationNeeded ? Offset(0, 2) : Offset(0, 0),
            blurRadius: iselevationNeeded ? 4 : 0,
          ),
        ],
      ),
      child: AppBar(
        toolbarHeight: 45.0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(
              'assets/icons/kssiaLogo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final asyncNotifications =
                  ref.watch(fetchUnreadNotificationsProvider(token, id));
              return asyncNotifications.when(
                data: (notifications) {
                  final bool hasUnread = notifications.any(
                    (notification) =>
                        !(notification.readBy?.contains(id) ?? false),
                  );

                  return IconButton(
                    icon: hasUnread
                        ? const Icon(Icons.notification_add_outlined,
                            color: Colors.red)
                        : const Icon(Icons.notifications_none_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationPage(),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: Icon(Icons.notifications_none_outlined),
                ),
                error: (error, stackTrace) => const Center(
                  child: Text(''),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MenuPage()), // Hardcoded action
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(45.0);
}
