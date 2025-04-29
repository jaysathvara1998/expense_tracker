import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/util/date_time_utils.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/expense.dart';
import '../bloc/chart/chart_bloc.dart';
import '../bloc/chart/chart_event.dart';
import '../bloc/chart/chart_state.dart';

class MonthlyExpenseBarChart extends StatelessWidget {
  final List<Expense> expenses;
  final DateTime month;

  const MonthlyExpenseBarChart({
    super.key,
    required this.expenses,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groupedData = _groupExpensesByDay();
    final maxY = groupedData.values.isEmpty
        ? 100.0
        : (groupedData.values.reduce((a, b) => a > b ? a : b) * 1.2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            '${l10n.thisMonth} - ${DateTimeUtils.getMonthName(month)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        SizedBox(
          height: 220,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (BarChartGroupData group) =>
                        Colors.blueGrey,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final day = group.x.toInt();
                      return BarTooltipItem(
                        '${day.toString()} - ${l10n.currency}${rod.toY.toStringAsFixed(2)}',
                        const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          // axisSide: meta.axisSide,
                          space: 4,
                          meta: meta,
                          child: Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                      reservedSize: 24,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final text = value == 0
                            ? '0'
                            : '${l10n.currency}${value.toInt()}';
                        return SideTitleWidget(
                          meta: meta,
                          space: 4,
                          child: Text(
                            text,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: maxY / 5,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                barGroups: _createBarGroups(groupedData),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Map<int, double> _groupExpensesByDay() {
    final groupedData = <int, double>{};
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    // Initialize all days with 0
    for (int i = 1; i <= daysInMonth; i++) {
      groupedData[i] = 0;
    }

    // Sum expenses for each day
    for (final expense in expenses) {
      final day = expense.date.day;
      groupedData[day] = (groupedData[day] ?? 0) + expense.amount;
    }

    return groupedData;
  }

  List<BarChartGroupData> _createBarGroups(Map<int, double> groupedData) {
    return groupedData.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: Colors.blueAccent,
            width: 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ],
      );
    }).toList();
  }
}

class CategoryPieChart extends StatelessWidget {
  final Map<Category, double> expensesByCategory;

  const CategoryPieChart({
    super.key,
    required this.expensesByCategory,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChartBloc(),
      child: _CategoryPieChartView(expensesByCategory: expensesByCategory),
    );
  }
}

class _CategoryPieChartView extends StatelessWidget {
  final Map<Category, double> expensesByCategory;

  const _CategoryPieChartView({
    required this.expensesByCategory,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ChartBloc, ChartState>(
      builder: (context, chartState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                l10n.byCategory,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            SizedBox(
              height: 240,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            context.read<ChartBloc>().add(
                                  PieChartTouchEvent(
                                    touchEvent: event,
                                    touchResponse: pieTouchResponse,
                                  ),
                                );
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: _createPieChartSections(
                            chartState.touchedPieChartIndex),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildLegend(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<PieChartSectionData> _createPieChartSections(int touchedIndex) {
    final total = expensesByCategory.values.fold(0.0, (a, b) => a + b);

    if (expensesByCategory.isEmpty) {
      return [
        PieChartSectionData(
          color: Colors.grey,
          value: 100,
          title: '',
          radius: 60,
          titleStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ];
    }

    return expensesByCategory.entries.map((entry) {
      final category = entry.key;
      final amount = entry.value;
      final index = expensesByCategory.keys.toList().indexOf(category);
      final isTouched = index == touchedIndex;
      final percentage = (amount / total * 100).toStringAsFixed(1);

      return PieChartSectionData(
        color: category.color,
        value: amount,
        title: isTouched ? '$percentage%' : '',
        radius: isTouched ? 70 : 60,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      );
    }).toList();
  }

  Widget _buildLegend(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final total = expensesByCategory.values.fold(0.0, (a, b) => a + b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${l10n.totalExpense}: ${l10n.currency}${total.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: expensesByCategory.entries.map((entry) {
                final category = entry.key;
                final amount = entry.value;
                final percentage = (amount / total * 100).toStringAsFixed(1);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: category.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          category.name,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
