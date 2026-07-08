class PetModel {
  final String id;
  final String ownerId;
  final String name;
  final String species;
  final String breed;
  final int? age;
  final double? weight;
  final String? photoUrl;
  final String? careInstructions;
  final DateTime? createdAt;

  PetModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.species,
    required this.breed,
    this.age,
    this.weight,
    this.photoUrl,
    this.careInstructions,
    this.createdAt,
  });

  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(
      id: map['id'] ?? '',
      ownerId: map['owner_id'] ?? '',
      name: map['name'] ?? '',
      species: map['species'] ?? '',
      breed: map['breed'] ?? '',
      age: map['age'],
      weight: map['weight'] != null ? (map['weight'] as num).toDouble() : null,
      photoUrl: map['photo_url'],
      careInstructions: map['care_instructions'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }
}