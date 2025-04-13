// lib/presentation/bloc/dashboard/dashboard_event.dart
import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboardDataEvent extends DashboardEvent {
  final DateTime month;

  const LoadDashboardDataEvent({required this.month});

  @override
  List<Object?> get props => [month];
}
