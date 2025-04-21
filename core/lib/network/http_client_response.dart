class HttpClientResponse {
  HttpClientResponse({
    this.data,
    this.statusCode,
    this.message,
  });

  dynamic data;
  int? statusCode;
  String? message;
}
