/// Goal entity - represents a savings goal
class Goal {
  final String id;
  final String title;
  final double targetAmount;
  final double? currentAmount;
  final DateTime startDate;
  final DateTime endDate;
  final String? description;
  final bool achieved;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Goal({
    required this.id,
    required this.title,
    required this.targetAmount,
    this.currentAmount,
    required this.startDate,
    required this.endDate,
    this.description,
    required this.achieved,
    required this.createdAt,
    this.updatedAt,
  });

  /// Calculate progress percentage (0-100)
  double get progressPercentage {
    if (targetAmount == 0 || currentAmount == null) return 0;
    return (currentAmount! / targetAmount * 100).clamp(0, 100);
  }

  /// Calculate remaining amount needed
  double get remainingAmount {
    // if (currentAmount == null) return 0;
    return (targetAmount - currentAmount!).clamp(0, double.infinity);
  }

  /// Calculate days remaining
  int get daysRemaining {
    return endDate.difference(DateTime.now()).inDays;
  }

  /// Create a copy of this goal with modified fields
  Goal copyWith({
    String? id,
    String? title,
    double? targetAmount,
    double? currentAmount,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    bool? achieved,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      achieved: achieved ?? this.achieved,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Goal(id: $id, title: $title, target: $targetAmount, current: $currentAmount)';
}
