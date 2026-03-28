import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/screens/auth_screen.dart';
import 'features/doctor/screens/doctor_dashboard_screen.dart';
import 'features/patient/screens/patient_dashboard_screen.dart';
import 'l10n/app_localizations.dart';
import 'services/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState()..bootstrap(),
      child: const HealSyncApp(),
    ),
  );
}

class HealSyncApp extends StatelessWidget {
  const HealSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return HealSyncLocaleScope(
      controller: HealSyncLocaleController(),
      child: Builder(
        builder: (context) {
          final controller = HealSyncLocaleScope.of(context);
          return ValueListenableBuilder<Locale>(
            valueListenable: controller,
            builder: (context, locale, _) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                locale: locale,
                onGenerateTitle: (context) =>
                    AppLocalizations.of(context)!.appTitle,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en'),
                  Locale('hi'),
                  Locale('ta'),
                  Locale('te'),
                  Locale('ml'),
                ],
                home: const _RootRouter(),
              );
            },
          );
        },
      ),
    );
  }
}

class HealSyncLocaleController extends ValueNotifier<Locale> {
  HealSyncLocaleController() : super(const Locale('en'));

  void updateLocale(Locale locale) {
    if (value == locale) {
      return;
    }
    value = locale;
  }
}

class HealSyncLocaleScope extends InheritedWidget {
  const HealSyncLocaleScope({
    super.key,
    required this.controller,
    required super.child,
  });

  final HealSyncLocaleController controller;

  static HealSyncLocaleController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<HealSyncLocaleScope>();
    assert(scope != null, 'No HealSyncLocaleScope found in context');
    return scope!.controller;
  }

  @override
  bool updateShouldNotify(HealSyncLocaleScope oldWidget) =>
      controller != oldWidget.controller;
}

class _RootRouter extends StatelessWidget {
  const _RootRouter();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        if (state.isBootstrapping) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.fatalError != null) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(state.fatalError!, textAlign: TextAlign.center),
              ),
            ),
          );
        }

        final currentUser = state.currentUser;
        if (currentUser == null) {
          return const AuthScreen();
        }

        return currentUser.isDoctor
            ? const DoctorDashboardScreen()
            : const PatientDashboardScreen();
      },
    );
  }
}
