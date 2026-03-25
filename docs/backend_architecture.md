# Qalby Backend Architecture Design

## 1. Overview

```
Flutter App
     |
     | HTTPS REST API
     v
FastAPI Backend
     |
     |-- Firebase Auth (verify token)
     |-- Firestore (database)
     |-- FCM (push notification)
     |-- Firebase Storage (audio files)
     |-- AI Service (future: tajweed correction)
```

Semua request dari Flutter melewati FastAPI. Firebase hanya diakses
oleh backend via Firebase Admin SDK — Flutter tidak pernah hit Firebase langsung.

---

## 2. Tech Stack Backend

| Layer | Teknologi |
|-------|-----------|
| Framework | FastAPI (Python) |
| Auth | Firebase Auth (token verification) |
| Database | Firestore |
| File Storage | Firebase Storage |
| Push Notif | Firebase Cloud Messaging (FCM) |
| Deployment | Railway / Render (free tier) |
| AI (future) | OpenAI Whisper / Gemini API |

---

## 3. Struktur Folder Backend

```
qalby-backend/
├── app/
│   ├── main.py                  # entry point, register routers
│   ├── core/
│   │   ├── config.py            # env vars, settings
│   │   ├── firebase.py          # firebase admin SDK init
│   │   └── dependencies.py      # shared dependencies (auth middleware)
│   ├── features/
│   │   ├── auth/
│   │   │   ├── router.py        # POST /auth/register, POST /auth/login
│   │   │   └── service.py
│   │   ├── quran/
│   │   │   ├── router.py        # GET /quran/surahs, GET /quran/surah/:id
│   │   │   └── service.py
│   │   ├── playlist/
│   │   │   ├── router.py        # CRUD /playlists
│   │   │   ├── service.py
│   │   │   └── models.py
│   │   ├── practice/
│   │   │   ├── router.py        # POST /practice/session, GET /practice/progress
│   │   │   └── service.py
│   │   ├── prayer/
│   │   │   ├── router.py        # GET /prayer/times, POST /prayer/reminder
│   │   │   └── service.py
│   │   └── ai/                  # future
│   │       ├── router.py        # POST /ai/correct-recitation
│   │       └── service.py
│   └── shared/
│       ├── models.py            # shared Pydantic models
│       └── utils.py
├── tests/
├── .env
├── requirements.txt
└── Dockerfile
```

---

## 4. API Endpoints

### Auth
```
POST   /auth/register          # daftar akun baru
POST   /auth/verify-token      # verify Firebase token, return user profile
GET    /auth/profile           # get profile user
PUT    /auth/profile           # update profile
```

### Quran
```
GET    /quran/surahs           # list semua surah (114)
GET    /quran/surahs/:id       # detail surah + list ayat
GET    /quran/surahs/:id/ayat  # ayat dalam surah (bisa filter range)
```
> Data Quran bersifat static. Pertimbangkan cache di backend
> agar tidak hit Firestore berulang kali.

### Playlist
```
GET    /playlists              # list playlist milik user
POST   /playlists              # buat playlist baru
GET    /playlists/:id          # detail playlist + isi ayat
PUT    /playlists/:id          # update nama/deskripsi playlist
DELETE /playlists/:id          # hapus playlist

POST   /playlists/:id/items    # tambah ayat (range) ke playlist
PUT    /playlists/:id/items/reorder  # ubah urutan
DELETE /playlists/:id/items/:item_id # hapus ayat dari playlist
```

### Practice
```
POST   /practice/sessions             # mulai sesi hafalan
PUT    /practice/sessions/:id         # update progress sesi
GET    /practice/sessions             # riwayat sesi
GET    /practice/progress/surah/:id   # progress per surah
GET    /practice/stats                # statistik keseluruhan
```

### Prayer
```
GET    /prayer/times?lat=&lng=&date=  # jadwal sholat berdasarkan lokasi
POST   /prayer/reminders              # set reminder sholat
GET    /prayer/reminders              # list reminder aktif
DELETE /prayer/reminders/:id          # hapus reminder
```

### Recommendation (static MVP)
```
GET    /recommendations               # list kategori rekomendasi
GET    /recommendations/:category     # konten per kategori
```

### AI (future)
```
POST   /ai/recitation/correct         # upload audio, return koreksi tajweed
GET    /ai/recitation/sessions        # riwayat koreksi
```

---

## 5. Data Models (Firestore Collections)

### Collection: users
```
users/{uid}
├── uid: string
├── email: string
├── display_name: string
├── photo_url: string
├── fcm_token: string          # untuk push notification
├── created_at: timestamp
└── updated_at: timestamp
```

### Collection: playlists
```
playlists/{playlist_id}
├── id: string
├── user_id: string            # ref ke users
├── name: string
├── description: string
├── items: [                   # array of ayat range
│   {
│     item_id: string,
│     surah_id: number,
│     surah_name: string,
│     ayat_start: number,
│     ayat_end: number,
│     order: number
│   }
│ ]
├── created_at: timestamp
└── updated_at: timestamp
```

### Collection: practice_sessions
```
practice_sessions/{session_id}
├── id: string
├── user_id: string
├── playlist_id: string
├── started_at: timestamp
├── ended_at: timestamp
├── items_progress: [
│   {
│     item_id: string,
│     surah_id: number,
│     ayat_start: number,
│     ayat_end: number,
│     repetitions: number,    # berapa kali diulang
│     status: string          # "not_started"|"in_progress"|"done"
│   }
│ ]
└── notes: string
```

### Collection: prayer_reminders
```
prayer_reminders/{reminder_id}
├── id: string
├── user_id: string
├── prayer_name: string        # "fajr"|"dhuhr"|"asr"|"maghrib"|"isha"
├── offset_minutes: number     # menit sebelum/sesudah waktu sholat
├── is_active: boolean
├── created_at: timestamp
└── updated_at: timestamp
```

---

## 6. Auth Flow

```
1. Flutter kirim request login ke FastAPI
        POST /auth/verify-token { id_token: "..." }

2. FastAPI verify token via Firebase Admin SDK
        firebase_admin.auth.verify_id_token(id_token)

3. Jika valid, FastAPI return user profile
        { uid, email, display_name, ... }

4. Semua request selanjutnya kirim token di header
        Authorization: Bearer <id_token>

5. FastAPI middleware verify token di setiap protected endpoint
```

---

## 7. Request/Response Standard

Semua response menggunakan format konsisten:

```json
// Success
{
  "success": true,
  "data": { ... },
  "message": "optional message"
}

// Error
{
  "success": false,
  "error": {
    "code": "PLAYLIST_NOT_FOUND",
    "message": "Playlist tidak ditemukan"
  }
}
```

---

## 8. Environment Variables

```env
# Firebase
FIREBASE_PROJECT_ID=qalby-xxxxx
FIREBASE_PRIVATE_KEY=...
FIREBASE_CLIENT_EMAIL=...

# Prayer Time API (external)
PRAYER_TIME_API_URL=https://api.aladhan.com/v1

# AI (future)
OPENAI_API_KEY=...
GEMINI_API_KEY=...

# App
APP_ENV=development
APP_PORT=8000
```

---

## 9. External API

### Prayer Time
Gunakan **Aladhan API** (gratis, no API key):
```
GET https://api.aladhan.com/v1/timings/{date}?latitude={lat}&longitude={lng}&method=11
```
Method 11 = Kemenag Indonesia.

### Quran Data
Gunakan **Al-Quran Cloud API** (gratis):
```
GET https://api.alquran.cloud/v1/surah          # list surah
GET https://api.alquran.cloud/v1/surah/{id}     # detail + ayat
```
> Data ini bisa di-cache di Firestore saat pertama kali diakses
> agar tidak selalu hit external API.

---

## 10. Development Phases

### Phase 1 (MVP - bersamaan dengan Flutter dev)
- [ ] Setup FastAPI project structure
- [ ] Firebase Admin SDK integration
- [ ] Auth endpoints
- [ ] Quran endpoints (dengan caching)
- [ ] Playlist CRUD
- [ ] Practice session

### Phase 2 (Secondary Features)
- [ ] Prayer time integration
- [ ] FCM push notification
- [ ] Recommendation static content

### Phase 3 (Future)
- [ ] AI recitation correction
- [ ] Smart recommendation
- [ ] Adaptive reminder

---

## 11. Catatan untuk Frontend Development

Saat development Flutter, gunakan **mock data / hardcode response** dulu
agar tidak blocking. Kontrak API sudah jelas di atas — Flutter tinggal
menyesuaikan model dengan response yang sudah didefinisikan.

Base URL untuk development:
```
DEV:  http://localhost:8000
PROD: https://qalby-api.railway.app (nanti)
```
