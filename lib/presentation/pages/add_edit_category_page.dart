// lib/presentation/pages/add_edit_category_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/constants/app_constants.dart';
import '../../core/util/input_validators.dart';
import '../../domain/entities/category.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_state.dart';
import '../bloc/category_form/category_form_bloc.dart';
import '../bloc/category_form/category_form_event.dart';
import '../bloc/category_form/category_form_state.dart';

class AddEditCategoryPage extends StatelessWidget {
  final Category? category;

  const AddEditCategoryPage({
    Key? key,
    this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryFormBloc(
        categoryBloc: context.read<CategoryBloc>(),
      )..add(InitializeCategoryFormEvent(category)),
      child: const _AddEditCategoryFormView(),
    );
  }
}

class _AddEditCategoryFormView extends StatefulWidget {
  const _AddEditCategoryFormView();

  @override
  State<_AddEditCategoryFormView> createState() =>
      _AddEditCategoryFormViewState();
}

class _AddEditCategoryFormViewState extends State<_AddEditCategoryFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Add listeners to update bloc on text changes
    _nameController.addListener(_onNameChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize text controllers from bloc state
    final state = context.read<CategoryFormBloc>().state;
    if (_nameController.text != state.name) {
      _nameController.text = state.name;
    }
  }

  void _onNameChanged() {
    context.read<CategoryFormBloc>().add(
          ChangeCategoryNameEvent(_nameController.text),
        );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<CategoryFormBloc, CategoryFormState>(
      listenWhen: (previous, current) =>
          previous.isSubmitting && !current.isSubmitting,
      listener: (context, state) {
        // Nothing to do here - we'll handle success/failure via the CategoryBloc listener
      },
      builder: (context, formState) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
                formState.isEditing ? l10n.editCategory : l10n.addCategory),
          ),
          body: BlocListener<CategoryBloc, CategoryState>(
            listener: (context, categoryState) {
              if (categoryState is CategoryOperationSuccess) {
                Navigator.pop(context, true);
              } else if (categoryState is CategoryOperationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(categoryState.message),
                    backgroundColor: Colors.red,
                  ),
                );
                context.read<CategoryFormBloc>().add(
                      const SubmittingCategoryFormEvent(),
                    );
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
                      enabled: !formState.isDefault,
                    ),
                    const SizedBox(height: 24),

                    // Category Color
                    _buildColorPicker(l10n, formState),
                    const SizedBox(height: 24),

                    // Category Icon
                    _buildIconPicker(l10n, formState),
                    const SizedBox(height: 24),

                    // Save Button
                    ElevatedButton(
                      onPressed: formState.isSubmitting ||
                              formState.isDefault ||
                              !formState.isFormValid
                          ? null
                          : _submitForm,
                      child: formState.isSubmitting
                          ? const CircularProgressIndicator()
                          : Text(formState.isEditing
                              ? l10n.save
                              : l10n.addCategory),
                    ),

                    if (formState.isEditing && !formState.isDefault) ...[
                      const SizedBox(height: 16),
                      // Delete Button
                      OutlinedButton(
                        onPressed:
                            formState.isSubmitting ? null : _deleteCategory,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: Text(l10n.delete),
                      ),
                    ],

                    if (formState.isDefault) ...[
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
      },
    );
  }

  Widget _buildColorPicker(AppLocalizations l10n, CategoryFormState formState) {
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
              final isSelected = color.value == formState.color.value;

              return GestureDetector(
                onTap: formState.isDefault
                    ? null
                    : () {
                        context.read<CategoryFormBloc>().add(
                              ChangeCategoryColorEvent(color),
                            );
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
                      ? const Icon(
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

  Widget _buildIconPicker(AppLocalizations l10n, CategoryFormState formState) {
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
              final isSelected = icon.codePoint == formState.icon.codePoint;

              return GestureDetector(
                onTap: formState.isDefault
                    ? null
                    : () {
                        context.read<CategoryFormBloc>().add(
                              ChangeCategoryIconEvent(icon),
                            );
                      },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? formState.color.withOpacity(0.2) : null,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected
                        ? Border.all(
                            color: formState.color,
                            width: 2,
                          )
                        : null,
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? formState.color : Colors.grey[600],
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
      context.read<CategoryFormBloc>().add(const SubmitCategoryFormEvent());
    }
  }

  void _deleteCategory() {
    final categoryId = context.read<CategoryFormBloc>().state.id;
    if (categoryId == null) return;

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
                context
                    .read<CategoryFormBloc>()
                    .add(DeleteCategoryEvent(categoryId));
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
