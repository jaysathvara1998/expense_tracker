// lib/presentation/bloc/chart/chart_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chart_event.dart';
import 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  ChartBloc() : super(ChartState.initial()) {
    on<PieChartTouchEvent>(_onPieChartTouch);
    on<ResetChartTouchEvent>(_onResetChartTouch);
  }

  void _onPieChartTouch(
    PieChartTouchEvent event,
    Emitter<ChartState> emit,
  ) {
    if (!event.touchEvent.isInterestedForInteractions ||
        event.touchResponse == null ||
        event.touchResponse!.touchedSection == null) {
      emit(state.copyWith(touchedPieChartIndex: -1));
      return;
    }

    final touchedIndex =
        event.touchResponse!.touchedSection!.touchedSectionIndex;
    emit(state.copyWith(touchedPieChartIndex: touchedIndex));
  }

  void _onResetChartTouch(
    ResetChartTouchEvent event,
    Emitter<ChartState> emit,
  ) {
    emit(state.copyWith(touchedPieChartIndex: -1));
  }
}
