import 'package:equatable/equatable.dart';

import 'company.dart';

class Companies extends Equatable {
  const Companies({
    required this.companies,
  });

  factory Companies.fromJson(Map<String, dynamic> json) {
    return Companies(
      companies: (json['companies'] as List)
          .map((e) => Company.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final List<Company> companies;

  Map<String, dynamic> toMap() => {
    'companies': companies.map((x) => x.toMap()).toList(),
  };

  @override
  List<Object> get props => [companies];
}
