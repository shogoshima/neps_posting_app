class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final DateTime birthDate;

  User({
    required this.id, 
    required this.name, 
    required this.email, 
    required this.password,
    required this.birthDate,
    });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      birthDate: DateTime.parse(json['birthDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'birthDate': birthDate.toIso8601String(),
    };
  }
}