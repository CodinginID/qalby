from fastapi import APIRouter, Depends, HTTPException, Query
from typing import Optional

from app.core.dependencies import get_current_user
from app.core.database import get_db
from app.features.quran import service
from app.shared.models import ok

router = APIRouter(prefix="/quran", tags=["quran"])


@router.get("/surahs")
async def list_surahs(current_user: dict = Depends(get_current_user)):
    db = get_db()
    data = await service.get_surahs(db)
    return ok(data=data)


@router.get("/surahs/{surah_id}")
async def get_surah(surah_id: int, current_user: dict = Depends(get_current_user)):
    if not 1 <= surah_id <= 114:
        raise HTTPException(status_code=400, detail="Surah ID harus antara 1-114")
    db = get_db()
    data = await service.get_surah_detail(surah_id, db)
    return ok(data=data)


@router.get("/surahs/{surah_id}/ayat")
async def get_ayat(
    surah_id: int,
    start: Optional[int] = Query(default=1, ge=1),
    end: Optional[int] = Query(default=None),
    current_user: dict = Depends(get_current_user),
):
    if not 1 <= surah_id <= 114:
        raise HTTPException(status_code=400, detail="Surah ID harus antara 1-114")
    db = get_db()
    surah = await service.get_surah_detail(surah_id, db)
    total_ayat = surah.get("numberOfAyahs", 1)
    end = end or total_ayat
    data = await service.get_ayat_range(surah_id, start, end, db)
    return ok(data=data)


@router.get("/surahs/{surah_id}/editions/{editions}")
async def get_surah_editions(
    surah_id: int,
    editions: str,
    current_user: dict = Depends(get_current_user),
):
    """Proxy multi-edition fetch (e.g. quran-uthmani,id.indonesian,ar.alafasy)."""
    if not 1 <= surah_id <= 114:
        raise HTTPException(status_code=400, detail="Surah ID harus antara 1-114")
    db = get_db()
    try:
        data = await service.get_surah_editions(surah_id, editions, db)
        return ok(data=data)
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"Gagal ambil data edisi: {str(e)}")


@router.get("/surahs/{surah_id}/edition/{edition}")
async def get_surah_edition(
    surah_id: int,
    edition: str,
    current_user: dict = Depends(get_current_user),
):
    """Proxy single edition fetch (e.g. quran-tajweed, id.muntakhab)."""
    if not 1 <= surah_id <= 114:
        raise HTTPException(status_code=400, detail="Surah ID harus antara 1-114")
    db = get_db()
    try:
        data = await service.get_surah_edition(surah_id, edition, db)
        return ok(data=data)
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"Gagal ambil data edisi: {str(e)}")


# ─── QuranAPI.dev endpoints (secondary source) ──────────────────────────────


def _validate_surah(surah_id: int):
    if not 1 <= surah_id <= 114:
        raise HTTPException(status_code=400, detail="Surah ID harus antara 1-114")


@router.get("/reciters")
async def list_reciters(current_user: dict = Depends(get_current_user)):
    """Daftar qari yang tersedia (5 qari dari QuranAPI.dev)."""
    db = get_db()
    try:
        data = await service.get_reciters(db)
        return ok(data=data)
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"Gagal ambil data qari: {str(e)}")


@router.get("/surahs/{surah_id}/audio")
async def get_surah_audio(
    surah_id: int,
    current_user: dict = Depends(get_current_user),
):
    """Audio full-surah dari 5 qari."""
    _validate_surah(surah_id)
    db = get_db()
    try:
        data = await service.get_surah_audio(surah_id, db)
        return ok(data=data)
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"Gagal ambil audio surah: {str(e)}")


@router.get("/surahs/{surah_id}/ayat/{ayah}/audio")
async def get_verse_audio(
    surah_id: int,
    ayah: int,
    current_user: dict = Depends(get_current_user),
):
    """Audio per-ayat dari 5 qari."""
    _validate_surah(surah_id)
    db = get_db()
    try:
        data = await service.get_verse_audio(surah_id, ayah, db)
        return ok(data=data)
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"Gagal ambil audio ayat: {str(e)}")


@router.get("/surahs/{surah_id}/tafsir")
async def get_surah_tafsir(
    surah_id: int,
    current_user: dict = Depends(get_current_user),
):
    """Tafsir seluruh surah (Ibn Kathir, Maarif Ul Quran, Tazkirul Quran)."""
    _validate_surah(surah_id)
    db = get_db()
    try:
        data = await service.get_surah_tafsir(surah_id, db)
        return ok(data=data)
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"Gagal ambil tafsir surah: {str(e)}")


@router.get("/surahs/{surah_id}/ayat/{ayah}/tafsir")
async def get_verse_tafsir(
    surah_id: int,
    ayah: int,
    current_user: dict = Depends(get_current_user),
):
    """Tafsir per-ayat (Ibn Kathir, Maarif Ul Quran, Tazkirul Quran)."""
    _validate_surah(surah_id)
    db = get_db()
    try:
        data = await service.get_verse_tafsir(surah_id, ayah, db)
        return ok(data=data)
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"Gagal ambil tafsir ayat: {str(e)}")


@router.get("/surahs/{surah_id}/full")
async def get_surah_full(
    surah_id: int,
    current_user: dict = Depends(get_current_user),
):
    """Data lengkap surah dari QuranAPI.dev (arabic1, arabic2, english, audio 5 qari)."""
    _validate_surah(surah_id)
    db = get_db()
    try:
        data = await service.get_surah_full(surah_id, db)
        return ok(data=data)
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"Gagal ambil data surah: {str(e)}")
