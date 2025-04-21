import 'package:dio/dio.dart';

import '../../env/env_constants.dart';

class DioFactory {

  static Dio dio() {
    final baseOptions = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(milliseconds: connectTimeout),
      receiveTimeout: const Duration(milliseconds: receiveTimeout),
    );
    return Dio(baseOptions);
  }
}