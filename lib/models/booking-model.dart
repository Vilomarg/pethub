class BookingModel {
  final String id;
  final String ownerId;
  final String sitterId;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final double totalAmount;
  final DateTime? createdAt;

  BookingModel({
    required this.id,
    required this.ownerId,
    required this.sitterId,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.totalAmount,
    this.createdAt,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'] ?? '',
      ownerId: map['owner_id'] ?? '',
      sitterId: map['sitter_id'] ?? '',
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      status: map['status'] ?? 'pendente',
      totalAmount: map['total_amount'] != null ? (map['total_amount'] as num).toDouble() : 0.0,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }
}