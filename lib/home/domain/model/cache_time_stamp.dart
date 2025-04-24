import 'package:equatable/equatable.dart';

class CacheTimestamp extends Equatable {
  const CacheTimestamp(this.data);

  final int data;

  factory CacheTimestamp.fromJson(Map<String, dynamic> json) =>
      CacheTimestamp(json['timestamp']);

  factory CacheTimestamp.now() => CacheTimestamp(DateTime.now().millisecondsSinceEpoch);

  Map<String, dynamic> toMap() => {'timestamp': data};

  @override
  List<Object?> get props => [data];
}
