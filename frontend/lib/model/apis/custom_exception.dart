class CustomHttpException implements Exception {
  final String message;
  final Uri uri;

  CustomHttpException(this.message, {required this.uri});

  @override
  String toString() => 'CustomHttpException: $message, URL: $uri';
}
