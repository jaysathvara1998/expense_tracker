// lib/presentation/bloc/filter/filter_state.dart
import 'package:equatable/equatable.dart';

import '../../../core/util/date_time_utils.dart';

class FilterState extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final String? selectedCategoryId;
  final String sortBy;
  final bool sortAscending;

  const FilterState({
    required this.startDate,
    required this.endDate,
    this.selectedCategoryId,
    this.sortBy = 'date',
    this.sortAscending = false,
  });

  // Initial state factory method - default to current month
  factory FilterState.initial() {
    final now = DateTime.now();
    return FilterState(
      startDate: DateTimeUtils.getStartOfMonth(now),
      endDate: DateTimeUtils.getEndOfMonth(now),
    );
  }

  // Create a copy of the current state with some changes
  FilterState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? sortBy,
    bool? sortAscending,
    // Use Object? to allow setting selectedCategoryId to null
    Object? selectedCategoryId,
  }) {
    return FilterState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      selectedCategoryId: selectedCategoryId == null
          ? this.selectedCategoryId
          : (selectedCategoryId == FilterState)
              ? null
              : selectedCategoryId as String?,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  @override
  List<Object?> get props => [
        startDate,
        endDate,
        selectedCategoryId,
        sortBy,
        sortAscending,
      ];
}
