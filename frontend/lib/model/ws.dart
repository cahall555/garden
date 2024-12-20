class WaterSchedule {
  final String id;
  final bool monday;
  final bool tuesday;
  final bool wednesday;
  final bool thursday;
  final bool friday;
  final bool saturday;
  final bool sunday;
  final String method;
  final String notes;
  final String plant_id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int marked_for_deletion;

  WaterSchedule(
      {required this.id,
      required this.monday,
      required this.tuesday,
      required this.wednesday,
      required this.thursday,
      required this.friday,
      required this.saturday,
      required this.sunday,
      required this.method,
      required this.notes,
      required this.plant_id,
      required this.createdAt,
      required this.updatedAt,
      this.marked_for_deletion = 0});

  factory WaterSchedule.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) {
	if (value.toLowerCase() == 'true') return true;
	if (value.toLowerCase() == 'false') return false;
      }
      throw ArgumentError('Invalid boolean value: $value');
    }

    return WaterSchedule(
      id: json['id'],
      monday: parseBool(json['monday']),
      tuesday: parseBool(json['tuesday']),
      wednesday: parseBool(json['wednesday']),
      thursday: parseBool(json['thursday']),
      friday: parseBool(json['friday']),
      saturday: parseBool(json['saturday']),
      sunday: parseBool(json['sunday']),
      method: json['method'],
      notes: json['notes'],
      plant_id: json['plant_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      marked_for_deletion: json['marked_for_deletion'] ?? 0,
    );
  }

  Map<String, dynamic> toJson({bool forSqlLite = false}) {
    dynamic serializeBool(bool value) {
      return forSqlLite ? (value ? 1 : 0) : (value ? true : false);
    }

    return {
      'id': id,
      'monday': serializeBool(monday),
      'tuesday': serializeBool(tuesday),
      'wednesday': serializeBool(wednesday),
      'thursday': serializeBool(thursday),
      'friday': serializeBool(friday),
      'saturday': serializeBool(saturday),
      'sunday': serializeBool(sunday),
      'method': method,
      'notes': notes,
      'plant_id': plant_id,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
      'marked_for_deletion': marked_for_deletion,
    };
  }
}
