// lib/presentation/bloc/navigation/navigation_event.dart
import 'package:equatable/equatable.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object?> get props => [];
}

class NavigateToTabEvent extends NavigationEvent {
  final int tabIndex;

  const NavigateToTabEvent(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}

class ChangeMonthEvent extends NavigationEvent {
  final DateTime selectedMonth;

  const ChangeMonthEvent(this.selectedMonth);

  @override
  List<Object> get props => [selectedMonth];
}

class RefreshDashboardEvent extends NavigationEvent {
  const RefreshDashboardEvent();
}
