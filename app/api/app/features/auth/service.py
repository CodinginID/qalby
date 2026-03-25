from datetime import datetime, timezone, timedelta
from jose import jwt
from motor.motor_asyncio import AsyncIOMotorDatabase

from app.core.config import settings
from app.core.database import strip_id
from app.core.google_auth import verify_google_id_token


def _create_jwt(uid: str, email: str) -> str:
    """Buat JWT session token untuk user."""
    payload = {
        "uid": uid,
        "email": email,
        "exp": datetime.now(timezone.utc) + timedelta(hours=settings.jwt_expire_hours),
        "iat": datetime.now(timezone.utc),
    }
    return jwt.encode(payload, settings.jwt_secret, algorithm=settings.jwt_algorithm)


async def verify_and_upsert_user(id_token: str, db: AsyncIOMotorDatabase) -> dict:
    """
    Verifikasi Google ID token, upsert user ke MongoDB, return JWT + user data.
    """
    google_payload = await verify_google_id_token(id_token)

    uid = google_payload["sub"]  # Google unique user ID
    email = google_payload.get("email", "")
    display_name = google_payload.get("name", "")
    photo_url = google_payload.get("picture", "")

    now = datetime.now(timezone.utc)

    user = await db["users"].find_one({"uid": uid})

    if not user:
        user = {
            "uid": uid,
            "email": email,
            "display_name": display_name,
            "photo_url": photo_url,
            "fcm_token": "",
            "created_at": now,
            "updated_at": now,
        }
        await db["users"].insert_one(user)
    else:
        # Update info dari Google (bisa berubah)
        await db["users"].update_one(
            {"uid": uid},
            {"$set": {
                "email": email,
                "display_name": display_name,
                "photo_url": photo_url,
                "updated_at": now,
            }},
        )
        user = await db["users"].find_one({"uid": uid})

    token = _create_jwt(uid, email)

    return {
        "token": token,
        "user": _format_user(strip_id(user)),
    }


async def get_profile(uid: str, db: AsyncIOMotorDatabase) -> dict | None:
    user = await db["users"].find_one({"uid": uid})
    if not user:
        return None
    return _format_user(strip_id(user))


async def update_profile(uid: str, payload: dict, db: AsyncIOMotorDatabase) -> dict | None:
    payload["updated_at"] = datetime.now(timezone.utc)
    await db["users"].update_one({"uid": uid}, {"$set": payload})
    user = await db["users"].find_one({"uid": uid})
    if not user:
        return None
    return _format_user(strip_id(user))


def _format_user(user: dict) -> dict:
    """Format user doc agar field names konsisten dengan mobile AppUser.fromJson."""
    return {
        "id": user.get("uid", ""),
        "email": user.get("email", ""),
        "name": user.get("display_name", ""),
        "photo_url": user.get("photo_url", ""),
    }
