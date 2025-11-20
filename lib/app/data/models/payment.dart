class Transaction {
  const Transaction({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.status,
    required this.createdAt,
  });

  /// Create Transaction from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    amount: json['amount'] as String,
    date: json['date'] as String,
    status: json['status'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
  );
  final String id;
  final String title;
  final String description;
  final String amount;
  final String date;
  final String status;
  final DateTime createdAt;

  /// Convert Transaction to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'amount': amount,
    'date': date,
    'status': status,
    'created_at': createdAt.toIso8601String(),
  };

  /// Create a copy of Transaction with updated fields
  Transaction copyWith({
    String? id,
    String? title,
    String? description,
    String? amount,
    String? date,
    String? status,
    DateTime? createdAt,
  }) => Transaction(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transaction &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Transaction(id: $id, title: $title, amount: $amount, status: $status)';
}
