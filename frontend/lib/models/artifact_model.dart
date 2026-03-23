class ArtifactModel {
  final String artifactId;
  final String name;
  final String setName;
  final String maxRarity;
  final int stock;
  final String imageUrl;
  final double price;
  final String? twoPieceBonus;
  final String? fourPieceBonus;

  ArtifactModel({
    required this.artifactId,
    required this.name,
    required this.setName,
    required this.maxRarity,
    required this.stock,
    required this.imageUrl,
    required this.price,
    this.twoPieceBonus,
    this.fourPieceBonus,
  });

  factory ArtifactModel.fromJson(Map<String, dynamic> json) {
    return ArtifactModel(
      artifactId: json['artifactID'] ?? json['artifactId'] ?? json['id'] ?? '',
      name: json['name'] ?? 'Unknown Artifact',
      setName: json['set_name'] ?? json['setName'] ?? '',
      maxRarity: json['max_rarity'] ?? json['maxRarity'] ?? '5',
      stock: int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      twoPieceBonus: json['2-piece_bonus'] ?? json['twoPieceBonus'],
      fourPieceBonus: json['4-piece_bonus'] ?? json['fourPieceBonus'],
    );
  }
}
