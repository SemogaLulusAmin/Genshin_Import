import 'artifact_model.dart';

class ArtifactTransactionModel {
  final String userId;
  final String artifactId;
  final int stockPurchased;
  final DateTime createdAt;
  final ArtifactModel? artifactDetail;

  ArtifactTransactionModel({
    required this.userId,
    required this.artifactId,
    required this.stockPurchased,
    required this.createdAt,
    this.artifactDetail,
  });

  factory ArtifactTransactionModel.fromJson(Map<String, dynamic> json) {
    return ArtifactTransactionModel(
      userId: json['userID'] ?? json['userId'] ?? '',
      artifactId: json['artifactID'] ?? json['artifactId'] ?? '',
      stockPurchased: int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      createdAt: json['createdAt'] != null
          ? (DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now())
          : DateTime.now(),
      artifactDetail: json['artifact'] != null
          ? ArtifactModel.fromJson(json['artifact'])
          : null,
    );
  }
}
