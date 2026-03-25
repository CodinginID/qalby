import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);
  runApp(
    const ProviderScope(
      child: QalbyApp(),
    ),
  );
}

class QalbyApp extends ConsumerWidget {
  const QalbyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode =
        ref.watch(themeModeProvider).value ?? ThemeMode.system;
    return MaterialApp.router(
      title: 'Qalby',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
