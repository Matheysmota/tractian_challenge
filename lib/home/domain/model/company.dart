import 'package:equatable/equatable.dart';

class Company extends Equatable {
  const Company({
    required this.id,
    required this.name,
    this.parentId,
  });

  factory Company.fromJson(dynamic json) {
    return Company(
      id: json['id'],
      name: json['name'],
      parentId: json['parentId'],
    );
  }

  final int id;
  final String name;
  final String? parentId;

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'parentId': parentId,
  };

  @override
  List<Object?> get props => [
        id,
        name,
        parentId,
      ];
}
