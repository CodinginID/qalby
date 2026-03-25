from fastapi import APIRouter, Depends, HTTPException, Query
from datetime import datetime

from app.core.config import settings
from app.core.dependencies import get_current_user
from app.core.database import get_db
from app.features.prayer.models import CreateReminderRequest, AdaptiveReminderSettingsRequest
from app.features.prayer import service
from app.shared.models import ok

router = APIRouter(prefix="/prayer", tags=["prayer"])


@router.get("/qibla")
async def get_qibla(
    lat: float = Query(...),
    lng: float = Query(...),
    current_user: dict = Depends(get_current_user),
):
    data = service.get_qibla_direction(lat, lng)
    return ok(data=data)


@router.get("/times")
async def get_prayer_times(
    lat: float = Query(...),
    lng: float = Query(...),
    date: str = Query(default=None),
    current_user: dict = Depends(get_current_user),
):
    if not date:
        date = datetime.now().strftime("%d-%m-%Y")
    try:
        data = await service.get_prayer_times(lat, lng, date)
        return ok(data=data)
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"Gagal ambil jadwal sholat: {str(e)}")


@router.post("/reminders")
async def create_reminder(
    body: CreateReminderRequest,
    current_user: dict = Depends(get_current_user),
):
    valid_prayers = {"fajr", "dhuhr", "asr", "maghrib", "isha"}
    if body.prayer_name.lower() not in valid_prayers:
        raise HTTPException(status_code=400, detail="Nama sholat tidak valid")
    db = get_db()
    data = await service.create_reminder(current_user["uid"], body.model_dump(), db)
    return ok(data=data)


@router.get("/reminders")
async def get_reminders(current_user: dict = Depends(get_current_user)):
    db = get_db()
    data = await service.get_reminders(current_user["uid"], db)
    return ok(data=data)


@router.delete("/reminders/{reminder_id}")
async def delete_reminder(
    reminder_id: str,
    current_user: dict = Depends(get_current_user),
):
    db = get_db()
    success = await service.delete_reminder(reminder_id, current_user["uid"], db)
    if not success:
        raise HTTPException(status_code=404, detail="Reminder tidak ditemukan")
    return ok(message="Reminder dihapus")


_ADAPTIVE_UNAVAILABLE = "Fitur Adaptive Reminder belum tersedia. Set GEMINI_API_KEY di environment."


@router.get("/reminders/adaptive")
async def get_adaptive_reminders(current_user: dict = Depends(get_current_user)):
    if not settings.gemini_api_key:
        raise HTTPException(status_code=503, detail=_ADAPTIVE_UNAVAILABLE)
    raise HTTPException(status_code=503, detail=_ADAPTIVE_UNAVAILABLE)


@router.put("/reminders/adaptive/settings")
async def update_adaptive_settings(
    body: AdaptiveReminderSettingsRequest,
    current_user: dict = Depends(get_current_user),
):
    if not settings.gemini_api_key:
        raise HTTPException(status_code=503, detail=_ADAPTIVE_UNAVAILABLE)

    db = get_db()
    data = await service.save_adaptive_settings(current_user["uid"], body.model_dump(), db)
    return ok(data=data)
