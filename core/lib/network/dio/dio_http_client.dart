import 'package:dio/dio.dart';

import '../http_client.dart';
import '../http_client_exception.dart';
import '../http_client_request.dart';
import '../http_client_response.dart';

class DioHttpClient implements HttpClient {
  const DioHttpClient(this._dio);

  final Dio _dio;

  @override
  Future<HttpClientResponse> get({required HttpClientRequest request}) {
    return _executeRequest(
      () => _dio.get(
        request.path,
        options: Options(
          headers: request.headers,
        ),
      ),
    );
  }

  @override
  Future<HttpClientResponse> post({required HttpClientRequest request}) {
    return _executeRequest(
      () => _dio.post(
        request.path,
        options: Options(
          headers: request.headers,
        ),
        data: request.body,
      ),
    );
  }

  Future<HttpClientResponse> _executeRequest(
      Future<Response> Function() dioRequest) async {
    try {
      final response = await dioRequest();
      return HttpClientResponse(
        data: response.data,
        statusCode: response.statusCode,
        message: response.statusMessage,
      );
    } on DioException catch (error, stackTrace) {
      throw HttpClientException(
        message: error.message ?? 'Execute request error',
        stackTrace: stackTrace,
        data: error.response?.data,
        statusCode: error.response?.statusCode,
      );
    }
  }
}
