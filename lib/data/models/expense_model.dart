import '../../domain/entities/expense.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    required String id,
    required double amount,
    required DateTime date,
    required String categoryId,
    required String description,
    required String location,
    required String paymentMode,
  }) : super(
          id: id,
          amount: amount,
          date: date,
          categoryId: categoryId,
          description: description,
          location: location,
          paymentMode: paymentMode,
        );

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      categoryId: json['categoryId'],
      description: json['description'],
      location: json['location'],
      paymentMode: json['paymentMode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'categoryId': categoryId,
      'description': description,
      'location': location,
      'paymentMode': paymentMode,
    };
  }

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      amount: expense.amount,
      date: expense.date,
      categoryId: expense.categoryId,
      description: expense.description,
      location: expense.location,
      paymentMode: expense.paymentMode,
    );
  }
}
