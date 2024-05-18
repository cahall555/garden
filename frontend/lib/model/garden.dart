import 'plant.dart';
import 'apis/plant_api.dart';

class Garden {
	final String id;
	final String name;
  	final String description;
	final String account_id;
	final DateTime createdAt;
	final DateTime updatedAt;
	final List<Plant>?plants;

  	Garden({required this.id, required this.name, required this.description, required this.account_id, required this.createdAt, required this.updatedAt, this.plants});

  	factory Garden.fromJson(Map<String, dynamic> json) {
    		return Garden(
      			id: json['id'],
      			name: json['name'],
      			description: json['description'],
			account_id: json['account_id'],
			createdAt: DateTime.parse(json['created_at']),
			updatedAt: DateTime.parse(json['updated_at']),
			plants: json['plants'] !=null ? (json['plants'] as List).map((i) => Plant.fromJson(i)).toList() : null,
    		);
  	}

  	Map<String, dynamic> toJson() {
    		return {
      			'id': id,
      			'name': name,
      			'description': description,
			'account_id': account_id,
			'created_at': createdAt.toIso8601String(),
			'updated_at': updatedAt.toIso8601String(),
			'plants': plants?.map((plant) => plant.toJson()).toList(),
    		};
  	}

	set name(String newName) {
		this.name = newName;
	}

	set description(String newDescription) {
		this.description = newDescription;
	}
}
