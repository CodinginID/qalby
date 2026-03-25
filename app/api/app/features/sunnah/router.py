from fastapi import APIRouter, Depends, HTTPException, Query
from typing import Optional

from app.core.dependencies import get_current_user
from app.core.database import get_db
from app.features.sunnah.models import LogSunnahRequest
from app.features.sunnah import service
from app.shared.models import ok

router = APIRouter(prefix="/sunnah", tags=["sunnah"])


@router.get("")
async def list_sunnah(current_user: dict = Depends(get_current_user)):
    data = service.get_sunnah_list()
    return ok(data=data)


@router.post("/logs")
async def log_sunnah(
    body: LogSunnahRequest,
    current_user: dict = Depends(get_current_user),
):
    db = get_db()
    data = await service.log_sunnah(current_user["uid"], body.sunnah_id, body.date, body.notes, db)
    if not data:
        raise HTTPException(status_code=400, detail="Sunnah ID tidak valid")
    return ok(data=data)


@router.get("/logs")
async def get_logs(
    date: Optional[str] = Query(default=None, description="Format YYYY-MM-DD, default hari ini"),
    current_user: dict = Depends(get_current_user),
):
    db = get_db()
    data = await service.get_logs(current_user["uid"], date, db)
    return ok(data=data)


@router.delete("/logs/{log_id}")
async def delete_log(
    log_id: str,
    current_user: dict = Depends(get_current_user),
):
    db = get_db()
    success = await service.delete_log(log_id, current_user["uid"], db)
    if not success:
        raise HTTPException(status_code=404, detail="Log tidak ditemukan")
    return ok(message="Log dihapus")


@router.get("/stats")
async def get_stats(current_user: dict = Depends(get_current_user)):
    db = get_db()
    data = await service.get_stats(current_user["uid"], db)
    return ok(data=data)
