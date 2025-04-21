
import '../errors/base_exception.dart';

class HttpClientException implements BaseException {
  const HttpClientException({
    required this.message,
    this.stackTrace,
    this.data,
    this.statusCode,
  });

  @override
  final String message;
  @override
  final StackTrace? stackTrace;
  @override
  final dynamic data;
  @override
  final int? statusCode;

  @override
  String toString() {
    return 'HttpClientException: $message';
  }
}