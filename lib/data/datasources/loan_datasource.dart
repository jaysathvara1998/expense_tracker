import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/loan_model.dart';

abstract class LoanDataSource {
  Future<List<LoanModel>> getAllLoans();
  Future<LoanModel> getLoanById(String id);
  Future<void> addLoan(LoanModel loan);
  Future<void> updateLoan(LoanModel loan);
  Future<void> deleteLoan(String id);
  Future<List<LoanModel>> getLoansWithReminders();
}

class LoanDataSourceImpl implements LoanDataSource {
  final FirebaseFirestore firestore;

  LoanDataSourceImpl({required this.firestore});

  @override
  Future<List<LoanModel>> getAllLoans() async {
    final loansCollection = await firestore.collection('loans').get();
    return loansCollection.docs
        .map((doc) => LoanModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  @override
  Future<LoanModel> getLoanById(String id) async {
    final loanDoc = await firestore.collection('loans').doc(id).get();
    if (!loanDoc.exists) {
      throw Exception('Loan not found');
    }
    return LoanModel.fromJson({...loanDoc.data()!, 'id': loanDoc.id});
  }

  @override
  Future<void> addLoan(LoanModel loan) async {
    await firestore.collection('loans').doc(loan.id).set(loan.toJson());
  }

  @override
  Future<void> updateLoan(LoanModel loan) async {
    await firestore.collection('loans').doc(loan.id).update(loan.toJson());
  }

  @override
  Future<void> deleteLoan(String id) async {
    await firestore.collection('loans').doc(id).delete();
  }

  @override
  Future<List<LoanModel>> getLoansWithReminders() async {
    final loansCollection = await firestore
        .collection('loans')
        .where('hasReminder', isEqualTo: true)
        .where('isSettled', isEqualTo: false)
        .get();

    return loansCollection.docs
        .map((doc) => LoanModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }
}
