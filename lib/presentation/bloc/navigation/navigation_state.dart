// lib/presentation/bloc/navigation/navigation_state.dart
import 'package:equatable/equatable.dart';

class NavigationState extends Equatable {
  final int selectedTabIndex;
  final DateTime selectedMonth;

  const NavigationState({
    this.selectedTabIndex = 0,
    required this.selectedMonth,
  });

  // Factory method for initial state
  factory NavigationState.initial() {
    return NavigationState(
      selectedMonth: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        1,
      ),
    );
  }

  NavigationState copyWith({
    int? selectedTabIndex,
    DateTime? selectedMonth,
  }) {
    return NavigationState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      selectedMonth: selectedMonth ?? this.selectedMonth,
    );
  }

  @override
  List<Object> get props => [selectedTabIndex, selectedMonth];
}
