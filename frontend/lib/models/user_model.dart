class User {
  final String id;
  final String username;
  final String email; // ✅ tambahin ini
  final int money;
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
      money: (num.tryParse(json['money'].toString()) ?? 0).toInt(),
      roles: json['roles'] ?? '',
    );
  }
}
