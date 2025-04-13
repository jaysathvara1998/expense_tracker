// lib/presentation/bloc/app_settings/app_settings_event.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AppSettingsEvent extends Equatable {
  const AppSettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends AppSettingsEvent {}

class ChangeThemeModeEvent extends AppSettingsEvent {
  final ThemeMode themeMode;

  const ChangeThemeModeEvent(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

class ChangeLocaleEvent extends AppSettingsEvent {
  final Locale locale;

  const ChangeLocaleEvent(this.locale);

  @override
  List<Object?> get props => [locale];
}
