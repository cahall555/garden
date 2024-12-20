class Journal {
  final String id;
  final String title;
  final String entry;
  final bool display_on_garden;
  final String? image;
  final String category;
  final String plant_id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int marked_for_deletion;

  Journal(
      {required this.id,
      required this.title,
      required this.entry,
      required this.display_on_garden,
      this.image,
      required this.category,
      required this.plant_id,
      required this.createdAt,
      required this.updatedAt,
      this.marked_for_deletion = 0});

  factory Journal.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value is int) return value == 1;
      throw ArgumentError('Invalid boolean value: $value');
    }

    return Journal(
      id: json['id'],
      title: json['title'],
      entry: json['entry'],
      display_on_garden: parseBool(json['display_on_garden']),
      image: json['image'],
      category: json['category'],
      plant_id: json['plant_id'],
      marked_for_deletion: json['marked_for_deletion'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson({bool forSqlLite = false}) {
    dynamic serializeBool(bool value) {
      return forSqlLite ? (value ? 1 : 0) : (value ? 't' : 'f');
    }

    return {
      'id': id,
      'title': title,
      'entry': entry,
      'display_on_garden': serializeBool(display_on_garden),
      'image': image,
      'category': category,
      'plant_id': plant_id,
      'marked_for_deletion': marked_for_deletion,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };
  }
}
