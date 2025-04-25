import 'package:core/connection/connection_status.dart';

import '../model/companies.dart';

abstract class HomeRepository {
  Stream<Companies> getCompanies();

  Stream<ConnectionStatus> observeConnection();

  void disposeConnection();
}
