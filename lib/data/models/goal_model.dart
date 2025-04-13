import '../../domain/entities/goal.dart';

class GoalModel extends Goal {
  const GoalModel({
    required String id,
    required String title,
    required double targetAmount,
    required double savedAmount,
    required DateTime startDate,
    required DateTime endDate,
    required String description,
  }) : super(
          id: id,
          title: title,
          targetAmount: targetAmount,
          savedAmount: savedAmount,
          startDate: startDate,
          endDate: endDate,
          description: description,
        );

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'],
      title: json['title'],
      targetAmount: json['targetAmount'].toDouble(),
      savedAmount: json['savedAmount'].toDouble(),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'description': description,
    };
  }

  factory GoalModel.fromEntity(Goal goal) {
    return GoalModel(
      id: goal.id,
      title: goal.title,
      targetAmount: goal.targetAmount,
      savedAmount: goal.savedAmount,
      startDate: goal.startDate,
      endDate: goal.endDate,
      description: goal.description,
    );
  }
}
