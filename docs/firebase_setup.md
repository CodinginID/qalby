# Firebase Setup Guide - Qalby

## Langkah 1: Buat Firebase Project

1. Buka https://console.firebase.google.com
2. Klik **"Add project"**
3. Nama project: `qalby`
4. Matikan Google Analytics (tidak dibutuhkan untuk MVP)
5. Klik **"Create project"**

---

## Langkah 2: Aktifkan Firestore

1. Di sidebar kiri, klik **"Firestore Database"**
2. Klik **"Create database"**
3. Pilih **"Start in production mode"**
4. Pilih region: `asia-southeast1` (Singapore, terdekat dari Indonesia)
5. Klik **"Enable"**

---

## Langkah 3: Aktifkan Authentication

1. Di sidebar kiri, klik **"Authentication"**
2. Klik **"Get started"**
3. Tab **"Sign-in method"**, aktifkan:
   - **Email/Password** → Enable → Save
   - **Google** → Enable → masukkan nama project & email support → Save

---

## Langkah 4: Aktifkan Firebase Storage

1. Di sidebar kiri, klik **"Storage"**
2. Klik **"Get started"**
3. Pilih **"Start in production mode"**
4. Pilih region yang sama: `asia-southeast1`
5. Klik **"Done"**

---

## Langkah 5: Ambil Service Account (untuk Backend)

1. Klik ikon gear (⚙️) di sidebar → **"Project settings"**
2. Tab **"Service accounts"**
3. Pastikan **"Firebase Admin SDK"** dipilih
4. Klik **"Generate new private key"**
5. Klik **"Generate key"** → file JSON akan terdownload
6. Buka file JSON tersebut, salin nilai berikut ke `.env`:

```
file JSON hasil download:
{
  "type": "service_account",
  "project_id": "...",          → FIREBASE_PROJECT_ID
  "private_key_id": "...",      → FIREBASE_PRIVATE_KEY_ID
  "private_key": "...",         → FIREBASE_PRIVATE_KEY
  "client_email": "...",        → FIREBASE_CLIENT_EMAIL
  "client_id": "...",           → FIREBASE_CLIENT_ID
  ...
}
```

**PENTING:** Jangan commit file JSON ini ke git. Sudah ada di `.gitignore`.

---

## Langkah 6: Deploy Firestore Rules & Indexes

Install Firebase CLI dulu (sekali saja):
```bash
npm install -g firebase-tools
firebase login
```

Lalu dari folder `app/api/`:
```bash
firebase use --add
# pilih project qalby yang baru dibuat

firebase deploy --only firestore:rules
firebase deploy --only firestore:indexes
```

Rules ini memastikan **tidak ada akses langsung dari client** ke Firestore —
semua request wajib lewat backend FastAPI.

---

## Langkah 7: Isi .env Backend

```bash
cd app/api
cp .env.example .env
```

Edit `.env` dan isi dengan nilai dari file JSON service account:

```env
FIREBASE_PROJECT_ID=qalby-xxxxx
FIREBASE_PRIVATE_KEY_ID=xxxxx
FIREBASE_PRIVATE_KEY="-----BEGIN RSA PRIVATE KEY-----\n...\n-----END RSA PRIVATE KEY-----\n"
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@qalby-xxxxx.iam.gserviceaccount.com
FIREBASE_CLIENT_ID=xxxxx
```

**Catatan untuk FIREBASE_PRIVATE_KEY:**
Salin seluruh nilai `private_key` dari JSON termasuk `-----BEGIN...-----END-----`,
pastikan newline ditulis sebagai `\n` dan nilai dibungkus tanda kutip.

---

## Langkah 8: Test Backend

```bash
cd app/api
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

Buka http://localhost:8000/docs — Swagger UI akan muncul.

Test endpoint health:
```
GET http://localhost:8000/health
```

Response:
```json
{ "status": "ok" }
```

---

## Checklist

- [ ] Firebase project dibuat
- [ ] Firestore aktif (region asia-southeast1)
- [ ] Authentication aktif (Email/Password + Google)
- [ ] Firebase Storage aktif
- [ ] Service account key didownload
- [ ] Firestore rules di-deploy
- [ ] Firestore indexes di-deploy
- [ ] File `.env` sudah diisi
- [ ] Backend bisa jalan (`uvicorn app.main:app --reload`)
