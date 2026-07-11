import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blindspot/app/router.dart';
import 'package:blindspot/core/di/providers.dart';
import 'package:blindspot/core/theme/app_theme.dart';

/// Root widget for the BlindSpot application.
///
/// Consumes [routerProvider] and [themeModeProvider] so that the app
/// rebuilds automatically when the user switches themes or navigation state
/// changes.
class BlindSpotApp extends ConsumerWidget {
  const BlindSpotApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'BlindSpot',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
