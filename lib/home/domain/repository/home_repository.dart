import 'package:core/connection/connection_status.dart';

import '../model/company.dart';

abstract class HomeRepository {
  Stream<List<Company>> getCompanies();
  Stream<ConnectionStatus> observeConnection();
  void disposeConnection();
}