import httpx
import uuid
import math
from datetime import datetime, timezone
from motor.motor_asyncio import AsyncIOMotorDatabase

from app.core.database import strip_id

ALADHAN_API = "https://api.aladhan.com/v1"
PRAYER_METHOD = 11  # Kemenag Indonesia

MECCA_LAT = 21.4225
MECCA_LNG = 39.8262


def get_qibla_direction(lat: float, lng: float) -> dict:
    lat_r = math.radians(lat)
    lng_r = math.radians(lng)
    mecca_lat_r = math.radians(MECCA_LAT)
    delta_lng = math.radians(MECCA_LNG) - lng_r

    x = math.sin(delta_lng)
    y = math.cos(lat_r) * math.tan(mecca_lat_r) - math.sin(lat_r) * math.cos(delta_lng)

    bearing = math.degrees(math.atan2(x, y))
    bearing = (bearing + 360) % 360

    return {
        "qibla_direction": round(bearing, 4),
        "latitude": lat,
        "longitude": lng,
    }


async def get_prayer_times(lat: float, lng: float, date: str) -> dict:
    async with httpx.AsyncClient() as client:
        resp = await client.get(
            f"{ALADHAN_API}/timings/{date}",
            params={"latitude": lat, "longitude": lng, "method": PRAYER_METHOD},
            timeout=10,
        )
    resp.raise_for_status()
    return resp.json()["data"]


async def create_reminder(uid: str, payload: dict, db: AsyncIOMotorDatabase) -> dict:
    reminder_id = str(uuid.uuid4())
    now = datetime.now(timezone.utc)
    data = {
        "id": reminder_id,
        "user_id": uid,
        "prayer_name": payload["prayer_name"],
        "offset_minutes": payload.get("offset_minutes", 0),
        "is_active": True,
        "created_at": now,
        "updated_at": now,
    }
    await db["prayer_reminders"].insert_one(data)
    return strip_id(data)


async def get_reminders(uid: str, db: AsyncIOMotorDatabase) -> list:
    docs = await db["prayer_reminders"].find({"user_id": uid, "is_active": True}).to_list(length=None)
    return [strip_id(d) for d in docs]


async def delete_reminder(reminder_id: str, uid: str, db: AsyncIOMotorDatabase) -> bool:
    result = await db["prayer_reminders"].delete_one({"id": reminder_id, "user_id": uid})
    return result.deleted_count > 0


async def save_adaptive_settings(uid: str, payload: dict, db: AsyncIOMotorDatabase) -> dict:
    payload["user_id"] = uid
    payload["updated_at"] = datetime.now(timezone.utc)
    await db["adaptive_reminder_settings"].replace_one({"user_id": uid}, payload, upsert=True)
    doc = await db["adaptive_reminder_settings"].find_one({"user_id": uid})
    return strip_id(doc)
