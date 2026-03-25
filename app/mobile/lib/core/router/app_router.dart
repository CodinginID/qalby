import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/quran/presentation/pages/surah_list_page.dart';
import '../../features/quran/presentation/pages/surah_detail_page.dart';
import '../../features/playlist/presentation/pages/playlist_list_page.dart';
import '../../features/playlist/presentation/pages/playlist_detail_page.dart';
import '../../features/playlist/presentation/pages/add_ayat_page.dart';
import '../../features/practice/presentation/pages/practice_page.dart';
import '../../features/practice/presentation/pages/practice_result_page.dart';
import '../../features/prayer/presentation/pages/prayer_page.dart';
import '../../features/qibla/presentation/pages/qibla_page.dart';
import '../../features/content/presentation/pages/motivasi_page.dart';
import '../../features/content/presentation/pages/doa_page.dart';
import '../../features/content/presentation/pages/kisah_nabi_list_page.dart';
import '../../features/content/presentation/pages/kisah_nabi_detail_page.dart';
import '../../features/content/presentation/pages/dzikir_page.dart';
import '../../features/content/presentation/pages/sunnah_tracker_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart' show ProfilePage;
import '../../shared/widgets/main_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  redirect: (context, state) {
    return null;
  },
  routes: [
    GoRoute(
      path: '/splash',
      builder: (_, __) => const SplashPage(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (_, __) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (_, __) => const RegisterPage(),
    ),
    // Detail routes pushed above the shell (full screen, no bottom nav)
    GoRoute(
      path: '/quran/:surahId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) => SurahDetailPage(
        surahId: int.parse(state.pathParameters['surahId']!),
      ),
    ),
    GoRoute(
      path: '/playlists/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) => PlaylistDetailPage(
        id: state.pathParameters['id']!,
      ),
      routes: [
        GoRoute(
          path: 'add-ayat',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (_, state) => AddAyatPage(
            playlistId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: 'practice',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (_, state) => PracticePage(
            playlistId: state.pathParameters['id']!,
          ),
          routes: [
            GoRoute(
              path: 'result',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (_, state) => PracticeResultPage(
                playlistId: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
      ],
    ),
    // Content routes (full screen, no bottom nav)
    GoRoute(
      path: '/motivasi',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const MotivasiPage(),
    ),
    GoRoute(
      path: '/doa',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const DoaPage(),
    ),
    GoRoute(
      path: '/kisah-nabi',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const KisahNabiListPage(),
      routes: [
        GoRoute(
          path: ':id',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (_, state) => KisahNabiDetailPage(
            prophetId: state.pathParameters['id']!,
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/dzikir',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const DzikirPage(),
    ),
    GoRoute(
      path: '/sunnah-tracker',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const SunnahTrackerPage(),
    ),
    GoRoute(
      path: '/profile',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const ProfilePage(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (_, __, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (_, __) => const HomePage(),
        ),
        GoRoute(
          path: '/quran',
          builder: (_, __) => const SurahListPage(),
        ),
        GoRoute(
          path: '/playlists',
          builder: (_, __) => const PlaylistListPage(),
        ),
        GoRoute(
          path: '/prayer',
          builder: (_, __) => const PrayerPage(),
        ),
        GoRoute(
          path: '/qibla',
          builder: (_, __) => const QiblaPage(),
        ),
      ],
    ),
  ],
);
