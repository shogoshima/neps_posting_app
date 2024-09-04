class Role {
  final bool canAccessSensitiveInformation;
  final bool canManagePosts;
  final bool canManageUsers;
  final int id;
  final String name;

  Role({
    required this.canAccessSensitiveInformation,
    required this.canManagePosts,
    required this.canManageUsers,
    required this.id,
    required this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      canAccessSensitiveInformation: json['can_access_sensitive_information'],
      canManagePosts: json['can_manage_posts'],
      canManageUsers: json['can_manage_users'],
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'can_access_sensitive_information': canAccessSensitiveInformation,
      'can_manage_posts': canManagePosts,
      'can_manage_users': canManageUsers,
      'id': id,
      'name': name,
    };
  }
}

class User {
  final String username;
  final String email;
  final DateTime birthdate;
  String? password;
  int? id;
  Role? role;
  DateTime? createdAt;

  User({
    required this.username,
    required this.email,
    required this.birthdate,
    this.password,
    this.id,
    this.role,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      birthdate: DateTime.parse(json['birthdate']),
      createdAt: DateTime.parse(json['created_at']),
      email: json['email'],
      id: json['id'] ?? -1,
      role: json['role'] != null
          ? Role.fromJson(json['role'])
          : null, // Null if 'role' is not provided
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'birthdate': birthdate.toIso8601String(),
      'email': email,
      'password': password,
      'username': username,
    };
  }
}
