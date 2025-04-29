// lib/presentation/bloc/chart/chart_event.dart
import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';

abstract class ChartEvent extends Equatable {
  const ChartEvent();

  @override
  List<Object?> get props => [];
}

class PieChartTouchEvent extends ChartEvent {
  final FlTouchEvent touchEvent;
  final PieTouchResponse? touchResponse;

  const PieChartTouchEvent({
    required this.touchEvent,
    this.touchResponse,
  });

  @override
  List<Object?> get props => [touchEvent, touchResponse];
}

class ResetChartTouchEvent extends ChartEvent {
  const ResetChartTouchEvent();
}
