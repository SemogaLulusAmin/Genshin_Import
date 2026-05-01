class User {
  final String id;
  final String username;
  final String email;
  final String provider;
  final String bearerToken;
  final double money;
  final String roles;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.provider,
    required this.bearerToken,
    required this.money,
    required this.roles,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      provider: json['provider'],
      bearerToken: json['bearerToken'],
      money: json['money'].toDouble(),
      roles: json['roles'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
