import 'inventory_model.dart';

class InventoryArtifact extends Inventory {
  final String artifactID;
  final String setName;
  final String maxRarity;
  final String imageUrl;
  final double price;
  final String pieceBonus2;
  final String pieceBonus4;

  InventoryArtifact({
    required this.artifactID,
    required String name,
    required this.setName,
    required this.maxRarity,
    required int totalOwned,
    required this.imageUrl,
    required this.price,
    required this.pieceBonus2,
    required this.pieceBonus4,
  }) : super(
          id: artifactID,
          name: name,
          imageUrl: imageUrl,
          rarity: maxRarity,
          subtitle: setName,
          totalOwned: totalOwned,
          itemType: 'Artifact',
        );

  factory InventoryArtifact.fromJson(Map<String, dynamic> json) {
    return InventoryArtifact(
      artifactID: json['artifactID'],
      name: json['name'] ?? '',
      setName: json['set_name'] ?? '',
      maxRarity: json['max_rarity']?.toString() ?? '1',
      totalOwned: num.parse((json['totalOwned'] ?? 0).toString()).toInt(),
      imageUrl: json['image_url'] ?? '',
      price: double.parse((json['price'] ?? 0).toString()),
      pieceBonus2: json['piece_bonus_2'] ?? '',
      pieceBonus4: json['piece_bonus_4'] ?? '',
    );
  }
}