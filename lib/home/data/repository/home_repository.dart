import 'package:core/core.dart';

import '../../domain/model/cache_time_stamp.dart';
import '../../domain/model/companies.dart';
import '../../domain/repository/home_repository.dart';
import '../service/home_service.dart';
import '../mapper/company_mapper.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(
    this._service,
    this._localStorage,
    this._connectionManager,
  );

  final HomeService _service;
  final LocalStorage _localStorage;
  final ConnectionManager _connectionManager;

  static const _cacheKey = 'tractian_challenge_companies_key';
  static const _cacheTimeStampKey = '${_cacheKey}_timestamp';

  @override
  Stream<ConnectionStatus> observeConnection() {
    return _connectionManager.observe;
  }

  @override
  void disposeConnection() {
    _connectionManager.dispose();
  }

  @override
  Stream<Companies> getCompanies() async* {
    final cache = await _tryGetValidCache();

    if (cache != null) {
      yield cache;
    }

    final connection = await _connectionManager.observe.first;
    if (connection == ConnectionStatus.disconnected) return;

    final model = (await _service.fetchCompanies()).toDomain();
    if (model != cache) {
      _saveToCache(companies: model);
      yield model;
    }
  }

  Future<Companies?> _tryGetValidCache() async {
    final timestamp = await _localStorage.getJson<CacheTimestamp>(
      key: _cacheTimeStampKey,
      mapper: CacheTimestamp.fromJson,
    );
    if (_isCacheExpired(timestamp: timestamp?.data)) return null;

    return _localStorage.getJson<Companies>(
      key: _cacheKey,
      mapper: Companies.fromJson,
    );
  }

  bool _isCacheExpired({int? timestamp}) {
    if (timestamp == null) {
      return true;
    }
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime.now().difference(date).inHours > 24;
  }

  Future<void> _saveToCache({required Companies companies}) async {
    await _localStorage.setJsonModel<Companies>(
      key: _cacheKey,
      toJson: (model) => model.toMap(),
      value: companies,
    );
    await _localStorage.setJsonModel<CacheTimestamp>(
      key: _cacheTimeStampKey,
      toJson: (timestamp) => timestamp.toMap(),
      value: CacheTimestamp.now(),
    );
  }
}
