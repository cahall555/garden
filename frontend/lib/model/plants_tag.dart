class PlantTags {
  final String id;
  final String plant_id;
  final String tag_id;
  final String account_id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int marked_for_deletion;

  PlantTags(
      {required this.id,
      required this.plant_id,
      required this.tag_id,
      required this.account_id,
      required this.createdAt,
      required this.updatedAt,
      this.marked_for_deletion = 0});

  factory PlantTags.fromJson(Map<String, dynamic> json) {
    return PlantTags(
      id: json['id'],
      plant_id: json['plant_id'],
      tag_id: json['tag_id'],
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
      'plant_id': plant_id,
      'tag_id': tag_id,
      'account_id': account_id,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
      'marked_for_deletion': marked_for_deletion,
    };
  }
}
