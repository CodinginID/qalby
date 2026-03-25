from fastapi import APIRouter, Depends, HTTPException

from app.core.dependencies import get_current_user
from app.core.config import settings
from app.shared.models import ok

router = APIRouter(prefix="/recommendations", tags=["recommendation"])

# Static content untuk MVP
RECOMMENDATIONS = {
    "doa_harian": {
        "category": "doa_harian",
        "title": "Doa Harian",
        "items": [
            {"title": "Doa Sebelum Tidur", "arabic": "بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا", "translation": "Dengan nama-Mu ya Allah aku mati dan hidup"},
            {"title": "Doa Bangun Tidur", "arabic": "الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا", "translation": "Segala puji bagi Allah yang telah menghidupkan kami"},
        ],
    },
    "dzikir_pagi_petang": {
        "category": "dzikir_pagi_petang",
        "title": "Dzikir Pagi & Petang",
        "items": [
            {"title": "Ayat Kursi", "arabic": "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ", "translation": "Allah, tidak ada tuhan selain Dia, Yang Maha Hidup"},
        ],
    },
    "sunnah_harian": {
        "category": "sunnah_harian",
        "title": "Sunnah Harian",
        "items": [
            {"title": "Sholat Sunnah Fajar", "description": "2 rakaat sebelum sholat Subuh"},
            {"title": "Sholat Dhuha", "description": "Minimal 2 rakaat setelah matahari terbit"},
        ],
    },
}


@router.get("")
async def list_recommendations(current_user: dict = Depends(get_current_user)):
    categories = [
        {"category": v["category"], "title": v["title"]}
        for v in RECOMMENDATIONS.values()
    ]
    return ok(data=categories)


@router.get("/smart")
async def get_smart_recommendation(current_user: dict = Depends(get_current_user)):
    """
    Rekomendasi personal berdasarkan riwayat belajar user (AI-powered).

    TODO (saat GEMINI_API_KEY tersedia):
    - Ambil practice_sessions & sunnah_logs user dari MongoDB
    - Kirim ringkasan ke Gemini untuk generate rekomendasi personal
    - Cache hasil di MongoDB (TTL 24 jam)
    """
    if not settings.gemini_api_key:
        raise HTTPException(
            status_code=503,
            detail="Fitur Smart Recommendation belum tersedia. Set GEMINI_API_KEY di environment.",
        )
    raise HTTPException(status_code=503, detail="Fitur Smart Recommendation belum tersedia.")


@router.get("/{category}")
async def get_recommendation(category: str, current_user: dict = Depends(get_current_user)):
    data = RECOMMENDATIONS.get(category)
    if not data:
        raise HTTPException(status_code=404, detail="Kategori tidak ditemukan")
    return ok(data=data)
