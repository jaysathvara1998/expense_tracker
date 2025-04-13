import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/expense_model.dart';

abstract class ExpenseDataSource {
  Future<List<ExpenseModel>> getAllExpenses();
  Future<List<ExpenseModel>> getExpensesByDateRange(
      DateTime start, DateTime end);
  Future<List<ExpenseModel>> getExpensesByCategory(String categoryId);
  Future<ExpenseModel> getExpenseById(String id);
  Future<void> addExpense(ExpenseModel expense);
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);
}

class ExpenseDataSourceImpl implements ExpenseDataSource {
  final FirebaseFirestore firestore;

  ExpenseDataSourceImpl({required this.firestore});

  @override
  Future<List<ExpenseModel>> getAllExpenses() async {
    final expensesCollection = await firestore.collection('expenses').get();
    return expensesCollection.docs
        .map((doc) => ExpenseModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  @override
  Future<List<ExpenseModel>> getExpensesByDateRange(
      DateTime start, DateTime end) async {
    final expensesCollection = await firestore
        .collection('expenses')
        .where('date', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('date', isLessThanOrEqualTo: end.toIso8601String())
        .get();

    return expensesCollection.docs
        .map((doc) => ExpenseModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  @override
  Future<List<ExpenseModel>> getExpensesByCategory(String categoryId) async {
    final expensesCollection = await firestore
        .collection('expenses')
        .where('categoryId', isEqualTo: categoryId)
        .get();

    return expensesCollection.docs
        .map((doc) => ExpenseModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  @override
  Future<ExpenseModel> getExpenseById(String id) async {
    final expenseDoc = await firestore.collection('expenses').doc(id).get();
    if (!expenseDoc.exists) {
      throw Exception('Expense not found');
    }
    return ExpenseModel.fromJson({...expenseDoc.data()!, 'id': expenseDoc.id});
  }

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await firestore
        .collection('expenses')
        .doc(expense.id)
        .set(expense.toJson());
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await firestore
        .collection('expenses')
        .doc(expense.id)
        .update(expense.toJson());
  }

  @override
  Future<void> deleteExpense(String id) async {
    await firestore.collection('expenses').doc(id).delete();
  }
}
