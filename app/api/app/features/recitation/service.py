"""
AI Recitation Service

Menggunakan Gemini API untuk menganalisis bacaan Al-Quran dari audio dan
memberikan feedback tajwid, makhraj, serta skor keseluruhan.

TODO (saat GEMINI_API_KEY tersedia):
- Kirim audio ke Gemini multimodal endpoint
- Parse response untuk extract skor tajwid & list kesalahan
- Simpan histori analisis ke MongoDB (collection: recitation_analyses)
"""

from app.core.config import settings


def is_available() -> bool:
    return bool(settings.gemini_api_key)


def analyze_audio(surah_id: int, ayat_start: int, ayat_end: int, audio_bytes: bytes) -> dict:
    """
    Kirim audio ke Gemini API dan dapatkan feedback tajwid.

    Args:
        surah_id: ID surah (1-114)
        ayat_start: ayat mulai
        ayat_end: ayat selesai
        audio_bytes: raw audio file (mp3/wav/m4a)

    Returns:
        dict berisi score, tajwid_errors, makhraj_notes, overall_feedback
    """
    raise NotImplementedError("Gemini API belum dikonfigurasi")
