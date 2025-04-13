import 'package:flutter/material.dart';

import '../../../domain/entities/category.dart';

class CategoryListItem extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CategoryListItem({
    Key? key,
    required this.category,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: category.color,
          child: Icon(
            category.icon,
            color: Colors.white,
          ),
        ),
        title: Text(
          category.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
              ),
            if (onDelete != null && !category.isDefault)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}
