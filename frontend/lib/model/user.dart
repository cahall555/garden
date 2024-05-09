class User {
	final String id;
	final String userName;
  	final String firstName;
	final String lastName;
	final String email;
	final String password;
	final String passwordConfirmation
	final DateTime createdAt;
	final DateTime updatedAt;

  	Garden({required this.id, required this.userName, required this.firstName, required this.lastName, required this.email, required this.password, required this.passwordConfirmation, required this.createdAt, required this.updatedAt});

  	factory User.fromJson(Map<String, dynamic> json) {
    		return User(
      			id: json['id'],
      			userName: json['user_name'],
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
      			'user_name': userName,
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
