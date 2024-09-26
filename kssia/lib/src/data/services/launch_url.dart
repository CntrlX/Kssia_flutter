import 'package:url_launcher/url_launcher.dart';

void launchURL(String url) async {
  // Check if the URL starts with 'http://' or 'https://', if not add 'http://'
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    url = 'http://' + url;
  }

  try {
    await launchUrl(Uri.parse(url));
  } catch (e) {
    print(e);
  }
}

// void launchInstagram(String url) async {
//   if (!url.startsWith('http://www.instagram.com/') &&
//       !url.startsWith('https://www.instagram.com/')) {
//     url = 'https://www.instagram.com/$url';
//   }

//   try {
//     await launchUrl(Uri.parse(url));
//   } catch (e) {
//     print(e);
//   }
// }


// void launchLinkedin(String url) async {
//   if (!url.startsWith('http://www.instagram.com/') &&
//       !url.startsWith('https://www.instagram.com/')) {
//     url = 'https://www.instagram.com/$url';
//   }

//   try {
//     await launchUrl(Uri.parse(url));
//   } catch (e) {
//     print(e);
//   }
// }

// void launchTwitter(String url) async {
//   if (!url.startsWith('https://x.com/') &&
//       !url.startsWith('https://x.com/')) {
//     url = 'https://x.com/$url';
//   }

//   try {
//     await launchUrl(Uri.parse(url));
//   } catch (e) {
//     print(e);
//   }
// }

// void launchFacebook(String url) async {
//   if (!url.startsWith('http://www.facebook.com/') &&
//       !url.startsWith('https://www.facebook.com/')) {
//     url = 'https://www.facebook.com/$url';
//   }

//   try {
//     await launchUrl(Uri.parse(url));
//   } catch (e) {
//     print(e);
//   }
// }