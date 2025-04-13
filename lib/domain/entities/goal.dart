import 'package:equatable/equatable.dart';

class Goal extends Equatable {
  final String id;
  final String title;
  final double targetAmount;
  final double savedAmount;
  final DateTime startDate;
  final DateTime endDate;
  final String description;

  const Goal({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    required this.startDate,
    required this.endDate,
    required this.description,
  });

  double get progress => savedAmount / targetAmount;

  @override
  List<Object?> get props => [
        id,
        title,
        targetAmount,
        savedAmount,
        startDate,
        endDate,
        description,
      ];
}
