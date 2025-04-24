import 'package:equatable/equatable.dart';

class CompanyResponse extends Equatable {
  const CompanyResponse({
    required this.id,
    required this.name,
    this.parentId,
  });

  factory CompanyResponse.fromJson(Map<String, dynamic> json) {
    return CompanyResponse(
      id: json['id'],
      name: json['name'],
      parentId: json['parent_id'],
    );
  }

  final int id;
  final String name;
  final String? parentId;

  @override
  List<Object?> get props => [
        id,
        name,
        parentId,
      ];
}
