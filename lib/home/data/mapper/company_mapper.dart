import '../../domain/model/companies.dart';
import '../../domain/model/company.dart';
import '../model/companies_response.dart';

extension CompanyMapper on CompaniesResponse {
  Companies toDomain() {
    return Companies(
      companies: companies
          .map(
            (company) => Company(
              id: company.id,
              name: company.name,
              parentId: company.parentId,
            ),
          )
          .toList(),
    );
  }
}
