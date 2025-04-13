import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/constants/theme_constants.dart';
import 'di_container.dart' as di;
import 'presentation/bloc/app_settings/app_settings_bloc.dart';
import 'presentation/bloc/app_settings/app_settings_event.dart';
import 'presentation/bloc/app_settings/app_settings_state.dart';
import 'presentation/bloc/category/category_bloc.dart';
import 'presentation/bloc/dashboard/dashboard_bloc.dart';
import 'presentation/bloc/expense/expense_bloc.dart';
import 'presentation/bloc/goal/goal_bloc.dart';
import 'presentation/bloc/loan/loan_bloc.dart';
import 'presentation/pages/dashboard_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppSettingsBloc>(
          create: (_) => di.sl<AppSettingsBloc>()..add(LoadSettingsEvent()),
        ),
        BlocProvider<CategoryBloc>(
          create: (_) => di.sl<CategoryBloc>(),
        ),
        BlocProvider<ExpenseBloc>(
          create: (_) => di.sl<ExpenseBloc>(),
        ),
        BlocProvider<GoalBloc>(
          create: (_) => di.sl<GoalBloc>(),
        ),
        BlocProvider<LoanBloc>(
          create: (_) => di.sl<LoanBloc>(),
        ),
        BlocProvider<DashboardBloc>(
          create: (_) => di.sl<DashboardBloc>(),
        ),
      ],
      child: BlocBuilder<AppSettingsBloc, AppSettingsState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Expense Tracker',
            debugShowCheckedModeBanner: false,
            theme: ThemeConstants.lightTheme,
            darkTheme: ThemeConstants.darkTheme,
            themeMode: state.themeMode,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('hi'),
              Locale('gu'),
            ],
            locale: state.locale,
            home: const DashboardPage(),
          );
        },
      ),
    );
  }
}
