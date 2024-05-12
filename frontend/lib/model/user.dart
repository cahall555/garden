class User {
	final String id;
  	final String? firstName;
	final String? lastName;
	final String email;
	final String password;
	final String? passwordConfirmation;
	final DateTime createdAt;
	final DateTime updatedAt;

  	User({required this.id, this.firstName, this.lastName, required this.email, required this.password, this.passwordConfirmation, required this.createdAt, required this.updatedAt});

  	factory User.fromJson(Map<String, dynamic> json) {
    		return User(
      			id: json['id'],
      			firstName: json['first_name'],
			lastName: json['last_name'],
			email: json['email'],
			password: json['password'],
			passwordConfirmation: json['password_confirmation'],
			createdAt: DateTime.parse(json['created_at']),
			updatedAt: DateTime.parse(json['updated_at']),
    		);
  	}

  	Map<String, dynamic> toJson() {
    		return {
      			'id': id,
      			'first_name': firstName,
			'last_name': lastName,
			'email': email,
			'password': password,
			'password_confirmation': passwordConfirmation,
			'created_at': createdAt.toIso8601String(),
			'updated_at': updatedAt.toIso8601String(),
    		};
  	}
}
