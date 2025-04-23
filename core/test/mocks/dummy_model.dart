import 'package:equatable/equatable.dart';

class DummyModel extends Equatable {
  final int id;
  final String name;

  const DummyModel({required this.id, required this.name});

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };

  factory DummyModel.fromJson(Map<String, dynamic> json) {
    return DummyModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  @override
  List<Object> get props => [
    id,
    name,
  ];
}