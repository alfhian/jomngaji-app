import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'screens/authentication_screen.dart';
import 'screens/home_shell.dart';
import 'screens/onboarding_screen.dart';
import 'screens/recitation_practice_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const JomNgajiApp());
}

class JomNgajiApp extends StatelessWidget {
  const JomNgajiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'JomNgaji',
        theme: AppTheme.buildTheme(),
        home: const _RootNavigator(),
        routes: <String, WidgetBuilder>{
          OnboardingScreen.routeName: (_) => const OnboardingScreen(),
          AuthenticationScreen.routeName: (_) => const AuthenticationScreen(),
          HomeShell.routeName: (_) => const HomeShell(),
          RecitationPracticeScreen.routeName: (_) => const RecitationPracticeScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class _RootNavigator extends StatelessWidget {
  const _RootNavigator();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (BuildContext context, AppState state, _) {
        if (!state.onboardingComplete) {
          return const OnboardingScreen();
        }
        if (!state.isAuthenticated) {
          return const AuthenticationScreen();
        }
        return const HomeShell();
      },
    );
  }
}
