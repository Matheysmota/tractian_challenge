import 'package:flutter_test/flutter_test.dart';
import 'package:tractian_challenge/home/data/mapper/company_mapper.dart';
import 'package:tractian_challenge/home/data/model/companies_response.dart';
import 'package:tractian_challenge/home/data/model/company_response.dart';
import 'package:tractian_challenge/home/domain/model/companies.dart';
import 'package:tractian_challenge/home/domain/model/company.dart';


void main() {
  group('CompanyMapper', () {
    test('toDomain should map CompaniesResponse to Companies correctly', () {
      final companiesResponse = CompaniesResponse(
        companies: [
          CompanyResponse(id: '1', name: 'Company 1', parentId: null),
          CompanyResponse(id: '2', name: 'Company 2', parentId: '1'),
        ],
      );

      final result = companiesResponse.toDomain();

      expect(
        result,
        Companies(
          companies: [
            Company(id: '1', name: 'Company 1', parentId: null),
            Company(id: '2', name: 'Company 2', parentId: '1'),
          ],
        ),
      );
    });

    test('toDomain should handle empty CompaniesResponse', () {
      final companiesResponse = CompaniesResponse(companies: []);

      final result = companiesResponse.toDomain();

      expect(result, Companies(companies: []));
    });
  });
}