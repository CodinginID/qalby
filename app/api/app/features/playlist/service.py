import uuid
from datetime import datetime, timezone
from motor.motor_asyncio import AsyncIOMotorDatabase

from app.core.database import strip_id


async def get_playlists(uid: str, db: AsyncIOMotorDatabase) -> list:
    docs = await db["playlists"].find({"user_id": uid}).to_list(length=None)
    return [strip_id(d) for d in docs]


async def create_playlist(uid: str, name: str, description: str, db: AsyncIOMotorDatabase) -> dict:
    playlist_id = str(uuid.uuid4())
    now = datetime.now(timezone.utc)
    data = {
        "id": playlist_id,
        "user_id": uid,
        "name": name,
        "description": description,
        "items": [],
        "created_at": now,
        "updated_at": now,
    }
    await db["playlists"].insert_one(data)
    return strip_id(data)


async def get_playlist(playlist_id: str, uid: str, db: AsyncIOMotorDatabase) -> dict | None:
    doc = await db["playlists"].find_one({"id": playlist_id, "user_id": uid})
    return strip_id(doc) if doc else None


async def update_playlist(playlist_id: str, uid: str, payload: dict, db: AsyncIOMotorDatabase) -> dict | None:
    existing = await get_playlist(playlist_id, uid, db)
    if not existing:
        return None
    payload["updated_at"] = datetime.now(timezone.utc)
    await db["playlists"].update_one({"id": playlist_id}, {"$set": payload})
    doc = await db["playlists"].find_one({"id": playlist_id})
    return strip_id(doc)


async def delete_playlist(playlist_id: str, uid: str, db: AsyncIOMotorDatabase) -> bool:
    result = await db["playlists"].delete_one({"id": playlist_id, "user_id": uid})
    return result.deleted_count > 0


async def add_item(playlist_id: str, uid: str, item_data: dict, db: AsyncIOMotorDatabase) -> dict | None:
    playlist = await get_playlist(playlist_id, uid, db)
    if not playlist:
        return None

    item_id = str(uuid.uuid4())
    items = playlist.get("items", [])
    new_item = {
        "item_id": item_id,
        **item_data,
        "order": len(items),
    }
    items.append(new_item)

    await db["playlists"].update_one(
        {"id": playlist_id},
        {"$set": {"items": items, "updated_at": datetime.now(timezone.utc)}},
    )
    return new_item


async def reorder_items(playlist_id: str, uid: str, item_ids: list, db: AsyncIOMotorDatabase) -> dict | None:
    playlist = await get_playlist(playlist_id, uid, db)
    if not playlist:
        return None

    items_map = {item["item_id"]: item for item in playlist.get("items", [])}
    reordered = []
    for order, item_id in enumerate(item_ids):
        if item_id in items_map:
            items_map[item_id]["order"] = order
            reordered.append(items_map[item_id])

    await db["playlists"].update_one(
        {"id": playlist_id},
        {"$set": {"items": reordered, "updated_at": datetime.now(timezone.utc)}},
    )
    doc = await db["playlists"].find_one({"id": playlist_id})
    return strip_id(doc)


async def delete_item(playlist_id: str, uid: str, item_id: str, db: AsyncIOMotorDatabase) -> bool:
    playlist = await get_playlist(playlist_id, uid, db)
    if not playlist:
        return False

    items = [i for i in playlist.get("items", []) if i["item_id"] != item_id]
    for idx, item in enumerate(items):
        item["order"] = idx

    await db["playlists"].update_one(
        {"id": playlist_id},
        {"$set": {"items": items, "updated_at": datetime.now(timezone.utc)}},
    )
    return True
