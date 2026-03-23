class UserModel {
  final String userId;
  final String username;
  final String email;
  final String provider;
  final String? bearerToken;
  final double money;
  final String roles;
  final DateTime? createdAt;

  UserModel({
    required this.userId,
    required this.username,
    required this.email,
    required this.provider,
    this.bearerToken,
    required this.money,
    required this.roles,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userID'] ?? json['userId'] ?? json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      provider: json['provider'] ?? '',
      bearerToken: json['bearer_token'] ?? json['token'],
      money: double.tryParse(json['money']?.toString() ?? '0') ?? 0.0,
      roles: json['roles'] ?? 'user',
      createdAt: json['createdAt'] != null
          ? (DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now())
          : null,
    );
  }
}
