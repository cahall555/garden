class UserAccounts {
	final String id;
	final String user_id;
	final String account_id;
	final DateTime createdAt;
	final DateTime updatedAt;

  	UserAccounts({required this.id, required this.user_id, required this.account_id, required this.createdAt, required this.updatedAt});

  	factory UserAccounts.fromJson(Map<String, dynamic> json) {
    		return UserAccounts(
      			id: json['id'],
      			user_id: json['user_id'],
			account_id: json['account_id'],
			createdAt: DateTime.parse(json['created_at']),
			updatedAt: DateTime.parse(json['updated_at']),
    		);
  	}

  	Map<String, dynamic> toJson() {
    		return {
      			'id': id,
      			'user_id': user_id,
			'account_id': account_id,
			'created_at': createdAt.toIso8601String(),
			'updated_at': updatedAt.toIso8601String(),
    		};
  	}
}
