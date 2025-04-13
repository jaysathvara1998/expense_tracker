import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/util/date_time_utils.dart';
import '../../../domain/entities/loan.dart';

class LoanListItem extends StatelessWidget {
  final Loan loan;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSettle;

  const LoanListItem({
    Key? key,
    required this.loan,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onSettle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          loan.type == LoanType.borrowed
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: loan.type == LoanType.borrowed
                              ? Colors.red
                              : Colors.green,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            loan.personName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${l10n.currency}${loan.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: loan.type == LoanType.borrowed
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                loan.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${l10n.date}: ${DateTimeUtils.formatDate(loan.date)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (loan.dueDate != null) ...[
                    const SizedBox(width: 16),
                    Icon(
                      Icons.event,
                      size: 16,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${l10n.dueDate}: ${DateTimeUtils.formatDate(loan.dueDate!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _isDueDateNear(loan.dueDate!) ||
                                    _isDueDatePassed(loan.dueDate!)
                                ? Colors.red
                                : null,
                            fontWeight: _isDueDateNear(loan.dueDate!) ||
                                    _isDueDatePassed(loan.dueDate!)
                                ? FontWeight.bold
                                : null,
                          ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (loan.hasReminder)
                    Chip(
                      label: Text(
                        'Reminder',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 12,
                        ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  if (loan.isSettled)
                    Chip(
                      label: Text(
                        'Settled',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 12,
                        ),
                      ),
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  const Spacer(),
                  if (!loan.isSettled && onSettle != null)
                    TextButton.icon(
                      onPressed: onSettle,
                      icon: const Icon(Icons.check_circle),
                      label: Text(l10n.settle),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 0,
                        ),
                      ),
                    ),
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: onEdit,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  if (onDelete != null) ...[
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: onDelete,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isDueDateNear(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;
    return difference >= 0 && difference <= 3;
  }

  bool _isDueDatePassed(DateTime dueDate) {
    final now = DateTime.now();
    return dueDate.isBefore(now);
  }
}
