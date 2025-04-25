import 'package:core/network/http_client.dart';
import 'package:core/network/http_client_exception.dart';
import 'package:core/network/http_client_request.dart';
import 'package:core/network/http_client_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tractian_challenge/home/data/model/companies_response.dart';
import 'package:tractian_challenge/home/data/service/home_service.dart';
import 'package:tractian_challenge/home/data/service/home_service_network_endpoints.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late MockHttpClient mockHttpClient;
  late HomeServiceImpl homeService;

  setUp(() {
    mockHttpClient = MockHttpClient();
    homeService = HomeServiceImpl(mockHttpClient);

    registerFallbackValue(
      HttpClientRequest(
        path: HomeServiceNetworkEndpoints.companiesPath,
      ),
    );
  });

  group('fetchCompanies', () {
    test(
        'GIVEN valid JSON response WHEN fetchCompanies is called THEN returns CompaniesResponse',
        () async {
          const mockJson = [
            {"id": "662fd0ee639069143a8fc387", "name": "Jaguar"},
            {"id": "662fd0fab3fd5656edb39af5", "name": "Tobias"},
            {"id": "662fd100f990557384756e58", "name": "Apex"}
          ];
      final mockResponse = HttpClientResponse(
        statusCode: 200,
        data: mockJson,
        message: null,
      );
      when(() => mockHttpClient.get(request: any(named: 'request')))
          .thenAnswer((_) async => mockResponse);

      final result = await homeService.fetchCompanies();

      expect(result, isA<CompaniesResponse>());
      expect(result.companies.length, 3);
      expect(result.companies[0].name, 'Jaguar');
      expect(result.companies[0].id, '662fd0ee639069143a8fc387');
      expect(result.companies[1].name, 'Tobias');
      expect(result.companies[1].id, '662fd0fab3fd5656edb39af5');
      expect(result.companies[2].name, 'Apex');
      expect(result.companies[2].id, '662fd100f990557384756e58');
    });

    test(
        'GIVEN non-200 status code WHEN fetchCompanies is called THEN throws HttpClientException',
            () async {
          final mockResponse = HttpClientResponse(
            statusCode: 404,
            data: null,
            message: 'Not Found',
          );
          when(() => mockHttpClient.get(request: any(named: 'request')))
              .thenAnswer((_) async => mockResponse);

          expect(
                () async => await homeService.fetchCompanies(),
            throwsA(isA<HttpClientException>()),
          );
        });

    test(
        'GIVEN invalid JSON response WHEN fetchCompanies is called THEN throws FormatException',
            () async {
          const mockInvalidJson = [
            {"unexpected_key": "unexpected_value"}
          ];
          final mockResponse = HttpClientResponse(
            statusCode: 200,
            data: mockInvalidJson,
            message: null,
          );
          when(() => mockHttpClient.get(request: any(named: 'request')))
              .thenAnswer((_) async => mockResponse);

          final call = homeService.fetchCompanies;

          expect(() => call(), throwsA(isA<HttpClientException>()));
        });

    test(
        'GIVEN network error WHEN fetchCompanies is called THEN throws HttpClientException',
        () async {
      when(
        () => mockHttpClient.get(
          request: any(
            named: 'request',
          ),
        ),
      ).thenThrow(
        HttpClientException(
          message: 'Network error',
        ),
      );

      final call = homeService.fetchCompanies;

      expect(() => call(), throwsA(isA<HttpClientException>()));
    });
  });
}
