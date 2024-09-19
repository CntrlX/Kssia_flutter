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