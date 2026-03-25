from fastapi import APIRouter, Depends, HTTPException

from app.core.dependencies import get_current_user
from app.core.database import get_db
from app.features.practice.models import StartSessionRequest, UpdateSessionRequest
from app.features.practice import service
from app.shared.models import ok

router = APIRouter(prefix="/practice", tags=["practice"])


@router.post("/sessions")
async def start_session(
    body: StartSessionRequest,
    current_user: dict = Depends(get_current_user),
):
    db = get_db()
    data = await service.start_session(current_user["uid"], body.playlist_id, db)
    if not data:
        raise HTTPException(status_code=404, detail="Playlist tidak ditemukan")
    return ok(data=data)


@router.put("/sessions/{session_id}")
async def update_session(
    session_id: str,
    body: UpdateSessionRequest,
    current_user: dict = Depends(get_current_user),
):
    db = get_db()
    data = await service.update_session(session_id, current_user["uid"], body.model_dump(), db)
    if not data:
        raise HTTPException(status_code=404, detail="Sesi tidak ditemukan")
    return ok(data=data)


@router.get("/sessions")
async def get_sessions(current_user: dict = Depends(get_current_user)):
    db = get_db()
    data = await service.get_sessions(current_user["uid"], db)
    return ok(data=data)


@router.get("/stats")
async def get_stats(current_user: dict = Depends(get_current_user)):
    db = get_db()
    data = await service.get_stats(current_user["uid"], db)
    return ok(data=data)
