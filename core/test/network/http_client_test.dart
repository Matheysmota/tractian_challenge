import 'package:core/network/dio/dio_http_client.dart';
import 'package:core/network/http_client_exception.dart';
import 'package:core/network/http_client_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late DioHttpClient dioHttpClient;

  setUp(() {
    mockDio = MockDio();
    dioHttpClient = DioHttpClient(mockDio);
  });

  group('DioHttpClient', () {
    test(
        'GIVEN a valid endpoint and response'
        'WHEN the GET method is called'
        'THEN it should return the expected data and status code', () async {
      final mockResponse = Response(
        data: {'key': 'value'},
        statusCode: 200,
        requestOptions: RequestOptions(path: '/test'),
      );

      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenAnswer((_) async => mockResponse);

      final request = HttpClientRequest(path: '/test', headers: {});
      final response = await dioHttpClient.get(request: request);

      expect(response.data, {'key': 'value'});
      expect(response.statusCode, 200);
    });

    test(
        'GIVEN a valid endpoint and an error response'
        'WHEN the GET method is called'
        'THEN it should throw an HttpClientException', () async {
      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          data: 'Error',
          statusCode: 500,
          requestOptions: RequestOptions(path: '/test'),
        ),
      ));

      final request = HttpClientRequest(path: '/test', headers: {});

      expect(
        () async => await dioHttpClient.get(request: request),
        throwsA(isA<HttpClientException>()),
      );
    });

    test(
        'GIVEN a valid endpoint and response'
        'WHEN the POST method is called'
        'THEN it should return the expected data and status code', () async {
      final mockResponse = Response(
        data: {'key': 'value'},
        statusCode: 201,
        requestOptions: RequestOptions(path: '/test'),
      );

      when(() => mockDio.post(any(),
              data: any(named: 'data'), options: any(named: 'options')))
          .thenAnswer((_) async => mockResponse);

      final request =
          HttpClientRequest(path: '/test', headers: {}, body: {'key': 'value'});
      final response = await dioHttpClient.post(request: request);

      expect(response.data, {'key': 'value'});
      expect(response.statusCode, 201);
    });

    test(
        'GIVEN a valid endpoint and an error response'
        'WHEN the POST method is called'
        'THEN it should throw an HttpClientException', () async {
      when(() => mockDio.post(any(),
          data: any(named: 'data'),
          options: any(named: 'options'))).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          data: 'Error',
          statusCode: 500,
          requestOptions: RequestOptions(path: '/test'),
        ),
      ));

      final request =
          HttpClientRequest(path: '/test', headers: {}, body: {'key': 'value'});

      expect(
        () async => await dioHttpClient.post(request: request),
        throwsA(isA<HttpClientException>()),
      );
    });
  });
}
