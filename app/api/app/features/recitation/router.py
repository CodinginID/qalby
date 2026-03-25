from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Query

from app.core.dependencies import get_current_user
from app.features.recitation import service
from app.shared.models import ok

router = APIRouter(prefix="/recitation", tags=["recitation"])

_FEATURE_UNAVAILABLE = "Fitur AI Recitation belum tersedia. Set GEMINI_API_KEY di environment."


@router.post("/analyze")
async def analyze_recitation(
    surah_id: int = Query(..., ge=1, le=114),
    ayat_start: int = Query(..., ge=1),
    ayat_end: int = Query(..., ge=1),
    audio: UploadFile = File(..., description="File audio rekaman bacaan (mp3/wav/m4a)"),
    current_user: dict = Depends(get_current_user),
):
    """
    Analisis bacaan Al-Quran menggunakan AI.

    Upload file audio rekaman bacaan, sistem akan memberikan:
    - Skor keseluruhan (0-100)
    - Daftar kesalahan tajwid
    - Catatan makhraj huruf
    - Feedback keseluruhan
    """
    if not service.is_available():
        raise HTTPException(status_code=503, detail=_FEATURE_UNAVAILABLE)

    if ayat_end < ayat_start:
        raise HTTPException(status_code=400, detail="ayat_end harus >= ayat_start")

    audio_bytes = await audio.read()
    try:
        result = service.analyze_audio(surah_id, ayat_start, ayat_end, audio_bytes)
        return ok(data=result)
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"Gagal menganalisis audio: {str(e)}")
