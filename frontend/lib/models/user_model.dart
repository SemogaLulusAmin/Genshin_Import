// class User {
//   final String id;
//   final String username;
//   final double money;
//   final String roles;

//   User({
//     required this.id,
//     required this.username,
//     required this.money,
//     required this.roles,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       username: json['username'],
//       money: json['money'].toDouble(),
//       roles: json['roles'],
//     );
//   }
// }

class User {
  final String id;
  final String username;
  final String email; // ✅ tambahin ini
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
      email: json['email'] ?? '', // ✅ ambil dari DB
      money: (json['money'] ?? 0).toDouble(),
      roles: json['roles'] ?? '',
    );
  }
}
