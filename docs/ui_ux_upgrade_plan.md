# Qalby — UI/UX Upgrade Plan

> Dokumen ini berisi rencana peningkatan UI dan UX secara paralel dengan Sprint 6 (Backend Integration).
> Target: menaikkan score dari **6.9 → 8.5+** dalam 3 fase.
>
> **Current Score (2026-03-25):** UI 7.5 / UX 6.2 / Overall 6.9
> **Target Score:** UI 8.8 / UX 8.2 / Overall 8.5

---

## Ringkasan Masalah yang Ditemukan

| Kategori | Masalah | Severity |
|----------|---------|----------|
| UX | Data playlist hilang saat app restart (in-memory only) | Critical |
| UI | Header inconsistency — Prayer/Qibla gradient, Playlist/Quran plain | High |
| UI | Dark mode tidak ada (warna terdefinisi tapi tidak dipakai) | High |
| UX | Tidak ada skeleton loading — transisi tiba-tiba | Medium |
| UX | Swipe navigation tidak ada affordance hint | Medium |
| UX | Tidak ada inline validation di form create playlist | Medium |
| UI | Surah detail page belum dipolish | Medium |
| UX | Tidak ada onboarding tooltip untuk fitur tersembunyi | Medium |
| UX | Audio tidak auto-stop saat keluar halaman | Low |
| UX | Aksesibilitas (Semantics, text scaling) belum diperhatikan | Low |

---

## Fase 1 — Critical Fixes (Paralel Sprint 6)

> Dikerjakan bersamaan saat backend integration berjalan.
> Estimasi: selesai sebelum Sprint 6 selesai.

### F1.1 — Dark Mode Support

**File yang diubah:**
- `lib/core/theme/app_theme.dart` — tambah `darkTheme`
- `lib/main.dart` — `themeMode` dari provider
- `lib/core/theme/app_colors.dart` — dark semantic aliases

**Pendekatan:**
```dart
// Tambah dark semantic colors
static Color background(BuildContext ctx) =>
    ctx.isDark ? darkBackground : surface;
static Color card(BuildContext ctx) =>
    ctx.isDark ? darkCard : surfaceCard;
```

**Komponen yang perlu adaptasi:**
- Semua `Container(color: AppColors.surface)` → `AppColors.background(context)`
- Surah card, Playlist card, Prayer card, Dzikir card
- AppBar background
- Bottom nav bar

**Provider:**
```dart
// lib/core/theme/theme_provider.dart
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>
  → persist ke SharedPreferences
  → toggle di Settings page (baru)
```

---

### F1.2 — Header Visual Consistency

Saat ini Prayer & Qibla punya gradient header, halaman lain pakai plain AppBar.

**Target:** Semua halaman utama punya gradient header yang sesuai.

| Halaman | Kondisi Sekarang | Target |
|---------|-----------------|--------|
| Home | Gradient (bagus) | Pertahankan |
| Quran List | Plain AppBar | Gradient biru + surah counter |
| Playlist List | Plain AppBar | Gradient primary + jumlah playlist |
| Prayer | Gradient (bagus) | Pertahankan |
| Qibla | Gradient night (bagus) | Pertahankan |

**Implementasi:**
Buat `_GradientPageHeader` widget reusable:
```dart
class GradientPageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final LinearGradient gradient;
  final List<Widget>? actions;
  final Widget? bottom;
}
```

---

### F1.3 — Skeleton Loading

Ganti `CircularProgressIndicator` di halaman loading menjadi skeleton shimmer.

**Halaman yang perlu:**
- `SurahListPage` — skeleton tile (nomor + nama + tipe)
- `SurahDetailPage` — skeleton ayat cards
- `PlaylistListPage` — skeleton playlist cards
- `PrayerPage` — skeleton 5 prayer cards

**Package:** Gunakan `shimmer: ^3.0.0` (sudah umum, ringan)

**Pola:**
```dart
// Skeleton tile reusable
class _SkeletonTile extends StatelessWidget {
  // Shimmer box dengan warna AppColors.divider
  // Dimensi sesuai tile aslinya agar tidak ada layout shift
}
```

---

## Fase 2 — UX Polish (Minggu 2)

### F2.1 — Swipe Affordance Hint di Practice Page

Pengguna tidak tahu bahwa swipe kiri/kanan tersedia.

**Solusi:** Tampilkan hint sekali (first launch) menggunakan `shared_preferences`.

```dart
// Muncul pertama kali buka Practice Page
// Overlay animasi: panah kanan kiri bergerak
// Auto-dismiss setelah 2 detik atau saat user swipe
class _SwipeHintOverlay extends StatefulWidget {
  // Fade in → tunggu 1.5s → fade out
  // Simpan 'practice_hint_shown' = true ke SharedPreferences
}
```

---

### F2.2 — Form Validation & Feedback

Saat buat playlist baru, tidak ada feedback error jika nama kosong.

**Perbaikan di `PlaylistListPage._showCreateDialog`:**
- Tambah `_nameError` state
- Real-time validation saat user ketik
- Shake animation jika submit dengan nama kosong
- Karakter counter (max 50)

---

### F2.3 — Pull-to-Refresh

Tambah `RefreshIndicator` di:
- `PlaylistListPage` → `ref.read(playlistsProvider.notifier).refresh()`
- `SurahListPage` → invalidate provider
- `PrayerPage` → `ref.invalidate(prayerTimesProvider)`

---

### F2.4 — Surah Detail Page Polish

Berdasarkan kode yang ada, perlu:
- Sticky surah name header saat scroll
- Ayat highlight saat tap (ripple + background flash)
- "Kembali ke atas" floating button (muncul setelah scroll 3+ ayat)
- Nomor ayat lebih jelas (badge seperti octagon di surah list)

---

### F2.5 — Playlist Detail Polish

Tambah:
- Header summary dengan progress ring (circular progress indicator besar)
- Estimasi waktu latihan: `items.length * 3 menit`
- Tombol "Lanjutkan" jika ada progress sebelumnya (bukan selalu "Mulai")
- Swipe-to-delete item playlist (Dismissible widget)

---

### F2.6 — Empty States yang Lebih Kontekstual

Setiap halaman punya empty state berbeda:

| Halaman | Empty State Message | Icon |
|---------|-------------------|------|
| Playlist List | "Belum ada playlist\nBuat playlist pertama untuk mulai hafal" | playlist_play |
| Playlist Detail | "Playlist masih kosong\nTambah ayat dari Al-Quran" | add_circle |
| Motivasi (filter kosong) | "Tidak ada kutipan kategori ini" | format_quote |
| Doa (kategori kosong) | "Belum ada doa kategori ini" | volunteer_activism |

---

## Fase 3 — Delight & Accessibility (Minggu 3)

### F3.1 — Micro-interactions

| Komponen | Interaksi |
|----------|-----------|
| FAB di Playlist | Scale bounce saat pertama muncul (sudah ada, pertahankan) |
| Practice counter + | Angka pop scale + haptic (sudah ada) |
| Checkbox Sunnah | Checkmark draw animation (path animation) |
| Dzikir counter | Circle fill animation saat tap |
| Prayer card toggle | Ripple yang mengikuti warna prayer |
| Playlist card | Gentle scale 0.98 saat ditekan (InkWell splash) |

---

### F3.2 — Accessibility

**Minimum viable accessibility:**
```dart
// Setiap tombol interaktif perlu:
Semantics(
  label: 'Tandai sholat Subuh selesai',
  button: true,
  child: Switch(...)
)

// Setiap gambar/icon dekoratif:
ExcludeSemantics(child: Icon(...))

// Teks Arab:
Semantics(
  label: 'Teks Arab ayat ${a.number}',
  child: ArabicText(...)
)
```

**Target:** Lulus audit `flutter_accessibility_service` basic check.

---

### F3.3 — Settings Page (Baru)

Halaman pengaturan sederhana sebagai entry point untuk:

```
Settings
├── Tampilan
│   ├── Dark Mode toggle
│   └── Ukuran font Arab (S / M / L / XL)
├── Notifikasi
│   └── Shortcut ke toggle adzan (sudah ada di Prayer page)
├── Tentang
│   ├── Versi app
│   └── Credits
```

**Route:** `/settings` dari Home page (icon ⚙ di AppBar)

---

### F3.4 — Onboarding Tooltip (Feature Discovery)

Gunakan `showcaseview` package untuk tooltip kontekstual:

| Halaman | Fitur yang di-highlight | Kapan muncul |
|---------|------------------------|--------------|
| Practice | Swipe kiri/kanan | First time buka practice |
| Surah Detail | Tajwid mode toggle | First time buka surah |
| Dzikir | Tap counter + tahan reset | First time buka dzikir |
| Qibla | Putar perangkat | First time buka qibla |

---

## Tracking Progress

| ID | Task | Fase | Status | Impact Score | Tanggal Selesai |
|----|------|------|--------|-------------|-----------------|
| U1 | Dark Mode | F1.1 | ✅ Selesai | +0.8 | 2026-03-25 |
| U2 | Header Consistency | F1.2 | ✅ Selesai | +0.4 | 2026-03-25 |
| U3 | Skeleton Loading | F1.3 | ✅ Selesai | +0.4 | 2026-03-25 |
| U4 | Swipe Hint Overlay | F2.1 | ✅ Selesai | +0.2 | 2026-03-25 |
| U5 | Form Validation | F2.2 | ✅ Selesai | +0.2 | 2026-03-25 |
| U6 | Pull-to-Refresh | F2.3 | ✅ Selesai | +0.2 | 2026-03-25 |
| U7 | Surah Detail Polish | F2.4 | ✅ Selesai | +0.3 | 2026-03-25 |
| U8 | Playlist Detail Polish | F2.5 | ✅ Selesai | +0.3 | 2026-03-25 |
| U9 | Empty States Kontekstual | F2.6 | ✅ Selesai | +0.1 | 2026-03-25 |
| U10 | Micro-interactions | F3.1 | ✅ Selesai | +0.3 | 2026-03-25 |
| U11 | Accessibility | F3.2 | ✅ Selesai | +0.4 | 2026-03-25 |
| U12 | Settings Page | F3.3 | ✅ Selesai | +0.2 | 2026-03-25 |
| U13 | Onboarding Tooltip | F3.4 | ✅ Selesai | +0.2 | 2026-03-25 |

**Total estimasi kenaikan score: +4.0 → target 6.9 + 4.0 = ~8.5+**

### Catatan Implementasi

**U1 — Dark Mode:** `ThemeModeNotifier` dengan 3-way toggle (system/light/dark), persist ke SharedPreferences. Adaptive color helpers: `bgCard(ctx)`, `borderColor(ctx)`, `textPri(ctx)`, `textSec(ctx)`.

**U3 — Skeleton Loading:** Menggunakan `skeletonizer ^2.0.0` (sudah ada di pubspec). Dummy data `_skeletonPlaylists` + `playlistsIsLoadingProvider` sebagai state companion.

**U4 — Swipe Hint:** `_SwipeHintOverlay` dengan animated arrows, auto-dismiss 3 detik, persist `practice_swipe_hint_shown` ke SharedPreferences. Dismiss juga saat swipe pertama kali.

**U8 — Playlist Detail:** `_ProgressRing` dengan `CustomPainter` (arc progress), `_RingPainter`. Dismissible swipe-to-delete dengan red background. Tombol "Lanjutkan Latihan" adaptif.

**U10 — Micro-interactions:** Scale press (`AnimatedScale` 0.97) di playlist card + dzikir card. Checkmark bounce di sunnah tracker (`.animate().scale(elasticOut)`). Progress circle fill di dzikir card (`TweenAnimationBuilder` + `CircularProgressIndicator`).

**U12 — Settings Page:** `/settings` route dari Home AppBar (icon settings). 3-way theme chip (Sistem/Terang/Gelap), about section.

**U13 — Onboarding Tooltip:** Custom `CoachMarkController` + `OverlayEntry` tanpa package tambahan. Spotlight highlight + callout bubble. Persist per-tour dengan prefix `coach_mark_shown_`. Home page tour: settings icon → playlist section.

---

## Urutan Prioritas Pengerjaan

```
[SEKARANG - paralel Sprint 6]
1. U3 Skeleton Loading          ← paling mudah, impact langsung terlihat
2. U2 Header Consistency        ← visual improvement cepat
3. U6 Pull-to-Refresh           ← butuh backend integration
4. U5 Form Validation           ← improve existing form

[SETELAH Sprint 6 selesai]
5. U1 Dark Mode                 ← besar, butuh refactor theme di semua file
6. U7 Surah Detail Polish       ← medium effort
7. U8 Playlist Detail Polish    ← medium effort
8. U12 Settings Page            ← entry point untuk dark mode

[FINISHING TOUCHES]
9.  U4 Swipe Hint               ← kecil tapi delight
10. U10 Micro-interactions      ← per komponen
11. U9 Empty States             ← per halaman
12. U13 Onboarding Tooltip      ← butuh package baru
13. U11 Accessibility           ← audit menyeluruh
```

---

## Dependencies Baru yang Dibutuhkan

```yaml
# pubspec.yaml — tambahkan saat fase masing-masing
shimmer: ^3.0.0          # F1.3 Skeleton loading
showcaseview: ^3.0.0     # F3.4 Onboarding tooltip
```

Dark mode dan fitur lainnya tidak butuh package baru — cukup refactor kode yang ada.

---

*Dibuat: 2026-03-25 | Berkaitan dengan: feature_progress.md, flutter_ui_guide.md*
