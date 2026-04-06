import 'package:finmate/domain/entities/goal.dart';

/// Goal model - extends Goal entity with JSON serialization
class GoalModel extends Goal {
  const GoalModel({
    required super.id,
    required super.title,
    required super.targetAmount,
    required super.currentAmount,
    required super.startDate,
    required super.endDate,
    super.description,
    required super.achieved,
    required super.createdAt,
    super.updatedAt,
  });

  /// Create a GoalModel from a Goal entity
  factory GoalModel.fromEntity(Goal goal) {
    return GoalModel(
      id: goal.id,
      title: goal.title,
      targetAmount: goal.targetAmount,
      currentAmount: goal.currentAmount,
      startDate: goal.startDate,
      endDate: goal.endDate,
      description: goal.description,
      achieved: goal.achieved,
      createdAt: goal.createdAt,
      updatedAt: goal.updatedAt,
    );
  }

  /// Create a GoalModel from JSON map
  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] as String,
      title: json['title'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num).toDouble(),
      startDate: DateTime.fromMillisecondsSinceEpoch(json['startDate'] as int),
      endDate: DateTime.fromMillisecondsSinceEpoch(json['endDate'] as int),
      description: json['description'] as String?,
      achieved: (json['achieved'] as int?) == 1 ? true : false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: json['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int)
          : null,
    );
  }

  /// Convert GoalModel to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'description': description,
      'achieved': achieved ? 1 : 0,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  /// Convert GoalModel to database row
  Map<String, dynamic> toDb() => toJson();

  /// Create a GoalModel from database row
  factory GoalModel.fromDb(Map<String, dynamic> json) => GoalModel.fromJson(json);
}
