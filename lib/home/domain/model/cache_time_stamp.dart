import 'package:equatable/equatable.dart';

class CacheTimestamp extends Equatable {
  const CacheTimestamp({required this.data});

  final int data;

  factory CacheTimestamp.fromJson(Map<String, dynamic> json) =>
      CacheTimestamp(data: json['timestamp']);

  factory CacheTimestamp.now() => CacheTimestamp(data: DateTime.now().millisecondsSinceEpoch);

  Map<String, dynamic> toMap() => {'timestamp': data};

  @override
  List<Object?> get props => [data];
}
