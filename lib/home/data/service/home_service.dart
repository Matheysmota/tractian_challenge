import 'package:core/network/http_client.dart';
import 'package:core/network/http_client_exception.dart';
import 'package:core/network/http_client_request.dart';
import 'package:tractian_challenge/home/data/model/companies_response.dart';

import '../model/company_response.dart';
import 'home_service_network_endpoints.dart';

abstract class HomeService {
  Future<CompaniesResponse> fetchCompanies();
}

class HomeServiceImpl implements HomeService {
  const HomeServiceImpl(this._httpClient);

  final HttpClient _httpClient;
  static const String message = 'Failed to load data';

  @override
  Future<CompaniesResponse> fetchCompanies() async {
    final response = await _httpClient.get(
        request: HttpClientRequest(
      path: HomeServiceNetworkEndpoints.companiesPath,
    ));
    if (response.statusCode == 200) {
      final companiesResponse = CompaniesResponse.fromJson(response.data);
      return companiesResponse;
    }
    return throw HttpClientException(
      message: response.message ?? message,
      statusCode: response.statusCode,
      stackTrace: StackTrace.current,
    );
  }
}
