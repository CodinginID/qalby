from motor.motor_asyncio import AsyncIOMotorClient, AsyncIOMotorDatabase

from app.core.config import settings

_client: AsyncIOMotorClient | None = None
_db: AsyncIOMotorDatabase | None = None


async def init_db() -> None:
    global _client, _db
    _client = AsyncIOMotorClient(settings.mongodb_uri)
    _db = _client[settings.mongodb_db_name]


async def close_db() -> None:
    global _client, _db
    if _client:
        _client.close()
    _client = None
    _db = None


def get_db() -> AsyncIOMotorDatabase:
    if _db is None:
        raise RuntimeError("Database not initialized. Call init_db() first.")
    return _db


def strip_id(doc: dict | None) -> dict:
    """Hapus field _id bawaan MongoDB sebelum dikembalikan ke client."""
    if doc:
        doc.pop("_id", None)
    return doc
