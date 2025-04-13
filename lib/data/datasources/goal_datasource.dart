import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/goal_model.dart';

abstract class GoalDataSource {
  Future<List<GoalModel>> getAllGoals();
  Future<GoalModel> getGoalById(String id);
  Future<void> addGoal(GoalModel goal);
  Future<void> updateGoal(GoalModel goal);
  Future<void> deleteGoal(String id);
}

class GoalDataSourceImpl implements GoalDataSource {
  final FirebaseFirestore firestore;

  GoalDataSourceImpl({required this.firestore});

  @override
  Future<List<GoalModel>> getAllGoals() async {
    final goalsCollection = await firestore.collection('goals').get();
    return goalsCollection.docs
        .map((doc) => GoalModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  @override
  Future<GoalModel> getGoalById(String id) async {
    final goalDoc = await firestore.collection('goals').doc(id).get();
    if (!goalDoc.exists) {
      throw Exception('Goal not found');
    }
    return GoalModel.fromJson({...goalDoc.data()!, 'id': goalDoc.id});
  }

  @override
  Future<void> addGoal(GoalModel goal) async {
    await firestore.collection('goals').doc(goal.id).set(goal.toJson());
  }

  @override
  Future<void> updateGoal(GoalModel goal) async {
    await firestore.collection('goals').doc(goal.id).update(goal.toJson());
  }

  @override
  Future<void> deleteGoal(String id) async {
    await firestore.collection('goals').doc(id).delete();
  }
}
