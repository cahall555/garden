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

  Journal(
      {required this.id,
      required this.title,
      required this.entry,
      required this.display_on_garden,
      this.image,
      required this.category,
      required this.plant_id,
      required this.createdAt,
      required this.updatedAt});

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
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
