// lib/presentation/pages/loans_page.dart
import 'package:expanse_tracker/presentation/pages/add_edit_loan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/entities/loan.dart';
import '../bloc/loan/loan_bloc.dart';
import '../bloc/loan/loan_event.dart';
import '../bloc/loan/loan_state.dart';
import '../widgets/loan_list_item.dart';

class LoansPage extends StatefulWidget {
  const LoansPage({Key? key}) : super(key: key);

  @override
  State<LoansPage> createState() => _LoansPageState();
}

class _LoansPageState extends State<LoansPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load loans
    context.read<LoanBloc>().add(GetAllLoansEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddLoan(context),
        tooltip: l10n.addLoan,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Borrowed'),
              Tab(text: 'Lent'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLoansList(context, filter: null),
                _buildLoansList(context, filter: LoanType.borrowed),
                _buildLoansList(context, filter: LoanType.lent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoansList(BuildContext context, {LoanType? filter}) {
    return BlocBuilder<LoanBloc, LoanState>(
      builder: (context, state) {
        if (state is LoanLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LoansLoaded) {
          // Filter loans based on type
          final loans = filter != null
              ? state.loans.where((loan) => loan.type == filter).toList()
              : state.loans;

          // Sort loans - unsettled first, then by due date
          loans.sort((a, b) {
            if (a.isSettled && !b.isSettled) return 1;
            if (!a.isSettled && b.isSettled) return -1;

            // Both settled or both unsettled, sort by due date
            if (a.dueDate != null && b.dueDate != null) {
              return a.dueDate!.compareTo(b.dueDate!);
            } else if (a.dueDate != null) {
              return -1;
            } else if (b.dueDate != null) {
              return 1;
            }

            // No due dates, sort by creation date
            return b.date.compareTo(a.date);
          });

          return _buildLoansContent(context, loans);
        } else if (state is LoanOperationFailure) {
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
                    context.read<LoanBloc>().add(GetAllLoansEvent());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<LoanBloc>().add(GetAllLoansEvent());
              },
              child: const Text('Load Loans'),
            ),
          );
        }
      },
    );
  }

  Widget _buildLoansContent(BuildContext context, List<Loan> loans) {
    final l10n = AppLocalizations.of(context)!;

    if (loans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.noData),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _navigateToAddLoan(context),
              child: Text(l10n.addLoan),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<LoanBloc>().add(GetAllLoansEvent());
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(8.0),
        itemCount: loans.length,
        itemBuilder: (context, index) {
          final loan = loans[index];
          return LoanListItem(
            loan: loan,
            onTap: () => _navigateToEditLoan(context, loan),
            onEdit: () => _navigateToEditLoan(context, loan),
            onDelete: () => _showDeleteConfirmation(context, loan),
            onSettle: loan.isSettled ? null : () => _settleLoan(context, loan),
          );
        },
      ),
    );
  }

  Future<void> _navigateToAddLoan(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditLoanPage(),
      ),
    );

    if (result == true) {
      context.read<LoanBloc>().add(GetAllLoansEvent());
    }
  }

  Future<void> _navigateToEditLoan(BuildContext context, Loan loan) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditLoanPage(loan: loan),
      ),
    );

    if (result == true) {
      context.read<LoanBloc>().add(GetAllLoansEvent());
    }
  }

  Future<void> _showDeleteConfirmation(BuildContext context, Loan loan) async {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) {
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
                context.read<LoanBloc>().add(DeleteLoanEvent(loan.id));
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }

  void _settleLoan(BuildContext context, Loan loan) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.settle),
          content: Text(
              'Mark this ${loan.type == LoanType.borrowed ? 'borrowed' : 'lent'} amount as settled?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                final settledLoan = Loan(
                  id: loan.id,
                  personName: loan.personName,
                  amount: loan.amount,
                  date: loan.date,
                  dueDate: loan.dueDate,
                  description: loan.description,
                  hasReminder: loan.hasReminder,
                  type: loan.type,
                  isSettled: true,
                );
                context.read<LoanBloc>().add(UpdateLoanEvent(settledLoan));
              },
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              child: Text(l10n.confirm),
            ),
          ],
        );
      },
    );
  }
}
