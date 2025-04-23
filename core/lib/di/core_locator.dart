import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../connection/connection_manager.dart';
import '../env/environment_config.dart';
import '../env/file_reader.dart';
import '../local_storage/local_storage.dart';
import '../network/dio/dio_factory.dart';
import '../network/dio/dio_http_client.dart';
import '../network/http_client.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupCoreLocator() async {
  getIt.registerLazySingleton<FileReader>(() => FileReaderImpl());
  getIt.registerLazySingleton<EnvironmentConfig>(
    () => EnvironmentConfig(getIt<FileReader>()),
  );

  getIt.registerLazySingleton<ConnectionManager>(
        () => ConnectivityManagerImpl(),
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<LocalStorage>(
      () => LocalStorageImpl(sharedPreferences));

  final dio = DioFactory.dio();
  getIt.registerLazySingleton<Dio>(() => dio);
  getIt.registerLazySingleton<HttpClient>(() => DioHttpClient(dio));
}
