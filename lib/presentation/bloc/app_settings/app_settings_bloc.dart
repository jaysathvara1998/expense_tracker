// lib/presentation/bloc/app_settings/app_settings_bloc.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_settings_event.dart';
import 'app_settings_state.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  final SharedPreferences sharedPreferences;

  AppSettingsBloc({
    required this.sharedPreferences,
  }) : super(AppSettingsState.initial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<ChangeThemeModeEvent>(_onChangeThemeMode);
    on<ChangeLocaleEvent>(_onChangeLocale);
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<AppSettingsState> emit,
  ) async {
    // Load theme mode
    final String? themeModeString = sharedPreferences.getString('themeMode');
    final ThemeMode themeMode = themeModeString != null
        ? ThemeMode.values.firstWhere(
            (e) => e.toString() == themeModeString,
            orElse: () => ThemeMode.system,
          )
        : ThemeMode.system;

    // Load locale
    final String? languageCode = sharedPreferences.getString('languageCode');
    final Locale locale =
        languageCode != null ? Locale(languageCode) : const Locale('en');

    emit(state.copyWith(
      themeMode: themeMode,
      locale: locale,
      isLoading: false,
    ));
  }

  Future<void> _onChangeThemeMode(
    ChangeThemeModeEvent event,
    Emitter<AppSettingsState> emit,
  ) async {
    await sharedPreferences.setString('themeMode', event.themeMode.toString());
    emit(state.copyWith(themeMode: event.themeMode));
  }

  Future<void> _onChangeLocale(
    ChangeLocaleEvent event,
    Emitter<AppSettingsState> emit,
  ) async {
    await sharedPreferences.setString(
        'languageCode', event.locale.languageCode);
    emit(state.copyWith(locale: event.locale));
  }
}
