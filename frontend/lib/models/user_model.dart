class User {
  final String id;
  final String username;
  final double money;
  final String roles;

  User({
    required this.id,
    required this.username,
    required this.money,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      money: double.parse(json['money']),
      roles: json['roles'],
    );
  }
}
