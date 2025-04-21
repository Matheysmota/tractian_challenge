import 'http_client_request.dart';
import 'http_client_response.dart';

abstract class HttpClient {
  Future<HttpClientResponse> get({required HttpClientRequest request});

  Future<HttpClientResponse> post({required HttpClientRequest request});

  Future<HttpClientResponse> put({required HttpClientRequest request});

  Future<HttpClientResponse> delete({required HttpClientRequest request});
}