class User {
  final String id;
  final String username;
  final String email; 
  final double money;
  final String roles;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.money,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '', 
      money: (json['money'] ?? 0).toDouble(),
      roles: json['roles'] ?? '',
    );
  }
}
