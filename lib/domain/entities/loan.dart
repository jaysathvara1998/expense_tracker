import 'package:equatable/equatable.dart';

enum LoanType { borrowed, lent }

class Loan extends Equatable {
  final String id;
  final String personName;
  final double amount;
  final DateTime date;
  final DateTime? dueDate;
  final String description;
  final bool hasReminder;
  final LoanType type;
  final bool isSettled;

  const Loan({
    required this.id,
    required this.personName,
    required this.amount,
    required this.date,
    this.dueDate,
    required this.description,
    this.hasReminder = false,
    required this.type,
    this.isSettled = false,
  });

  @override
  List<Object?> get props => [
        id,
        personName,
        amount,
        date,
        dueDate,
        description,
        hasReminder,
        type,
        isSettled,
      ];
}
