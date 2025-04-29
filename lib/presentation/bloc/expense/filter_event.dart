// lib/presentation/bloc/filter/filter_event.dart
import 'package:equatable/equatable.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object?> get props => [];
}

class SetDateRangeEvent extends FilterEvent {
  final DateTime startDate;
  final DateTime endDate;

  const SetDateRangeEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];
}

class SetCategoryFilterEvent extends FilterEvent {
  final String? categoryId;

  const SetCategoryFilterEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class SetSortByEvent extends FilterEvent {
  final String sortBy;

  const SetSortByEvent(this.sortBy);

  @override
  List<Object> get props => [sortBy];
}

class ToggleSortDirectionEvent extends FilterEvent {}

class ApplyFiltersEvent extends FilterEvent {}

class ClearFiltersEvent extends FilterEvent {}
