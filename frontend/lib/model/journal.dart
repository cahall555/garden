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

  	Journal({required this.id, required this.title, required this.entry, required this.display_on_garden, this.image, required this.category, required this.plant_id, required this.createdAt, required this.updatedAt});

  	factory Journal.fromJson(Map<String, dynamic> json) {
    		return Journal(
      			id: json['id'],
      			title: json['title'],
      			entry: json['entry'],
			display_on_garden: json['display_on_garden'],
			image: json['image'],
			category: json['category'],
			plant_id: json['plant_id'],
			createdAt: DateTime.parse(json['created_at']),
			updatedAt: DateTime.parse(json['updated_at']),
    		);
  	}

  	Map<String, dynamic> toJson() {
    		return {
      			'id': id,
      			'title': title,
      			'entry': entry,
			'display_on_garden': display_on_garden,
			'image': image,
			'category': category,
			'plant_id': plant_id,
			'created_at': createdAt.toIso8601String(),
			'updated_at': updatedAt.toIso8601String(),
    		};
  	}
}
