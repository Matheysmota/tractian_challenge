import 'package:core/connection/connection_manager.dart';
import 'package:core/local_storage/local_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:core/connection/connection_status.dart';
import 'package:core/network/http_client_exception.dart';
import 'package:tractian_challenge/home/data/mapper/company_mapper.dart';
import 'package:tractian_challenge/home/data/model/companies_response.dart';
import 'package:tractian_challenge/home/data/model/company_response.dart';

import 'package:tractian_challenge/home/data/repository/home_repository.dart';
import 'package:tractian_challenge/home/data/service/home_service.dart';
import 'package:tractian_challenge/home/domain/model/cache_time_stamp.dart';
import 'package:tractian_challenge/home/domain/model/companies.dart';
import 'package:tractian_challenge/home/domain/model/company.dart';

class MockHomeService extends Mock implements HomeService {}

class MockLocalStorage extends Mock implements LocalStorage {}

class MockConnectionManager extends Mock implements ConnectionManager {}

class FakeCompanies extends Fake implements Companies {}

class FakeTimeStamp extends Fake implements CacheTimestamp {}

void main() {
  late HomeRepositoryImpl repository;
  late MockHomeService mockService;
  late MockLocalStorage mockLocalStorage;
  late MockConnectionManager mockConnectionManager;

  setUpAll(() {
    registerFallbackValue(FakeCompanies());
    registerFallbackValue(FakeTimeStamp());
  });

  setUp(() {
    mockService = MockHomeService();
    mockLocalStorage = MockLocalStorage();
    mockConnectionManager = MockConnectionManager();
    repository = HomeRepositoryImpl(
      mockService,
      mockLocalStorage,
      mockConnectionManager,
    );
  });

  group('HomeRepositoryImpl', () {
    test(
        'GIVEN valid cache WHEN getCompanies is called THEN returns cached data',
        () async {
      // GIVEN
      final cachedCompanies =
          Companies(companies: [Company(id: '1', name: 'Company 1')]);

      final cacheTimestamp = CacheTimestamp.now();
      when(() => mockLocalStorage.getJson<CacheTimestamp>(
              key: any(named: 'key'), mapper: any(named: 'mapper')))
          .thenAnswer((_) async => cacheTimestamp);
      when(() => mockLocalStorage.getJson<Companies>(
              key: any(named: 'key'), mapper: any(named: 'mapper')))
          .thenAnswer((_) async => cachedCompanies);

      // WHEN
      final result = await repository.getCompanies().first;

      // THEN
      expect(result, cachedCompanies);
      verify(() => mockLocalStorage.getJson<CacheTimestamp>(
          key: any(named: 'key'), mapper: any(named: 'mapper'))).called(1);
      verify(() => mockLocalStorage.getJson<Companies>(
          key: any(named: 'key'), mapper: any(named: 'mapper'))).called(1);
    });

    test(
        'GIVEN expired cache WHEN getCompanies is called THEN fetches data from API',
        () async {
      final expiredTimestamp = CacheTimestamp(
        data: DateTime.now().subtract(Duration(days: 2)).millisecondsSinceEpoch,
      );
      final apiCompanies = CompaniesResponse(
          companies: [CompanyResponse(id: '1', name: 'Company 1')]);
      final domainCompanies = apiCompanies.toDomain();
      when(() => mockLocalStorage.setJsonModel<Companies>(
          key: any(named: 'key'),
          toJson: any(named: 'toJson'),
          value: any(named: 'value'))).thenAnswer((_) async => true);

      when(() => mockLocalStorage.setJsonModel<CacheTimestamp>(
          key: any(named: 'key'),
          toJson: any(named: 'toJson'),
          value: any(named: 'value'))).thenAnswer((_) async => true);
      when(() => mockLocalStorage.getJson<CacheTimestamp>(
              key: any(named: 'key'), mapper: any(named: 'mapper')))
          .thenAnswer((_) async => expiredTimestamp);
      when(() => mockService.fetchCompanies())
          .thenAnswer((_) async => apiCompanies);
      when(() => mockConnectionManager.observe).thenAnswer(
        (_) => Stream.value(
          ConnectionStatus.connected,
        ),
      );

      // WHEN
      final result = await repository.getCompanies().first;

      // THEN
      expect(result, domainCompanies);
      verify(() => mockService.fetchCompanies()).called(1);
    });

    test(
        'GIVEN no cache WHEN getCompanies is called THEN fetches data from API',
        () async {
      // GIVEN
      final apiCompanies = CompaniesResponse(
          companies: [CompanyResponse(id: '1', name: 'Company 1')]);
      final domainCompanies = apiCompanies.toDomain();

      when(() => mockLocalStorage.setJsonModel<Companies>(
          key: any(named: 'key'),
          toJson: any(named: 'toJson'),
          value: any(named: 'value'))).thenAnswer((_) async => true);

      when(() => mockLocalStorage.setJsonModel<CacheTimestamp>(
          key: any(named: 'key'),
          toJson: any(named: 'toJson'),
          value: any(named: 'value'))).thenAnswer((_) async => true);
      when(() => mockLocalStorage.getJson<CacheTimestamp>(
          key: any(named: 'key'),
          mapper: any(named: 'mapper'))).thenAnswer((_) async => null);
      when(() => mockService.fetchCompanies())
          .thenAnswer((_) async => apiCompanies);
      when(() => mockConnectionManager.observe).thenAnswer(
        (_) => Stream.value(
          ConnectionStatus.connected,
        ),
      );

      // WHEN
      final result = await repository.getCompanies().first;

      // THEN
      expect(result, domainCompanies);
      verify(() => mockService.fetchCompanies()).called(1);
    });

    test(
        'GIVEN API error WHEN getCompanies is called THEN throws HttpClientException',
        () async {
      when(() => mockConnectionManager.observe).thenAnswer(
        (_) => Stream.value(
          ConnectionStatus.connected,
        ),
      );
      when(() => mockLocalStorage.getJson<CacheTimestamp>(
          key: any(named: 'key'),
          mapper: any(named: 'mapper'))).thenAnswer((_) async => null);
      when(() => mockService.fetchCompanies())
          .thenThrow(HttpClientException(message: 'API Error'));

      // WHEN & THEN
      expect(
        () async => await repository.getCompanies().first,
        throwsA(isA<HttpClientException>()),
      );
    });

    test(
        'GIVEN disconnected status WHEN getCompanies is called THEN returns cached data if available',
        () async {
      // GIVEN
      final cachedCompanies =
          Companies(companies: [Company(id: '1', name: 'Company 1')]);
      final cacheTimestamp = CacheTimestamp.now();
      when(() => mockLocalStorage.getJson<CacheTimestamp>(
              key: any(named: 'key'), mapper: any(named: 'mapper')))
          .thenAnswer((_) async => cacheTimestamp);
      when(() => mockLocalStorage.getJson<Companies>(
              key: any(named: 'key'), mapper: any(named: 'mapper')))
          .thenAnswer((_) async => cachedCompanies);
      when(() => mockConnectionManager.observe)
          .thenAnswer((_) => Stream.value(ConnectionStatus.disconnected));

      // WHEN
      final result = await repository.getCompanies().first;

      // THEN
      expect(result, cachedCompanies);
      verifyNever(() => mockService.fetchCompanies());
    });

    test(
        'GIVEN valid cache and different API response WHEN getCompanies is called THEN emits both cached and API data',
        () async {
      // GIVEN
      final cachedCompanies =
          Companies(companies: [Company(id: '1', name: 'Company 1')]);
      final cacheTimestamp = CacheTimestamp.now();
      final apiCompanies = CompaniesResponse(
          companies: [CompanyResponse(id: '2', name: 'Company 2')]);
      final domainApiCompanies = apiCompanies.toDomain();

      when(() => mockLocalStorage.setJsonModel<Companies>(
          key: any(named: 'key'),
          toJson: any(named: 'toJson'),
          value: any(named: 'value'))).thenAnswer((_) async => true);
      when(() => mockLocalStorage.setJsonModel<CacheTimestamp>(
          key: any(named: 'key'),
          toJson: any(named: 'toJson'),
          value: any(named: 'value'))).thenAnswer((_) async => true);
      when(() => mockLocalStorage.getJson<CacheTimestamp>(
              key: 'tractian_challenge_companies_key_timestamp',
              mapper: CacheTimestamp.fromJson))
          .thenAnswer((_) async => cacheTimestamp);

      when(() => mockLocalStorage.getJson<Companies>(
          key: 'tractian_challenge_companies_key',
          // Use a chave correta
          mapper: Companies.fromJson)).thenAnswer((_) async => cachedCompanies);
      when(() => mockService.fetchCompanies())
          .thenAnswer((_) async => apiCompanies);
      when(() => mockConnectionManager.observe)
          .thenAnswer((_) => Stream.value(ConnectionStatus.connected));

      // WHEN
      final result = repository.getCompanies();

      // THEN
      expect(
        result,
        emitsInOrder([
          cachedCompanies,
          domainApiCompanies,
        ]),
      );
    });
  });
}
