// lib/presentation/bloc/app_settings/app_settings_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettingsState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;
  final bool isLoading;

  const AppSettingsState({
    required this.themeMode,
    required this.locale,
    this.isLoading = false,
  });

  factory AppSettingsState.initial() {
    return const AppSettingsState(
      themeMode: ThemeMode.system,
      locale: Locale('en'),
      isLoading: true,
    );
  }

  AppSettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? isLoading,
  }) {
    return AppSettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [themeMode, locale, isLoading];
}
