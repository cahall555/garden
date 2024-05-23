import 'plant.dart';

class Tag {
	final String id;
	final String name;
	final List<Plant>? related_plants;
	final String account_id;
	final DateTime createdAt;
	final DateTime updatedAt;

  	Tag({required this.id, required this.name, this.related_plants, required this.account_id, required this.createdAt, required this.updatedAt});

  	factory Tag.fromJson(Map<String, dynamic> json) {
    		return Tag(
      			id: json['id'],
      			name: json['name'],
			related_plants: json['related_plants'] != null ? List<Plant>.from(json['related_plants'].map((x) => Plant.fromJson(x))) : null,
			account_id: json['account_id'],
			createdAt: DateTime.parse(json['created_at']),
			updatedAt: DateTime.parse(json['updated_at']),
    		);
  	}

  	Map<String, dynamic> toJson() {
    		return {
      			'id': id,
      			'name': name,
			'related_plants': related_plants?.map((x) => x.toJson()).toList(),
			'account_id': account_id,
			'created_at': createdAt.toIso8601String(),
			'updated_at': updatedAt.toIso8601String(),
    		};
  	}
}
