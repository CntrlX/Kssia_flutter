final RegExp _youtubeUrlPattern = RegExp(
  r"^(https?:\/\/)?(www\.)?(youtube\.com\/(watch\?v=|shorts\/)|youtu\.be\/)[\w\-]+(\?[\w=&%-]*)?$",
);

String? validateYouTubeUrl(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a YouTube link';
  }
  if (!_youtubeUrlPattern.hasMatch(value)) {
    return 'Please enter a valid YouTube video or Shorts link';
  }
  return null;
}

String? isValidUri(String? link) {
  final uri = Uri.parse(link ?? '');
  if (link != '') {
    if (!uri.hasScheme && !(uri.isAbsolute || uri.host.isNotEmpty)) {
      return 'Please enter a valid Social Media link';
    }
  }
  return null;
}
