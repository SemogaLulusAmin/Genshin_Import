import 'weapon_model.dart';

class WeaponTransactionModel {
  final String userId;
  final String weaponId;
  final int stockPurchased;
  final DateTime createdAt;
  final WeaponModel? weaponDetail;

  WeaponTransactionModel({
    required this.userId,
    required this.weaponId,
    required this.stockPurchased,
    required this.createdAt,
    this.weaponDetail,
  });

  factory WeaponTransactionModel.fromJson(Map<String, dynamic> json) {
    return WeaponTransactionModel(
      userId: json['userID'] ?? json['userId'] ?? '',
      weaponId: json['weaponID'] ?? json['weaponId'] ?? '',
      stockPurchased: int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      createdAt: json['createdAt'] != null
          ? (DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now())
          : DateTime.now(),
      weaponDetail: json['weapon'] != null
          ? WeaponModel.fromJson(json['weapon'])
          : null,
    );
  }
}
