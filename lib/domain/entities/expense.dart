import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String id;
  final double amount;
  final DateTime date;
  final String categoryId;
  final String description;
  final String location;
  final String paymentMode;

  const Expense({
    required this.id,
    required this.amount,
    required this.date,
    required this.categoryId,
    required this.description,
    required this.location,
    required this.paymentMode,
  });

  @override
  List<Object?> get props => [
        id,
        amount,
        date,
        categoryId,
        description,
        location,
        paymentMode,
      ];
}
