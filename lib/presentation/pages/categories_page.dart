// lib/presentation/pages/categories_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/entities/category.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';
import '../widgets/category_list_item.dart';
import 'add_edit_category_page.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddCategory(context),
        tooltip: l10n.addCategory,
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CategoriesLoaded) {
            return _buildCategoryList(context, state.categories);
          } else if (state is CategoryOperationFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CategoryBloc>().add(GetAllCategoriesEvent());
                    },
                    child: Text(l10n.confirm),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<CategoryBloc>().add(GetAllCategoriesEvent());
                },
                child: Text(l10n.loading),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, List<Category> categories) {
    final l10n = AppLocalizations.of(context)!;

    if (categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.noData),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _navigateToAddCategory(context),
              child: Text(l10n.addCategory),
            ),
          ],
        ),
      );
    }

    // Sort categories: default first, then alphabetically
    final sortedCategories = List<Category>.from(categories)
      ..sort((a, b) {
        if (a.isDefault && !b.isDefault) return -1;
        if (!a.isDefault && b.isDefault) return 1;
        return a.name.compareTo(b.name);
      });

    return RefreshIndicator(
      onRefresh: () async {
        context.read<CategoryBloc>().add(GetAllCategoriesEvent());
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(8.0),
        itemCount: sortedCategories.length,
        itemBuilder: (context, index) {
          final category = sortedCategories[index];
          return CategoryListItem(
            category: category,
            onTap: () => _navigateToEditCategory(context, category),
            onEdit: () => _navigateToEditCategory(context, category),
            onDelete: category.isDefault
                ? null
                : () => _showDeleteConfirmation(context, category),
          );
        },
      ),
    );
  }

  Future<void> _navigateToAddCategory(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditCategoryPage(),
      ),
    );

    if (result == true) {
      context.read<CategoryBloc>().add(GetAllCategoriesEvent());
    }
  }

  Future<void> _navigateToEditCategory(
      BuildContext context, Category category) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditCategoryPage(category: category),
      ),
    );

    if (result == true) {
      context.read<CategoryBloc>().add(GetAllCategoriesEvent());
    }
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, Category category) async {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.deleteConfirmation),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.deleteDescription),
              const SizedBox(height: 16),
              Text(
                'Warning: All expenses in this category will also be affected.',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context
                    .read<CategoryBloc>()
                    .add(DeleteCategoryEvent(category.id));
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }
}
