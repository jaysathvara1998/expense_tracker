// lib/presentation/bloc/navigation/navigation_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../dashboard/dashboard_bloc.dart';
import '../dashboard/dashboard_event.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final DashboardBloc dashboardBloc;

  NavigationBloc({required this.dashboardBloc})
      : super(NavigationState.initial()) {
    on<NavigateToTabEvent>(_onNavigateToTab);
    on<ChangeMonthEvent>(_onChangeMonth);
    on<RefreshDashboardEvent>(_onRefreshDashboard);
  }

  void _onNavigateToTab(
    NavigateToTabEvent event,
    Emitter<NavigationState> emit,
  ) {
    emit(state.copyWith(selectedTabIndex: event.tabIndex));
  }

  void _onChangeMonth(
    ChangeMonthEvent event,
    Emitter<NavigationState> emit,
  ) {
    emit(state.copyWith(selectedMonth: event.selectedMonth));

    // Update dashboard when month changes
    dashboardBloc.add(LoadDashboardDataEvent(month: event.selectedMonth));
  }

  void _onRefreshDashboard(
    RefreshDashboardEvent event,
    Emitter<NavigationState> emit,
  ) {
    // Refresh dashboard data with current selected month
    dashboardBloc.add(LoadDashboardDataEvent(month: state.selectedMonth));
  }
}
