// lib/presentation/pages/add_edit_category_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/util/input_validators.dart';
import '../../domain/entities/category.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';

class AddEditCategoryPage extends StatefulWidget {
  final Category? category;

  const AddEditCategoryPage({
    Key? key,
    this.category,
  }) : super(key: key);

  @override
  State<AddEditCategoryPage> createState() => _AddEditCategoryPageState();
}

class _AddEditCategoryPageState extends State<AddEditCategoryPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  Color _selectedColor = AppConstants.categoryColors.first;
  IconData _selectedIcon = AppConstants.categoryIcons.first;

  bool _isEditing = false;
  bool _isSubmitting = false;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.category != null;

    if (_isEditing) {
      final category = widget.category!;
      _nameController.text = category.name;
      _selectedColor = category.color;
      _selectedIcon = category.icon;
      _isDefault = category.isDefault;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editCategory : l10n.addCategory),
      ),
      body: BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoryOperationSuccess) {
            Navigator.pop(context, true);
          } else if (state is CategoryOperationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
            setState(() {
              _isSubmitting = false;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Category Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l10n.categoryName,
                    border: const OutlineInputBorder(),
                  ),
                  validator: InputValidators.validateName,
                  enabled: !_isDefault,
                ),
                const SizedBox(height: 24),

                // Category Color
                _buildColorPicker(l10n),
                const SizedBox(height: 24),

                // Category Icon
                _buildIconPicker(l10n),
                const SizedBox(height: 24),

                // Save Button
                ElevatedButton(
                  onPressed: _isSubmitting || _isDefault ? null : _submitForm,
                  child: _isSubmitting
                      ? const CircularProgressIndicator()
                      : Text(_isEditing ? l10n.save : l10n.addCategory),
                ),

                if (_isEditing && !_isDefault) ...[
                  const SizedBox(height: 16),
                  // Delete Button
                  OutlinedButton(
                    onPressed: _isSubmitting ? null : _deleteCategory,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: Text(l10n.delete),
                  ),
                ],

                if (_isDefault) ...[
                  const SizedBox(height: 16),
                  // Default Category Notice
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.info, color: Colors.amber),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Default Category',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Default categories cannot be edited or deleted to ensure the app functions correctly.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorPicker(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.categoryColor,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: GridView.builder(
            padding: const EdgeInsets.all(4),
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: AppConstants.categoryColors.length,
            itemBuilder: (context, index) {
              final color = AppConstants.categoryColors[index];
              final isSelected = color.value == _selectedColor.value;

              return GestureDetector(
                onTap: _isDefault
                    ? null
                    : () {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(
                            color: Theme.of(context).colorScheme.onBackground,
                            width: 2,
                          )
                        : null,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                        )
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildIconPicker(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.categoryIcon,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: AppConstants.categoryIcons.length,
            itemBuilder: (context, index) {
              final icon = AppConstants.categoryIcons[index];
              final isSelected = icon.codePoint == _selectedIcon.codePoint;

              return GestureDetector(
                onTap: _isDefault
                    ? null
                    : () {
                        setState(() {
                          _selectedIcon = icon;
                        });
                      },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? _selectedColor.withOpacity(0.2) : null,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected
                        ? Border.all(
                            color: _selectedColor,
                            width: 2,
                          )
                        : null,
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? _selectedColor : Colors.grey[600],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Create category entity
      final category = Category(
        id: _isEditing ? widget.category!.id : const Uuid().v4(),
        name: _nameController.text,
        color: _selectedColor,
        icon: _selectedIcon,
        isDefault: false,
      );

      // Save or update category
      if (_isEditing) {
        context.read<CategoryBloc>().add(UpdateCategoryEvent(category));
      } else {
        context.read<CategoryBloc>().add(AddCategoryEvent(category));
      }
    }
  }

  void _deleteCategory() {
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.deleteConfirmation),
          content: Text(l10n.deleteDescription),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isSubmitting = true;
                });
                context.read<CategoryBloc>().add(
                      DeleteCategoryEvent(widget.category!.id),
                    );
              },
              child: Text(
                l10n.delete,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
