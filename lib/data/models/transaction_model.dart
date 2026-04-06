import 'package:finmate/domain/entities/transaction.dart';

/// Transaction model - extends Transaction entity with JSON serialization
class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.amount,
    required super.type,
    required super.category,
    required super.date,
    super.notes,
    required super.createdAt,
    super.updatedAt,
  });

  /// Create a TransactionModel from a Transaction entity
  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      amount: transaction.amount,
      type: transaction.type,
      category: transaction.category,
      date: transaction.date,
      notes: transaction.notes,
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
    );
  }

  /// Create a TransactionModel from JSON map
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      category: json['category'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
      notes: json['notes'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: json['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int)
          : null,
    );
  }

  /// Convert TransactionModel to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'category': category,
      'date': date.millisecondsSinceEpoch,
      'notes': notes,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  /// Convert TransactionModel to database row
  Map<String, dynamic> toDb() => toJson();

  /// Create a TransactionModel from database row
  factory TransactionModel.fromDb(Map<String, dynamic> json) =>
      TransactionModel.fromJson(json);
}
