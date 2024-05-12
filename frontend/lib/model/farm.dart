class Farm {
	final String id;
	final String name;
  	final String description;
	final String account_id;
	final DateTime createdAt;
	final DateTime updatedAt;

  	Farm({required this.id, required this.name, required this.description, required this.account_id, required this.createdAt, required this.updatedAt});

  	factory Farm.fromJson(Map<String, dynamic> json) {
    		return Farm(
      			id: json['id'],
      			name: json['name'],
      			description: json['description'],
			account_id: json['account_id'],
			createdAt: DateTime.parse(json['created_at']),
			updatedAt: DateTime.parse(json['updated_at']),
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
    		};
  	}
}
