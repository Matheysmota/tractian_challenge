abstract class BaseException implements Exception {
  const BaseException({
    required this.message,
    this.stackTrace,
    this.data,
    this.statusCode,
});

  final String message;
  final StackTrace? stackTrace;
  final dynamic data;
  final int? statusCode;

}