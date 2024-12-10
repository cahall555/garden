import 'journal.dart';
import 'apis/journal_api.dart';
import 'ws.dart';
import 'apis/ws_api.dart';
import 'tag.dart';
import 'apis/tag_api.dart';

class Plant {
  final String id;
  final String name;
  final bool germinated;
  final int days_to_harvest;
  final int plant_count;
  final DateTime? date_planted;
  final DateTime? date_germinated;
  final String garden_id;
  final List<Tag>? plantTags;
  final List<Journal>? journals;
  final WaterSchedule? waterSchedules;
  final String account_id;
  final DateTime createdAt;
  final DateTime updatedAt;

  Plant(
      {required this.id,
      required this.name,
      required this.germinated,
      required this.days_to_harvest,
      required this.plant_count,
      this.date_planted,
      this.date_germinated,
      required this.garden_id,
      this.plantTags,
      this.journals,
      this.waterSchedules,
      required this.account_id,
      required this.createdAt,
      required this.updatedAt});

  factory Plant.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value is int) return value == 1;
      throw ArgumentError('Invalid boolean value: $value');
    }

    return Plant(
      id: json['id'],
      name: json['name'],
      germinated: parseBool(json['germinated']),
      days_to_harvest: json['days_to_harvest'],
      plant_count: json['plant_count'],
      date_planted: json['date_planted'] != null && json['date_planted'] != ''
          ? DateTime.parse(json['date_planted'])
          : null,
      date_germinated:
          json['date_germinated'] != null && json['date_germinated'] != ''
              ? DateTime.parse(json['date_germinated'])
              : null,
      garden_id: json['garden_id'],
      plantTags: json['plantTags'] != null
          ? List<Tag>.from(json['plantTags'].map((x) => Tag.fromJson(x)))
          : null,
      journals: json['journals'] != null
          ? List<Journal>.from(json['journals'].map((x) => Journal.fromJson(x)))
          : null,
      waterSchedules: json['waterSchedules'] != null
          ? WaterSchedule.fromJson(json['waterSchedules'])
          : null,
      account_id: json['account_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson({bool forSqlLite = false}) {
    dynamic serializeBool(bool value) {
      return forSqlLite ? (value ? 1 : 0) : (value ? true : false);
    }

    return {
      'id': id,
      'name': name,
      'germinated': serializeBool(germinated),
      'days_to_harvest': days_to_harvest,
      'plant_count': plant_count,
      'date_planted': date_planted?.toIso8601String(),
      'date_germinated': date_germinated?.toIso8601String(),
      'garden_id': garden_id,
      'PlantTags': plantTags?.map((x) => x.toJson()).toList(),
      'journals': journals?.map((x) => x.toJson()).toList(),
      'waterSchedules': waterSchedules?.toJson(),
      'account_id': account_id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
