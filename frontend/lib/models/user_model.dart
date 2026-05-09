class UserModel {
  final String id;
  final String username;
  final String email;
  final double money;
  final String roles;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.money,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      money: double.tryParse(json['money']?.toString() ?? '0') ?? 0.0,
      roles: json['roles']?.toString() ?? '',
    );
  }
}
