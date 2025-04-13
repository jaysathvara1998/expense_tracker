import '../../domain/entities/loan.dart';

class LoanModel extends Loan {
  const LoanModel({
    required String id,
    required String personName,
    required double amount,
    required DateTime date,
    DateTime? dueDate,
    required String description,
    bool hasReminder = false,
    required LoanType type,
    bool isSettled = false,
  }) : super(
          id: id,
          personName: personName,
          amount: amount,
          date: date,
          dueDate: dueDate,
          description: description,
          hasReminder: hasReminder,
          type: type,
          isSettled: isSettled,
        );

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['id'],
      personName: json['personName'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      description: json['description'],
      hasReminder: json['hasReminder'] ?? false,
      type: LoanType.values[json['type']],
      isSettled: json['isSettled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personName': personName,
      'amount': amount,
      'date': date.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'description': description,
      'hasReminder': hasReminder,
      'type': type.index,
      'isSettled': isSettled,
    };
  }

  factory LoanModel.fromEntity(Loan loan) {
    return LoanModel(
      id: loan.id,
      personName: loan.personName,
      amount: loan.amount,
      date: loan.date,
      dueDate: loan.dueDate,
      description: loan.description,
      hasReminder: loan.hasReminder,
      type: loan.type,
      isSettled: loan.isSettled,
    );
  }
}
