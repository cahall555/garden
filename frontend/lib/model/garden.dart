import 'plant.dart';
import 'apis/plant_api.dart';

class Garden {
  final String id;
  final String name;
  final String description;
  final String account_id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Plant>? plants;
  final int marked_for_deletion;

  Garden(
      {required this.id,
      required this.name,
      required this.description,
      required this.account_id,
      required this.createdAt,
      required this.updatedAt,
      this.plants,
      this.marked_for_deletion = 0});

  factory Garden.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic value) {
      if (value == null || value == '') return '';
      if (value is String) return value;
      return value.toString();
      throw ArgumentError('Invalid string value: $value');
    }

    return Garden(
      id: parseString(json['id']),
      name: parseString(json['name']),
      description: parseString(json['description']),
      account_id: parseString(json['account_id']),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      plants: json['plants'] != null
          ? (json['plants'] as List).map((i) => Plant.fromJson(i)).toList()
          : null,
	marked_for_deletion: json['marked_for_deletion'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'account_id': account_id,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
      'plants': plants?.map((plant) => plant.toJson()).toList(),
      'marked_for_deletion': marked_for_deletion,
    };
  }

  set name(String newName) {
    this.name = newName;
  }

  set description(String newDescription) {
    this.description = newDescription;
  }
}
