import 'plant.dart';

class Tag {
	final String id;
	final String name;
	final DateTime createdAt;
	final DateTime updatedAt;

  	Tag({required this.id, required this.name, required this.createdAt, required this.updatedAt});

  	factory Tag.fromJson(Map<String, dynamic> json) {
    		return Tag(
      			id: json['id'],
      			name: json['name'],
			createdAt: DateTime.parse(json['created_at']),
			updatedAt: DateTime.parse(json['updated_at']),
    		);
  	}

  	Map<String, dynamic> toJson() {
    		return {
      			'id': id,
      			'name': name,
			'created_at': createdAt.toIso8601String(),
			'updated_at': updatedAt.toIso8601String(),
    		};
  	}
}
