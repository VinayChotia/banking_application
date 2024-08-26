class User {
  String firstName;
  String lastName;
  String email;
  String password;
  String password2;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.password2,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      password: json['password'],
      password2: json['password2'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'password2': password2,
    };
  }
}
