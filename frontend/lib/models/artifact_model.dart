class Artifact {
  final int id;
  final String name;
  final String description;
  final String imageUrl;

  Artifact({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory Artifact.fromJson(Map<String, dynamic> json) {
    return Artifact(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
    );
  }
}
