// lib/presentation/bloc/chart/chart_state.dart
import 'package:equatable/equatable.dart';

class ChartState extends Equatable {
  final int touchedPieChartIndex;

  const ChartState({
    this.touchedPieChartIndex = -1,
  });

  // Factory method for initial state
  factory ChartState.initial() {
    return const ChartState();
  }

  ChartState copyWith({
    int? touchedPieChartIndex,
  }) {
    return ChartState(
      touchedPieChartIndex: touchedPieChartIndex ?? this.touchedPieChartIndex,
    );
  }

  @override
  List<Object> get props => [touchedPieChartIndex];
}
