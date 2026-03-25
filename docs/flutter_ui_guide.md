# Qalby — Flutter UI Development Guide

> Panduan lengkap desain dan implementasi UI Flutter untuk app Qalby.
> Tujuan: UI yang cantik, modern, Islamic, dan intuitif.
>
> Dokumen ini mengacu pada best practice resmi Flutter (Material 3),
> Riverpod v3 (code generation), dan go_router terkini.

---

## 1. Design Philosophy

### Prinsip Utama

| Prinsip | Penjelasan |
|---------|------------|
| **Tenang & Sakral** | Warna yang menenangkan, tidak terlalu ramai. Seperti suasana masjid yang damai. |
| **Modern & Bersih** | Clean layout, whitespace cukup, tidak cluttered. |
| **Fungsional Pertama** | Navigasi intuitif, aksi utama mudah dijangkau satu tangan. |
| **Islamic Subtle** | Ornamen Islam hadir tapi tidak berlebihan — accent, bukan dominasi. |

---

## 2. Color System

### Primary Palette

```dart
// lib/core/theme/app_colors.dart

class AppColors {
  // Deep Teal — warna utama, memancarkan ketenangan spiritual
  static const Color primary        = Color(0xFF1A5276); // deep islamic blue
  static const Color primaryLight   = Color(0xFF2E86C1);
  static const Color primaryDark    = Color(0xFF0E2F44);

  // Gold — aksen untuk elemen premium/sakral
  static const Color accent         = Color(0xFFC9A84C); // islamic gold
  static const Color accentLight    = Color(0xFFE8C97A);
  static const Color accentDark     = Color(0xFF9B7D35);

  // Teal Green — sukses, hafalan selesai
  static const Color success        = Color(0xFF1E8449);
  static const Color successLight   = Color(0xFF27AE60);

  // Neutral
  static const Color surface        = Color(0xFFF8F6F2); // warm white (krem lembut)
  static const Color surfaceCard    = Color(0xFFFFFFFF);
  static const Color divider        = Color(0xFFEAE4D8);

  // Text
  static const Color textPrimary    = Color(0xFF1C1C1E);
  static const Color textSecondary  = Color(0xFF6B6B6B);
  static const Color textHint       = Color(0xFFAAAAAA);
  static const Color textOnPrimary  = Color(0xFFFFFFFF);
  static const Color textGold       = Color(0xFFC9A84C);

  // Dark Mode variants
  static const Color darkBackground = Color(0xFF0D1117);
  static const Color darkSurface    = Color(0xFF161B22);
  static const Color darkCard       = Color(0xFF21262D);
  static const Color darkBorder     = Color(0xFF30363D);
}
```

### Gradient Presets

```dart
// Gradient untuk hero section & header
static const LinearGradient primaryGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF1A5276), Color(0xFF0E2F44)],
);

// Gradient untuk card hafalan aktif
static const LinearGradient goldGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFC9A84C), Color(0xFF9B7D35)],
);

// Gradient untuk background gelap dengan nuansa langit malam
static const LinearGradient nightGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xFF0D1117), Color(0xFF1A2744)],
);
```

---

## 3. Typography

### Font Pilihan

| Jenis | Font | Kegunaan |
|-------|------|---------|
| Latin UI | **Plus Jakarta Sans** | Semua teks UI umum |
| Arabic | **Amiri** atau **Scheherazade New** | Teks ayat Al-Quran |
| Arabic Accent | **Noto Naskh Arabic** | Label surah, nama Arab |

### Setup pubspec.yaml

```yaml
fonts:
  - family: PlusJakartaSans
    fonts:
      - asset: assets/fonts/PlusJakartaSans-Regular.ttf
      - asset: assets/fonts/PlusJakartaSans-Medium.ttf
        weight: 500
      - asset: assets/fonts/PlusJakartaSans-SemiBold.ttf
        weight: 600
      - asset: assets/fonts/PlusJakartaSans-Bold.ttf
        weight: 700

  - family: Amiri
    fonts:
      - asset: assets/fonts/Amiri-Regular.ttf
      - asset: assets/fonts/Amiri-Bold.ttf
        weight: 700
```

### Text Style System

```dart
// lib/core/theme/app_text_styles.dart

class AppTextStyles {
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 28, fontWeight: FontWeight.w700, height: 1.3,
  );
  static const TextStyle headingMedium = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 20, fontWeight: FontWeight.w600, height: 1.4,
  );
  static const TextStyle titleCard = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 16, fontWeight: FontWeight.w600, height: 1.4,
  );
  static const TextStyle bodyRegular = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 14, fontWeight: FontWeight.w400, height: 1.6,
  );
  static const TextStyle caption = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 12, fontWeight: FontWeight.w400, height: 1.5,
  );
  static const TextStyle labelSmall = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5,
  );

  // Arabic — untuk teks ayat
  static const TextStyle arabicAyat = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 26, fontWeight: FontWeight.w400, height: 2.0,
  );
  static const TextStyle arabicSmall = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 18, fontWeight: FontWeight.w400, height: 1.8,
  );
  static const TextStyle arabicSurahName = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 22, fontWeight: FontWeight.w700,
  );
}
```

---

## 4. Spacing & Shape System

```dart
// lib/core/theme/app_spacing.dart

class AppSpacing {
  static const double xs  = 4;
  static const double sm  = 8;
  static const double md  = 16;
  static const double lg  = 24;
  static const double xl  = 32;
  static const double xxl = 48;
}

class AppRadius {
  static const double sm   = 8;
  static const double md   = 12;
  static const double lg   = 16;
  static const double xl   = 24;
  static const double full = 999;
}
```

> Gunakan package `gap` untuk spacing antar widget: `Gap(AppSpacing.md)`.
> Lebih bersih daripada `SizedBox(height: 16)`.

---

## 5. Islamic Ornament Assets

Simpan di `assets/illustrations/` dan `assets/icons/`:

```
assets/
├── fonts/
├── icons/
│   ├── ic_quran.svg
│   ├── ic_playlist.svg
│   ├── ic_practice.svg
│   ├── ic_prayer.svg
│   ├── ic_qibla.svg
│   ├── ic_star_islamic.svg    # bintang 8 sudut khas Islam
│   └── ic_moon_crescent.svg
├── illustrations/
│   ├── mosque_silhouette.svg  # siluet masjid untuk onboarding
│   ├── arabesque_corner.svg   # ornamen kaligrafi sudut
│   ├── geometric_pattern.svg  # pola geometris Islam (subtle bg)
│   └── quran_book.svg
├── lottie/
│   ├── fireworks.json         # animasi selesai practice
│   ├── moon_stars.json        # animasi splash
│   └── loading_quran.json     # loading state
└── images/
    └── splash_bg.png
```

**Sumber asset gratis:**
- SVG ornamen: flaticon.com, freepik (filter: Islamic, Arabic geometric)
- Font Arabic: fonts.google.com (Amiri, Scheherazade New)
- Lottie: lottiefiles.com (search: "islamic", "quran", "celebration")

---

## 6. Flutter Project Structure

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   ├── app_spacing.dart
│   │   └── app_theme.dart          # ThemeData light + dark
│   ├── router/
│   │   └── app_router.dart         # GoRouter config + auth redirect
│   ├── network/
│   │   └── api_client.dart         # Dio client + interceptors
│   └── utils/
│       ├── arabic_utils.dart       # helper ayat number → arabic numeral
│       └── prayer_utils.dart
├── features/
│   ├── auth/
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   │   ├── splash_page.dart
│   │   │   │   ├── onboarding_page.dart
│   │   │   │   ├── login_page.dart
│   │   │   │   └── register_page.dart
│   │   │   └── widgets/
│   │   ├── data/
│   │   │   └── auth_repository.dart
│   │   └── domain/
│   │       └── auth_provider.dart  # @riverpod AsyncNotifier
│   ├── home/
│   │   └── presentation/
│   │       ├── pages/home_page.dart
│   │       └── widgets/
│   │           ├── greeting_header.dart
│   │           ├── prayer_time_card.dart
│   │           ├── quick_action_bar.dart
│   │           └── recent_playlist_card.dart
│   ├── quran/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── surah_list_page.dart
│   │       │   └── surah_detail_page.dart
│   │       └── widgets/
│   │           ├── surah_list_tile.dart
│   │           └── ayat_item_widget.dart
│   ├── playlist/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── playlist_list_page.dart
│   │       │   ├── playlist_detail_page.dart
│   │       │   └── add_ayat_page.dart
│   │       └── widgets/
│   ├── practice/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── practice_page.dart
│   │       │   └── practice_result_page.dart
│   │       └── widgets/
│   ├── prayer/
│   │   └── presentation/
│   │       ├── pages/prayer_page.dart
│   │       └── widgets/
│   │           └── prayer_time_card.dart
│   └── qibla/
│       └── presentation/
│           └── pages/qibla_page.dart
└── shared/
    └── widgets/
        ├── app_button.dart
        ├── app_text_field.dart
        ├── app_card.dart
        ├── arabic_text.dart          # widget khusus teks Arab RTL
        ├── section_header.dart
        ├── empty_state_widget.dart
        └── islamic_divider.dart      # divider dengan ornamen
```

---

## 7. Packages yang Direkomendasikan

```yaml
# pubspec.yaml

dependencies:
  flutter:
    sdk: flutter

  # State Management — Riverpod v3 (gunakan code generation)
  flutter_riverpod: ^3.0.2
  riverpod_annotation: ^3.0.2

  # Navigation
  go_router: ^14.6.3

  # Network
  dio: ^5.7.0

  # Local Storage
  flutter_secure_storage: ^9.2.2   # simpan token JWT
  shared_preferences: ^2.3.3       # settings ringan (onboarding seen, dll)

  # UI — Core
  flutter_svg: ^2.0.10
  cached_network_image: ^3.4.1
  gap: ^3.0.1                      # spacing bersih: Gap(16) vs SizedBox(height:16)

  # UI — Animasi (WAJIB untuk UI cantik)
  flutter_animate: ^4.5.0          # chainable animations, sangat powerful
  lottie: ^3.1.0                   # animasi JSON (splash, celebrasi, loading)

  # UI — Loading State
  skeletonizer: ^1.4.2             # skeleton loading otomatis dari widget asli

  # UI — Onboarding
  smooth_page_indicator: ^1.2.0    # dots indicator onboarding yang smooth

  # Islamic Date
  hijri: ^2.0.1                    # konversi tanggal Masehi ↔ Hijriyah

  # Prayer & Qibla
  adhan: ^2.1.0                    # perhitungan waktu sholat (offline, akurat)
  flutter_qiblah: ^2.0.1           # kompas qibla
  geolocator: ^13.0.2

  # Notifications
  flutter_local_notifications: ^17.2.3

  # Utility
  intl: ^0.19.0
  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0
  permission_handler: ^11.3.1

dev_dependencies:
  build_runner: ^2.4.13
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  riverpod_generator: ^3.0.2       # generate provider dari @riverpod annotation
  custom_lint: ^0.7.5
  riverpod_lint: ^3.0.2            # lint rules khusus Riverpod
  flutter_lints: ^4.0.0
```

### Catatan Penting Package

| Package | Kenapa Dipakai |
|---------|---------------|
| `flutter_animate` | Animasi cantik dengan chainable API — `.fadeIn()`, `.slideX()`, `.scale()` tanpa boilerplate AnimationController |
| `skeletonizer` | Wrap widget apapun dengan `Skeletonizer(enabled: isLoading)` — skeleton loading tanpa tulis widget terpisah |
| `gap` | `Gap(16)` lebih bersih dan semantik daripada `SizedBox(height: 16)` |
| `smooth_page_indicator` | Dots onboarding dengan animasi smooth, banyak style pilihan |
| `hijri` | Tampilkan tanggal Hijriyah di header home tanpa kalkulasi manual |
| `riverpod_lint` | Deteksi anti-pattern Riverpod di saat coding, bukan saat runtime |

---

## 8. App Theme Setup (Material 3)

> **Catatan:** Sejak Flutter 3.16, Material 3 aktif secara default.
> Gunakan `NavigationBar` (M3), bukan `BottomNavigationBar` (M2 — deprecated).

```dart
// lib/core/theme/app_theme.dart

ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
    surface: AppColors.surface,
  ),
  scaffoldBackgroundColor: AppColors.surface,
  fontFamily: 'PlusJakartaSans',

  appBarTheme: const AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,   // tidak berubah saat scroll
    centerTitle: true,
    backgroundColor: Colors.transparent,
    foregroundColor: AppColors.textPrimary,
    titleTextStyle: AppTextStyles.headingMedium,
  ),

  cardTheme: CardTheme(
    elevation: 0,
    color: AppColors.surfaceCard,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      side: const BorderSide(color: AppColors.divider, width: 1),
    ),
    margin: EdgeInsets.zero,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      textStyle: AppTextStyles.bodyRegular.copyWith(fontWeight: FontWeight.w600),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceCard,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: const BorderSide(color: AppColors.divider),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: const BorderSide(color: AppColors.divider),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    hintStyle: AppTextStyles.bodyRegular.copyWith(color: AppColors.textHint),
  ),

  // Material 3: NavigationBar (bukan BottomNavigationBar)
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.surfaceCard,
    indicatorColor: AppColors.primary.withValues(alpha: 0.12),
    iconTheme: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const IconThemeData(color: AppColors.primary);
      }
      return const IconThemeData(color: AppColors.textHint);
    }),
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppTextStyles.labelSmall.copyWith(color: AppColors.primary);
      }
      return AppTextStyles.labelSmall.copyWith(color: AppColors.textHint);
    }),
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    shadowColor: AppColors.divider,
  ),
);

ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
    surface: AppColors.darkSurface,
  ),
  scaffoldBackgroundColor: AppColors.darkBackground,
  fontFamily: 'PlusJakartaSans',
  // ... mirror dari lightTheme dengan dark colors
);
```

---

## 9. Riverpod v3 — Pola yang Benar

> **Riverpod v3 best practice:** Selalu gunakan `@riverpod` code generation.
> Jangan tulis provider manual. `AsyncNotifier` menggantikan `StateNotifier` + `FutureProvider`.

### Setup main.dart

```dart
// lib/main.dart

void main() {
  runApp(const ProviderScope(child: QalbyApp()));
}
```

### Contoh: Auth Provider

```dart
// lib/features/auth/domain/auth_provider.dart
part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<User?> build() async {
    // build() dipanggil sekali saat provider pertama diakses
    final token = await ref.read(secureStorageProvider).read(key: 'token');
    if (token == null) return null;
    return ref.read(authRepositoryProvider).getProfile(token);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading<User?>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      final user = await ref.read(authRepositoryProvider).login(email, password);
      await ref.read(secureStorageProvider).write(key: 'token', value: user.token);
      return user;
    });
  }

  Future<void> logout() async {
    await ref.read(secureStorageProvider).delete(key: 'token');
    state = const AsyncData(null);
  }
}
```

### Contoh: Playlist Provider

```dart
// lib/features/playlist/domain/playlist_provider.dart
part 'playlist_provider.g.dart';

@riverpod
Future<List<Playlist>> playlists(Ref ref) async {
  return ref.read(playlistRepositoryProvider).getAll();
}

@riverpod
class PlaylistDetail extends _$PlaylistDetail {
  @override
  Future<Playlist> build(String id) async {
    return ref.read(playlistRepositoryProvider).getById(id);
  }

  Future<void> addAyat(AyatRange range) async {
    state = const AsyncLoading<Playlist>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      final updated = await ref.read(playlistRepositoryProvider).addItem(
        state.requireValue.id, range,
      );
      return updated;
    });
  }
}
```

### Konsumsi di Widget

```dart
class PlaylistListPage extends ConsumerWidget {
  const PlaylistListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistsAsync = ref.watch(playlistsProvider);

    return Scaffold(
      body: switch (playlistsAsync) {
        AsyncData(:final value) => PlaylistGrid(playlists: value),
        AsyncError(:final error) => ErrorView(message: error.toString()),
        // Skeletonizer wrap widget yang sama — no separate skeleton widget!
        _ => Skeletonizer(
            enabled: true,
            child: PlaylistGrid(playlists: Playlist.mockList()),
          ),
      },
    );
  }
}
```

---

## 10. Navigation — GoRouter dengan Auth Guard

```dart
// lib/core/router/app_router.dart

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    // Auth redirect guard — otomatis cek di setiap navigasi
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/onboarding';
      final isSplash = state.matchedLocation == '/splash';

      if (isSplash) return null;
      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/splash',     builder: (_, __) => const SplashPage()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingPage()),
      GoRoute(path: '/login',      builder: (_, __) => const LoginPage()),
      GoRoute(path: '/register',   builder: (_, __) => const RegisterPage()),

      // ShellRoute untuk bottom NavigationBar — navigatorKey wajib
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
            routes: [
              GoRoute(
                path: ':surahId',
                // detail surah tampil di root navigator (full screen)
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, state) => SurahDetailPage(
                  surahId: int.parse(state.pathParameters['surahId']!),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/playlists',
            builder: (_, __) => const PlaylistListPage(),
            routes: [
              GoRoute(
                path: ':id',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, state) => PlaylistDetailPage(
                  id: state.pathParameters['id']!,
                ),
                routes: [
                  GoRoute(
                    path: 'practice',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (_, state) => PracticePage(
                      playlistId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(path: '/prayer', builder: (_, __) => const PrayerPage()),
          GoRoute(path: '/qibla',  builder: (_, __) => const QiblaPage()),
        ],
      ),
    ],
  );
}
```

### Main Shell — NavigationBar (Material 3)

```dart
// lib/shared/widgets/main_shell.dart

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const _tabs = ['/home', '/quran', '/playlists', '/prayer', '/qibla'];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _tabs.indexWhere((t) => location.startsWith(t));

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(   // Material 3 — bukan BottomNavigationBar
        selectedIndex: currentIndex < 0 ? 0 : currentIndex,
        onDestinationSelected: (i) => context.go(_tabs[i]),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Quran'),
          NavigationDestination(icon: Icon(Icons.playlist_play_outlined), selectedIcon: Icon(Icons.playlist_play), label: 'Playlist'),
          NavigationDestination(icon: Icon(Icons.access_time_outlined), selectedIcon: Icon(Icons.access_time_filled), label: 'Sholat'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Qibla'),
        ],
      ),
    );
  }
}
```

---

## 11. flutter_animate — Panduan Animasi

> `flutter_animate` adalah cara terbaik untuk animasi UI cantik di Flutter.
> Chainable, deklaratif, tanpa `AnimationController` manual.

```dart
// Contoh animasi di SurahListTile saat pertama muncul
SurahListTile(surah: surah)
  .animate(delay: (index * 50).ms)   // stagger per item
  .fadeIn(duration: 300.ms)
  .slideX(begin: 0.05, curve: Curves.easeOut);

// Card playlist muncul dengan scale
PlaylistCard(playlist: playlist)
  .animate()
  .scale(begin: const Offset(0.95, 0.95), duration: 200.ms, curve: Curves.easeOut)
  .fadeIn();

// Tombol "Mulai Latihan" — bounce saat pertama render
ElevatedButton(onPressed: onStart, child: const Text('Mulai Latihan'))
  .animate(onPlay: (c) => c.repeat(reverse: true))
  .shimmer(duration: 1200.ms, color: AppColors.accentLight.withValues(alpha: 0.3));

// Practice Result — celebrasi
Text('Selamat! Hafalan Selesai')
  .animate()
  .fadeIn(duration: 500.ms)
  .then(delay: 200.ms)
  .scale(begin: const Offset(0.8, 0.8), curve: Curves.elasticOut);
```

### Tabel Animasi per Situasi

| Situasi | API flutter_animate | Durasi |
|---------|---------------------|--------|
| List item muncul (stagger) | `.fadeIn().slideX(begin: 0.05)` | 300ms + delay 50ms/item |
| Page transition | `CustomTransitionPage` + `.fadeIn().slideX` | 250ms |
| Card tap feedback | `GestureDetector` + `AnimatedScale` | 100ms |
| FAB muncul | `.scale().fadeIn()` | 200ms |
| Progress bar | `TweenAnimationBuilder` | 400ms |
| Qibla compass | `AnimatedRotation` | 300ms |
| Practice selesai | Lottie fireworks + `.fadeIn().scale(elasticOut)` | 2000ms |
| Skeleton → konten | `Skeletonizer` toggle + `.fadeIn()` | 300ms |

---

## 12. Screen-by-Screen UI Breakdown

### 12.1 Splash Screen

**Elemen visual:**
- Background: `nightGradient` (biru malam gelap)
- Logo: teks "قلبي" (font Amiri, besar) + "Qalby" (Plus Jakarta Sans)
- Subtitle: "Temani Perjalanan Hafalanmu" — italic, gold
- Lottie: `moon_stars.json` — bulan sabit + bintang memutar pelan

```
[nightGradient background]
  [Center]
    Lottie(moon_stars)         ← kecil, di atas logo
    Gap(16)
    Text "قلبي" — Amiri, 48px, white
    Text "Qalby" — PlusJakartaSans, 18px, gold
    Gap(8)
    Text "Temani Perjalanan Hafalanmu" — italic, white 60%
```

---

### 12.2 Onboarding (3 Slide)

```
[PageView — 3 slide]
  Slide 1: "Hafal dengan Caramu"
  Slide 2: "Latihan Setiap Hari"
  Slide 3: "Ibadah Lebih Teratur"

[SmoothPageIndicator]   ← package smooth_page_indicator
  style: WormEffect, activeDotColor: AppColors.primary

[Gap(32)]
[Tombol "Lanjut" / "Mulai" — pill, full width]
[TextButton "Lewati"]
```

---

### 12.3 Auth — Login & Register

```
[Header area — primaryGradient, ClipPath rounded bottom, ~30% tinggi]
  Logo + "Qalby"

[Card form — white, radius xl, shadow tipis, Padding 24]
  Gap(8)
  TextField: Email
  Gap(12)
  TextField: Password (toggle visibility)
  Gap(20)
  AppButton.filled("Masuk") — full width
  Gap(16)
  IslamicDivider("atau")
  Gap(16)
  AppButton.outlined("Masuk dengan Google") — full width
  Gap(24)
  Row: "Belum punya akun?" + TextButton("Daftar")
```

---

### 12.4 Home Page

```
[CustomScrollView]
  [SliverAppBar — pinned, primaryGradient]
    "Assalamu'alaikum," — caption, white 80%
    [Nama User] — headingMedium, white
    [Tanggal Hijriyah dari package hijri] — labelSmall, gold
    [Ornamen geometric SVG — pojok kanan, opacity 10%]

  [SliverToBoxAdapter]
    [PrayerTimeQuickCard — melayang di atas gradient, shadow]
      "Sholat berikutnya: Ashar · 15:30"
      Countdown timer

  [SliverToBoxAdapter — QuickActions horizontal scroll]
    QuickActionChip: Quran | Playlist | Practice | Qibla

  [SliverToBoxAdapter — Section "Playlist Terbaru"]
    [ListView horizontal — PlaylistMiniCard]

  [SliverToBoxAdapter — Section "Rekomendasi"]
    [GridView 2x2 — CategoryCard]
      Motivasi | Doa | Kisah Nabi | Dzikir
```

---

### 12.5 Quran Browser

**Surah List:**
```
[SearchBar — rounded, "Cari surah atau nomor ayat"]
[TabBar: Semua | Juz Amma | Favorit]

[Skeletonizer(enabled: isLoading)]
  [ListView.builder]
    SurahListTile .animate(delay: (i * 30).ms).fadeIn().slideX()
      [Kotak nomor — bg primary, teks gold, bold]
      [Nama Latin — titleCard]
      [Nama Arab — Amiri 18px, align right]
      [Jumlah ayat | Makkiyah/Madaniyah — caption, secondary]
```

**Surah Detail:**
```
[SliverAppBar — expandedHeight 180]
  FlexibleSpaceBar:
    Background: primaryGradient
    Title: nama surah Latin
    Center: nama surah Arab — Amiri 28px, white
    Subtitle: Bismillah kaligrafi — Amiri italic, gold

[SliverList — AyatItemWidget]
  [Nomor ayat Arab dalam lingkaran gold kecil]
  [Teks Arab — RTL, Amiri 26px, line-height 2.0]
  [Terjemahan — body 13px, secondary, collapsible]
  [Divider tipis]
  [Row aksi: Tambah ke Playlist | Bookmark | Share]
```

---

### 12.6 Playlist

**Playlist List:**
```
[AppBar: "Playlist Hafalan"]
[FAB — icon tambah, gold]

[Jika kosong — EmptyStateWidget]
  Ilustrasi: quran_book.svg
  "Belum ada playlist"
  AppButton.filled("Buat Playlist Pertama")

[Jika ada — GridView 2 kolom]
  PlaylistCard .animate().fadeIn().scale()
    [Gradient unik: gold | teal | green | purple (cyclic dari index)]
    [Nama playlist — titleCard, white]
    [Jumlah ayat — caption, white 70%]
    [LinearProgressIndicator tipis di bawah]
    [IconButton tiga titik — menu popup]
```

**Playlist Detail:**
```
[Header besar — goldGradient, padding 24]
  Nama playlist — displayLarge, white
  Deskripsi — body, white 70%
  [Row: X ayat | X sesi]
  AppButton.filled("Mulai Latihan") — di header

[ReorderableListView]
  PlaylistItemTile:
    [Icon drag — 3 garis, textHint]
    [Kotak nomor urut — kecil, bg primary]
    [Nama surah + "Ayat X–Y" — titleCard]
    [Preview teks Arab 1 baris — arabicSmall, secondary]
    [IconButton hapus — merah]

[FAB — tambah ayat]
```

---

### 12.7 Practice Mode

**Practice Page:**
```
[LinearProgressIndicator atas — step X/Y]
[AppBar: "Latihan · Nama Playlist"]

[Expanded — Center]
  Card besar (shadow, radius xl):
    [Nama surah — caption, primary]
    [Range ayat — labelSmall, secondary]
    Gap(16)
    [Teks Arab — RTL, Amiri 28px, center, line-height 2]
    Gap(16)
    [TextButton "Lihat Terjemahan" — collapsible]

Gap(24)

[Counter pengulangan — Row center]
  IconButton("-") | Text("٣ kali", Amiri 24px) | IconButton("+")

Gap(16)

[Row: Sebelumnya | Tandai Selesai (gold) | Berikutnya]
```

**Practice Result:**
```
[Lottie fireworks.json — fullscreen, 2 detik]
[Card summary — center]
  Teks celebrasi + hadis motivasi
  [Row stat: X ayat | X ulangan | X menit]
  Gap(24)
  [AppButton.filled("Ulangi")]
  [AppButton.outlined("Kembali ke Playlist")]
```

---

### 12.8 Prayer Time

```
[Header: tanggal + nama kota]

[Card besar — primaryGradient, radius xl]
  Caption: "Sholat Berikutnya"
  Heading: "Ashar"
  Text jam: "15:30" — displayLarge, white
  Countdown: "dalam 1 jam 23 menit" — gold
  [LinearProgressIndicator — white 30%, dari subuh ke isya]

Gap(20)

[Grid 2x3 — 5 waktu sholat + Jumat]
  PrayerCard (kecil):
    [Ikon: fajar/matahari/ashar/sunset/malam]
    [Nama sholat]
    [Jam — bold]
    [Switch reminder — compact]

Gap(20)

[Section: Atur Reminder]
  Slider offset: menit sebelum azan
```

---

### 12.9 Qibla Compass

```
[Background: radial gradient gelap — darkBackground ke primary 20%]

[Center]
  Stack:
    [Gambar lingkaran kompas — ornamen geometris Islam]
    [AnimatedRotation — arah kiblat]
      [Panah gold — SVG, lurus ke atas = kiblat]
    [Label derajat — labelSmall, gold]

Gap(24)

[Text "Menghadap Ka'bah" — muncul .animate().fadeIn() saat tepat arah]
[Caption instruksi — secondary]
```

---

## 13. Shared Widgets Spec

### AppButton

```dart
// Tiga varian: filled, outlined, text
// Loading state built-in — isLoading: true → CircularProgressIndicator
// Semua shape pill (radius 999)

AppButton.filled(label: 'Masuk', isLoading: isLoading, onPressed: () {});
AppButton.outlined(label: 'Daftar', onPressed: () {});
AppButton.text(label: 'Lupa Password?', onPressed: () {});
```

### ArabicText

```dart
// Widget khusus teks Arab: selalu RTL, font Amiri, textAlign right
ArabicText(
  text: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
  style: AppTextStyles.arabicAyat,
);
```

### IslamicDivider

```dart
// Divider dengan ornamen bintang 8 sudut di tengah
IslamicDivider();           // ――― ✦ ―――
IslamicDivider(label: 'atau');  // ――― atau ―――
```

### EmptyStateWidget

```dart
EmptyStateWidget(
  illustration: 'assets/illustrations/quran_book.svg',
  title: 'Belum ada playlist',
  subtitle: 'Buat playlist pertamamu sekarang',
  action: AppButton.filled(label: 'Buat Playlist', onPressed: () {}),
);
```

---

## 14. Sprint UI Implementation Checklist

### Sprint 1 — Foundation
- [ ] Setup project Flutter dengan struktur folder di bagian 6
- [ ] Tambahkan semua package ke `pubspec.yaml`, jalankan `pub get`
- [ ] Jalankan `dart run build_runner build` — generate Riverpod providers
- [ ] Buat `app_colors.dart`, `app_text_styles.dart`, `app_spacing.dart`
- [ ] Konfigurasi `app_theme.dart` — light + dark (Material 3)
- [ ] Setup `go_router` dengan auth redirect guard
- [ ] Download & daftarkan font (Plus Jakarta Sans, Amiri)
- [ ] Buat shared widgets: `AppButton`, `ArabicText`, `IslamicDivider`, `EmptyStateWidget`
- [ ] Implementasi `SplashPage` + animasi Lottie
- [ ] Implementasi `OnboardingPage` + `SmoothPageIndicator`
- [ ] Implementasi `LoginPage` + `RegisterPage`
- [ ] `AuthNotifier` dengan `@riverpod` + `AsyncNotifier`

### Sprint 2 — Core Features
- [ ] `SurahListPage` + `SurahListTile` + `Skeletonizer` loading
- [ ] `SurahDetailPage` dengan `SliverAppBar` collapse + `AyatItemWidget` RTL
- [ ] `PlaylistListPage` dengan `EmptyStateWidget` + `GridView`
- [ ] `PlaylistDetailPage` + `ReorderableListView`
- [ ] `AddAyatPage` — pilih surah + range ayat
- [ ] `flutter_animate` stagger di semua list page

### Sprint 3 — Practice & Home
- [ ] `PracticePage` — ayat card + counter + step progress
- [ ] `PracticeResultPage` — Lottie fireworks + summary card
- [ ] `HomePage` — `CustomScrollView` dengan greeting header gradient
- [ ] `NavigationBar` M3 di `MainShell`
- [ ] Integrasi `hijri` untuk tanggal Hijriyah di header

### Sprint 4 — Secondary Features
- [ ] `PrayerPage` — countdown card + grid 5 waktu + toggle reminder
- [ ] Integrasi `adhan` (offline, tanpa API)
- [ ] `QiblaPage` — `AnimatedRotation` + ornamen Islamic kompas
- [ ] Push notification setup (FCM via backend)
- [ ] Dark mode support penuh — test di kedua tema

---

## 15. Do & Don't

### DO
- Gunakan `const` constructor semaksimal mungkin — performa widget rebuild
- Selalu `textDirection: TextDirection.rtl` untuk semua teks Arab
- Gunakan `SafeArea` di semua page root
- Gunakan `Gap(n)` dari package `gap` — lebih semantik dari `SizedBox`
- `Skeletonizer` untuk loading state — tidak perlu widget skeleton terpisah
- `flutter_animate` untuk semua animasi UI — hindari `AnimationController` manual
- `@riverpod` + `AsyncNotifier` untuk semua state async — bukan `StateNotifier`
- Jalankan `build_runner watch` selama development
- Gunakan `switch` expression untuk handle `AsyncValue` (Dart 3+)

### DON'T
- Jangan hardcode `Color(0xFF...)` di widget — selalu pakai `AppColors`
- Jangan hardcode ukuran font — pakai `AppTextStyles`
- Jangan pakai `BottomNavigationBar` — sudah M2, pakai `NavigationBar`
- Jangan tulis provider Riverpod manual tanpa `@riverpod` annotation
- Jangan pakai `StateNotifier` — sudah deprecated, pakai `AsyncNotifier`/`Notifier`
- Jangan letakkan logika bisnis di widget — pisahkan ke Riverpod notifier
- Jangan lupa `dispose` controller manual jika masih perlu (TextEditingController)
- Jangan pakai `double.infinity` tanpa `LayoutBuilder` — error di context tertentu

---

## 16. Design Reference & Inspirasi

Cari di Dribbble/Behance:
- `"Islamic app UI Flutter"`
- `"Quran app dark UI"`
- `"Muslim prayer app design"`
- `"Arabic typography mobile"`

Tone referensi:
- **Muslim Pro** — untuk konten dan fitur
- **Notion** — untuk kebersihan layout
- **Headspace** — untuk ketenangan visual dan animasi
