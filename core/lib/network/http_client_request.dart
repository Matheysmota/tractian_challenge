class HttpClientRequest {
  HttpClientRequest({
    required this.path,
    this.headers = const {},
    this.body,
  }) {
    if (path.isEmpty) {
      throw ArgumentError('Path cannot be empty');
    }
  }

  final String path;
  final Map<String, String> headers;
  final dynamic body;
}
