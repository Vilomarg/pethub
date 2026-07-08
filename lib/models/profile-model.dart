class ProfileModel {
  final String id;
  final String fullName;
  final String? avatarUrl;
  final String role; 
  final String? description;
  final double? hourlyRate;
  final double? addressLat;
  final double? addressLng;
  final double? averageRating;
  final String? stripeCustomerId;
  final DateTime? createdAt;

  ProfileModel({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    required this.role,
    this.description,
    this.hourlyRate,
    this.addressLat,
    this.addressLng,
    this.averageRating,
    this.stripeCustomerId,
    this.createdAt,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] ?? '',
      fullName: map['full_name'] ?? '',
      avatarUrl: map['avatar_url'],
      role: map['role'] ?? 'tutor',
      description: map['description'],
      hourlyRate: map['hourly_rate'] != null ? (map['hourly_rate'] as num).toDouble() : null,
      addressLat: map['address_lat'] != null ? (map['address_lat'] as num).toDouble() : null,
      addressLng: map['address_lng'] != null ? (map['address_lng'] as num).toDouble() : null,
      averageRating: map['average_rating'] != null ? (map['average_rating'] as num).toDouble() : null,
      stripeCustomerId: map['stripe_customer_id'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }
}