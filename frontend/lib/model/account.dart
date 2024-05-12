class Account {
	final String id;
	final String stratification;
	final String plan;
	final DateTime createdAt;
	final DateTime updatedAt;

  	Account({required this.id, required this.stratification, required this.plan, required this.createdAt, required this.updatedAt});

  	factory Account.fromJson(Map<String, dynamic> json) {
    		return Account(
      			id: json['id'],
      			stratification: json['stratification'],
      			plan: json['plan'],
			createdAt: DateTime.parse(json['created_at']),
			updatedAt: DateTime.parse(json['updated_at']),
    		);
  	}

  	Map<String, dynamic> toJson() {
    		return {
      			'id': id,
      			'stratification': stratification,
      			'plan': plan,
			'created_at': createdAt.toIso8601String(),
			'updated_at': updatedAt.toIso8601String(),
    		};
  	}
}
