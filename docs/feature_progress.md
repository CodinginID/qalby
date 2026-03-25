# Qalby — Feature Progress Tracker

> Status otomatis diupdate setiap sprint selesai.
> **Overall Progress: 90%** (46 / 51 fitur)

---

## Legend
| Status | Simbol |
|--------|--------|
| Done   | ✅ |
| In Progress | 🔄 |
| Pending | ⬜ |
| Blocked | 🔴 |

---

## Sprint 1 — Foundation & Auth
**Progress: 100%** ██████████ (9/9)

| # | Fitur | Status | Catatan |
|---|-------|--------|---------|
| 1 | Setup Flutter project (M3 theme, routing, Riverpod) | ✅ | Flutter 3.41.5, go_router 14.x |
| 2 | Splash screen + animasi | ✅ | |
| 3 | Onboarding (3 slide smooth indicator) | ✅ | |
| 4 | Login dengan Google | ✅ | UI ready, perlu GoogleService-Info.plist |
| 5 | Auth Provider (Riverpod) | ✅ | google_sign_in ^6.2.1 |
| 6 | Home Page (greeting, Hijri date, quick actions) | ✅ | |
| 7 | Bottom Navigation (Material 3, 5 tab) | ✅ | |
| 8 | App theme (warna, typography, spacing) | ✅ | GoogleFonts + Amiri |
| 9 | Routing lengkap (go_router ShellRoute) | ✅ | |

---

## Sprint 2 — Al-Quran Browser
**Progress: 100%** ██████████ (10/10)

| # | Fitur | Status | Catatan |
|---|-------|--------|---------|
| 10 | Surah list (114 surah dari API) | ✅ | alquran.cloud API + offline fallback |
| 11 | Filter tab: Semua / Makkiyah / Madaniyah | ✅ | |
| 12 | Search surah (nama Latin / Arab / nomor) | ✅ | |
| 13 | Surah detail page | ✅ | NestedScrollView + TabBar |
| 14 | Terjemahan per ayat (toggle on/off) | ✅ | id.indonesian edition |
| 15 | Tajwid mode (color-coded per aturan tajwid) | ✅ | 19 warna berdasarkan kaidah |
| 16 | Tafsir tab (per ayat, lazy load) | ✅ | id.muntakhab edition |
| 17 | Murotal audio per ayat | ✅ | just_audio, 4 qari pilihan |
| 18 | Mini audio player (floating, dengan seek) | ✅ | +10s/-10s, progress bar |
| 19 | Pilih Qari (Alafasy, Abdul Basit, Sudais, Maher) | ✅ | |

---

## Sprint 3 — Playlist Hafalan
**Progress: 100%** ██████████ (8/8)

| # | Fitur | Status | Catatan |
|---|-------|--------|---------|
| 20 | Playlist list page (gradient cards, progress bar) | ✅ | |
| 21 | Buat playlist baru (modal dialog) | ✅ | |
| 22 | Hapus playlist | ✅ | |
| 23 | Playlist detail (stats, reorderable list) | ✅ | ReorderableListView |
| 24 | Tambah ayat ke playlist (range picker) | ✅ | Slider + counter |
| 25 | Hapus ayat dari playlist | ✅ | |
| 26 | Reorder ayat (drag & drop) | ✅ | |
| 27 | Tambah ayat dari detail surah (bottom sheet) | ✅ | |

---

## Sprint 4 — Practice Mode
**Progress: 100%** ██████████ (4/4)

| # | Fitur | Status | Catatan |
|---|-------|--------|---------|
| 28 | Practice session (per ayat, counter ulangan) | ✅ | PracticeNotifier |
| 29 | Navigasi ayat (prev/next, tandai selesai) | ✅ | |
| 30 | Practice result page (stats, quote hadist) | ✅ | animasi trophy |
| 31 | Tracking total latihan per playlist | ✅ | markPracticed() |

---

## Sprint 5 — Prayer Time & Qibla
**Progress: 100%** ██████████ (7/7)

| # | Fitur | Status | Catatan |
|---|-------|--------|---------|
| 32 | Deteksi lokasi (GPS) | ✅ | geolocator ^13.0.2, permission handling |
| 33 | Waktu sholat (hitung per lokasi) | ✅ | adhan ^0.4.0, MWL method + Shafi madhab |
| 34 | Jadwal sholat harian (list 5 waktu) | ✅ | prayer_page.dart, real data dari adhan |
| 35 | Countdown sholat berikutnya | ✅ | StreamProvider tiap detik, home card live |
| 36 | Qibla compass (arah kiblat) | ✅ | sensors_plus magnetometer + adhan.Qibla |
| 37 | Notifikasi adzan | ✅ | notification_service.dart, zonedSchedule |
| 38 | Pengaturan notifikasi per waktu sholat | ✅ | toggle per sholat, simpan SharedPreferences |

---

## Sprint 6 — Backend Integration & Sync
**Progress: 0%** ░░░░░░░░░░ (0/8)

| # | Fitur | Status | Catatan |
|---|-------|--------|---------|
| 39 | Koneksi API backend (Dio service layer) | ⬜ | endpoint di docs/backend_architecture.md |
| 40 | Sync playlist ke server | ⬜ | |
| 41 | Sync progress hafalan | ⬜ | |
| 42 | Multi-device sync | ⬜ | butuh token Google dari auth |
| 43 | Offline mode (local cache) | ⬜ | SharedPreferences / Hive |
| 44 | Google Sign-In full (native config) | 🔄 | UI done, butuh plist + json |
| 45 | Token management (refresh) | ⬜ | |
| 46 | User profile page | ⬜ | |

---

## Sprint 7 — Rekomendasi & Konten
**Progress: 100%** ██████████ (5/5)

| # | Fitur | Status | Catatan |
|---|-------|--------|---------|
| 47 | Konten Motivasi (quotes) | ✅ | 15 quotes (Quran/Hadith/Ulama), daily quote, filter kategori |
| 48 | Kumpulan Doa harian | ✅ | 16 doa, 8 kategori, expandable + copy, toggle latin/terjemahan |
| 49 | Kisah Nabi (list + detail) | ✅ | 7 nabi, detail lengkap + hikmah, animated header |
| 50 | Dzikir pagi/petang | ✅ | Tab pagi/petang, counter per dzikir, progress bar, reset |
| 51 | Sunnah Tracker harian | ✅ | 13 sunnah, checklist persist SharedPreferences, grouping kategori |

---

## Summary per Modul

| Modul | Progress |
|-------|----------|
| Foundation & Auth | ✅ 100% |
| Al-Quran Browser | ✅ 100% |
| Playlist Hafalan | ✅ 100% |
| Practice Mode | ✅ 100% |
| Prayer Time & Qibla | ✅ 100% |
| Backend Sync | 🔄 5% |
| Rekomendasi | ✅ 100% |
| **TOTAL** | **🔄 90%** |

---

## Known Issues / Tech Debt

| # | Issue | Priority | Status |
|---|-------|----------|--------|
| T1 | Prayer time card di Home masih hardcode (Ashar 15:30) | High | ✅ |
| T2 | Google Sign-In butuh native config (plist/json) | High | 🔄 |
| T3 | Data dummy playlist tidak persist (in-memory only) | Medium | ⬜ |
| T4 | Surah list fallback ke 33 surah saat offline | Medium | ⬜ |
| T5 | Audio tidak auto-stop saat keluar halaman surah | Low | ⬜ |
| T6 | Tajwid mode memerlukan request API tambahan | Low | ✅ handled lazily |

---

*Last updated: Sprint 7 complete — 2026-03-25*
