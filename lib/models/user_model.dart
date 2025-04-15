class User {
  String id;
  String username;
  String email;
  String password;
  DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert User object to a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create a User object from a Map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Create a copy of the User with some updated fields
  User copyWith({
    String? id,
    String? username,
    String? email,
    String? password,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
