import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class App_bar extends StatelessWidget implements PreferredSizeWidget {

  const App_bar({Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading:SvgPicture.asset(
  'assets/icons/kssiaLogo.svg',
  semanticsLabel: 'Kssia Logo'
),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications), // Replace with your notification icon
          onPressed: () {
            // Add your notification icon's onPressed functionality here
          },
        ),
        IconButton(
          icon: Icon(Icons.menu), // Replace with your hamburger icon
          onPressed: () {
            // Add your hamburger icon's onPressed functionality here
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}