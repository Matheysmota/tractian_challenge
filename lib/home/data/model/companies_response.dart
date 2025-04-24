import 'package:equatable/equatable.dart';

import 'company_response.dart';

class CompaniesResponse extends Equatable {
  const CompaniesResponse({required this.companies});

  factory CompaniesResponse.fromJson(dynamic json) {
    return CompaniesResponse(
      companies:
          (json as List).map((e) => CompanyResponse.fromJson(e)).toList(),
    );
  }

  final List<CompanyResponse> companies;

  @override
  List<Object> get props => [companies];
}
