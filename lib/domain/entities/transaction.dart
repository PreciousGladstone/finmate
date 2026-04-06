/// Transaction entity - represents a financial transaction
class Transaction {
  final String id;
  final double amount;
  final String type; // 'Income' or 'Expense'
  final String category;
  final DateTime date;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create a copy of this transaction with modified fields
  Transaction copyWith({
    String? id,
    double? amount,
    String? type,
    String? category,
    DateTime? date,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Transaction(id: $id, amount: $amount, type: $type, category: $category)';
}
