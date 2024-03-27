class PlantTags {
	final String id;
	final String plant_id;
	final String tag_id;
	final DateTime createdAt;
	final DateTime updatedAt;

  	PlantTags({required this.id, required this.plant_id, required this.tag_id, required this.createdAt, required this.updatedAt});

  	factory PlantTags.fromJson(Map<String, dynamic> json) {
    		return PlantTags(
      			id: json['id'],
      			plant_id: json['plant_id'],
			tag_id: json['tag_id'],
			createdAt: DateTime.parse(json['created_at']),
			updatedAt: DateTime.parse(json['updated_at']),
    		);
  	}

  	Map<String, dynamic> toJson() {
    		return {
      			'id': id,
      			'plant_id': plant_id,
			'tag_id': tag_id,
			'created_at': createdAt.toIso8601String(),
			'updated_at': updatedAt.toIso8601String(),
    		};
  	}
}
