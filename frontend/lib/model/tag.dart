import 'dart:convert';
import 'plant.dart';

class Tag {
  final String id;
  final String name;
  final List<Plant> related_plants;
  final String account_id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int marked_for_deletion;

  Tag(
      {required this.id,
      required this.name,
      this.related_plants = const [],
      required this.account_id,
      required this.createdAt,
      required this.updatedAt,
      this.marked_for_deletion = 0});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
      related_plants: json['related_plants'] != null
          ? (json['related_plants'] is String
              ? (jsonDecode(json['related_plants']) as List)
                  .map((x) => Plant.fromJson(x))
                  .toList()
              : (json['related_plants'] as List)
                  .map((x) => Plant.fromJson(x))
                  .toList())
          : [],
      account_id: json['account_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      marked_for_deletion: json['marked_for_deletion'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'related_plants': jsonEncode(
          related_plants.map((x) => x.toJson()).toList()),
      'account_id': account_id,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
      'marked_for_deletion': marked_for_deletion,
    };
  }
}
