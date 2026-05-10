abstract class Inventory {
  final String id;
  final String name;
  final String imageUrl;
  final String rarity;
  final String subtitle;
  final int totalOwned;
  final String itemType;

  Inventory({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rarity,
    required this.subtitle,
    required this.totalOwned,
    required this.itemType,
  });

  String get formattedName {
    if (name.isEmpty) return name;

    return name
        .split('-') // Memecah string berdasarkan tanda "-"
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
              : word,
        )
        .join(' ');
  }
}
