// lib/presentation/bloc/filter/filter_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import 'filter_event.dart';
import 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(FilterState.initial()) {
    on<SetDateRangeEvent>(_onSetDateRange);
    on<SetCategoryFilterEvent>(_onSetCategoryFilter);
    on<SetSortByEvent>(_onSetSortBy);
    on<ToggleSortDirectionEvent>(_onToggleSortDirection);
    on<ClearFiltersEvent>(_onClearFilters);
  }

  void _onSetDateRange(
    SetDateRangeEvent event,
    Emitter<FilterState> emit,
  ) {
    emit(state.copyWith(
      startDate: event.startDate,
      endDate: event.endDate,
    ));
  }

  void _onSetCategoryFilter(
    SetCategoryFilterEvent event,
    Emitter<FilterState> emit,
  ) {
    emit(state.copyWith(
      selectedCategoryId: event.categoryId ?? FilterState,
    ));
  }

  void _onSetSortBy(
    SetSortByEvent event,
    Emitter<FilterState> emit,
  ) {
    emit(state.copyWith(
      sortBy: event.sortBy,
    ));
  }

  void _onToggleSortDirection(
    ToggleSortDirectionEvent event,
    Emitter<FilterState> emit,
  ) {
    emit(state.copyWith(
      sortAscending: !state.sortAscending,
    ));
  }

  void _onClearFilters(
    ClearFiltersEvent event,
    Emitter<FilterState> emit,
  ) {
    emit(FilterState.initial());
  }
}
