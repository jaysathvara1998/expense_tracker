import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';

abstract class CategoryDataSource {
  Future<List<CategoryModel>> getAllCategories();
  Future<CategoryModel> getCategoryById(String id);
  Future<void> addCategory(CategoryModel category);
  Future<void> updateCategory(CategoryModel category);
  Future<void> deleteCategory(String id);
}

class CategoryDataSourceImpl implements CategoryDataSource {
  final FirebaseFirestore firestore;

  CategoryDataSourceImpl({required this.firestore});

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    final categoriesCollection = await firestore.collection('categories').get();
    return categoriesCollection.docs
        .map((doc) => CategoryModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  @override
  Future<CategoryModel> getCategoryById(String id) async {
    final categoryDoc = await firestore.collection('categories').doc(id).get();
    if (!categoryDoc.exists) {
      throw Exception('Category not found');
    }
    return CategoryModel.fromJson(
        {...categoryDoc.data()!, 'id': categoryDoc.id});
  }

  @override
  Future<void> addCategory(CategoryModel category) async {
    await firestore
        .collection('categories')
        .doc(category.id)
        .set(category.toJson());
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    await firestore
        .collection('categories')
        .doc(category.id)
        .update(category.toJson());
  }

  @override
  Future<void> deleteCategory(String id) async {
    await firestore.collection('categories').doc(id).delete();
  }
}
