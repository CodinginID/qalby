import uuid
from datetime import datetime, timezone
from motor.motor_asyncio import AsyncIOMotorDatabase
from pymongo import DESCENDING  # re-exported by motor

from app.core.database import strip_id


async def start_session(uid: str, playlist_id: str, db: AsyncIOMotorDatabase) -> dict | None:
    playlist = await db["playlists"].find_one({"id": playlist_id})
    if not playlist:
        return None

    items_progress = [
        {
            "item_id": item["item_id"],
            "surah_id": item["surah_id"],
            "ayat_start": item["ayat_start"],
            "ayat_end": item["ayat_end"],
            "repetitions": 0,
            "status": "not_started",
        }
        for item in playlist.get("items", [])
    ]

    session_id = str(uuid.uuid4())
    now = datetime.now(timezone.utc)
    data = {
        "id": session_id,
        "user_id": uid,
        "playlist_id": playlist_id,
        "started_at": now,
        "ended_at": None,
        "items_progress": items_progress,
        "notes": "",
    }
    await db["practice_sessions"].insert_one(data)
    return strip_id(data)


async def update_session(session_id: str, uid: str, payload: dict, db: AsyncIOMotorDatabase) -> dict | None:
    doc = await db["practice_sessions"].find_one({"id": session_id, "user_id": uid})
    if not doc:
        return None

    update_data = {
        "items_progress": payload["items_progress"],
        "notes": payload.get("notes", ""),
    }
    if payload.get("ended"):
        update_data["ended_at"] = datetime.now(timezone.utc)

    await db["practice_sessions"].update_one({"id": session_id}, {"$set": update_data})
    doc = await db["practice_sessions"].find_one({"id": session_id})
    return strip_id(doc)


async def get_sessions(uid: str, db: AsyncIOMotorDatabase) -> list:
    cursor = (
        db["practice_sessions"]
        .find({"user_id": uid})
        .sort("started_at", DESCENDING)
        .limit(20)
    )
    docs = await cursor.to_list(length=20)
    return [strip_id(d) for d in docs]


async def get_stats(uid: str, db: AsyncIOMotorDatabase) -> dict:
    docs = await db["practice_sessions"].find({"user_id": uid}).to_list(length=None)
    sessions = [strip_id(d) for d in docs]

    total_sessions = len(sessions)
    total_repetitions = sum(
        item["repetitions"]
        for s in sessions
        for item in s.get("items_progress", [])
    )
    completed_items = sum(
        1
        for s in sessions
        for item in s.get("items_progress", [])
        if item["status"] == "done"
    )

    return {
        "total_sessions": total_sessions,
        "total_repetitions": total_repetitions,
        "completed_items": completed_items,
    }
