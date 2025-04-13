// lib/presentation/pages/settings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/app_settings/app_settings_bloc.dart';
import '../bloc/app_settings/app_settings_event.dart';
import '../bloc/app_settings/app_settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Theme Setting
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.theme,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    RadioListTile<ThemeMode>(
                      title: Text(l10n.system),
                      value: ThemeMode.system,
                      groupValue: state.themeMode,
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          context.read<AppSettingsBloc>().add(
                                ChangeThemeModeEvent(value),
                              );
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: Text(l10n.light),
                      value: ThemeMode.light,
                      groupValue: state.themeMode,
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          context.read<AppSettingsBloc>().add(
                                ChangeThemeModeEvent(value),
                              );
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: Text(l10n.dark),
                      value: ThemeMode.dark,
                      groupValue: state.themeMode,
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          context.read<AppSettingsBloc>().add(
                                ChangeThemeModeEvent(value),
                              );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Language Setting
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.language,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    RadioListTile<Locale>(
                      title: Text(l10n.english),
                      value: const Locale('en'),
                      groupValue: state.locale,
                      onChanged: (Locale? value) {
                        if (value != null) {
                          context.read<AppSettingsBloc>().add(
                                ChangeLocaleEvent(value),
                              );
                        }
                      },
                    ),
                    RadioListTile<Locale>(
                      title: Text(l10n.hindi),
                      value: const Locale('hi'),
                      groupValue: state.locale,
                      onChanged: (Locale? value) {
                        if (value != null) {
                          context.read<AppSettingsBloc>().add(
                                ChangeLocaleEvent(value),
                              );
                        }
                      },
                    ),
                    RadioListTile<Locale>(
                      title: Text(l10n.gujarati),
                      value: const Locale('gu'),
                      groupValue: state.locale,
                      onChanged: (Locale? value) {
                        if (value != null) {
                          context.read<AppSettingsBloc>().add(
                                ChangeLocaleEvent(value),
                              );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // App Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('App Version'),
                      subtitle: const Text('1.0.0'),
                      leading: const Icon(Icons.info_outline),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Developed By'),
                      subtitle: const Text('Your Name'),
                      leading: const Icon(Icons.person_outline),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
