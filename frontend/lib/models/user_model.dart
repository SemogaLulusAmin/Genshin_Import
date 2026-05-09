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
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '', 
      money: double.tryParse(json['money']?.toString() ?? '0') ?? 0.0,
      roles: json['roles']?.toString() ?? '',
    );
  }
}
