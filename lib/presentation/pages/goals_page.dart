// lib/presentation/pages/goals_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/entities/goal.dart';
import '../bloc/goal/goal_bloc.dart';
import '../bloc/goal/goal_event.dart';
import '../bloc/goal/goal_state.dart';
import '../widgets/goal_list_item.dart';
import 'add_edit_goal_page.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load goals
    context.read<GoalBloc>().add(GetAllGoalsEvent());
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
        onPressed: () => _navigateToAddGoal(context),
        tooltip: l10n.addGoal,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: [
              Tab(text: 'Active Goals'),
              Tab(text: 'Completed Goals'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGoalsList(context, active: true),
                _buildGoalsList(context, active: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsList(BuildContext context, {required bool active}) {
    return BlocBuilder<GoalBloc, GoalState>(
      builder: (context, state) {
        if (state is GoalLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is GoalsLoaded) {
          // Filter goals based on active status
          final goals = state.goals.where((goal) {
            final isActive = goal.savedAmount < goal.targetAmount &&
                goal.endDate.isAfter(DateTime.now());
            return active ? isActive : !isActive;
          }).toList();

          // Sort goals - active ones by progress, completed ones by completion date
          if (active) {
            goals.sort((a, b) => b.progress.compareTo(a.progress));
          } else {
            goals.sort((a, b) => b.endDate.compareTo(a.endDate));
          }

          return _buildGoalsContent(context, goals);
        } else if (state is GoalOperationFailure) {
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
                    context.read<GoalBloc>().add(GetAllGoalsEvent());
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
                context.read<GoalBloc>().add(GetAllGoalsEvent());
              },
              child: const Text('Load Goals'),
            ),
          );
        }
      },
    );
  }

  Widget _buildGoalsContent(BuildContext context, List<Goal> goals) {
    final l10n = AppLocalizations.of(context)!;

    if (goals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.noData),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _navigateToAddGoal(context),
              child: Text(l10n.addGoal),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<GoalBloc>().add(GetAllGoalsEvent());
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(8.0),
        itemCount: goals.length,
        itemBuilder: (context, index) {
          final goal = goals[index];
          return GoalListItem(
            goal: goal,
            onTap: () => _navigateToEditGoal(context, goal),
            onEdit: () => _navigateToEditGoal(context, goal),
            onDelete: () => _showDeleteConfirmation(context, goal),
          );
        },
      ),
    );
  }

  Future<void> _navigateToAddGoal(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditGoalPage(),
      ),
    );

    if (result == true) {
      context.read<GoalBloc>().add(GetAllGoalsEvent());
    }
  }

  Future<void> _navigateToEditGoal(BuildContext context, Goal goal) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditGoalPage(goal: goal),
      ),
    );

    if (result == true) {
      context.read<GoalBloc>().add(GetAllGoalsEvent());
    }
  }

  Future<void> _showDeleteConfirmation(BuildContext context, Goal goal) async {
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
                context.read<GoalBloc>().add(DeleteGoalEvent(goal.id));
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
