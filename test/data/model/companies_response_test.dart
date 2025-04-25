import 'package:flutter_test/flutter_test.dart';
import 'package:tractian_challenge/home/data/model/companies_response.dart';
import 'package:tractian_challenge/home/data/model/company_response.dart';

void main() {
  group('CompaniesResponse', () {
    test('fromJson should parse JSON correctly', () {
      final json = [
        {'id': '1', 'name': 'Company 1', 'parent_id': null},
        {'id': '2', 'name': 'Company 2', 'parent_id': '1'},
      ];

      final result = CompaniesResponse.fromJson(json);

      expect(result.companies, [
        CompanyResponse(id: '1', name: 'Company 1', parentId: null),
        CompanyResponse(id: '2', name: 'Company 2', parentId: '1'),
      ]);
    });

    test('props should include companies', () {
      final companies = [
        CompanyResponse(id: '1', name: 'Company 1', parentId: null),
      ];
      final companiesResponse = CompaniesResponse(companies: companies);

      expect(companiesResponse.props, [companies]);
    });
  });
}