class Account {
	final String id;
	final String stratification;
	final String plan;
	final DateTime createdAt;
	final DateTime updatedAt;

  	Account({required this.id, required this.stratification, required this.plan, required this.createdAt, required this.updatedAt});

  	factory Account.fromJson(Map<String, dynamic> json) {
		if (json == null) {
     		   throw ArgumentError("JSON data must not be null");
    		}
    		return Account(
      			id: json['id'] ?? '',
      			stratification: json['stratification'] ?? '',
      			plan: json['plan'] ?? '',
			createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
			updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
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
