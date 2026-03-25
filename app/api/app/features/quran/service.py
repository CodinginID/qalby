import httpx
from motor.motor_asyncio import AsyncIOMotorDatabase

from app.core.database import strip_id

ALQURAN_API = "https://api.alquran.cloud/v1"
QURANAPI_DEV = "https://quranapi.pages.dev/api"


async def get_surahs(db: AsyncIOMotorDatabase) -> list:
    cache = await db["quran_cache"].find_one({"_key": "surahs"})
    if cache:
        return cache["data"]

    async with httpx.AsyncClient() as client:
        resp = await client.get(f"{ALQURAN_API}/surah", timeout=10)
    resp.raise_for_status()
    data = resp.json()["data"]

    await db["quran_cache"].replace_one(
        {"_key": "surahs"},
        {"_key": "surahs", "data": data},
        upsert=True,
    )
    return data


async def get_surah_detail(surah_id: int, db: AsyncIOMotorDatabase) -> dict:
    cache_key = f"surah_{surah_id}"
    cache = await db["quran_cache"].find_one({"_key": cache_key})
    if cache:
        return cache["data"]

    async with httpx.AsyncClient() as client:
        resp = await client.get(f"{ALQURAN_API}/surah/{surah_id}", timeout=10)
    resp.raise_for_status()
    data = resp.json()["data"]

    await db["quran_cache"].replace_one(
        {"_key": cache_key},
        {"_key": cache_key, "data": data},
        upsert=True,
    )
    return data


async def get_ayat_range(surah_id: int, start: int, end: int, db: AsyncIOMotorDatabase) -> list:
    surah = await get_surah_detail(surah_id, db)
    ayahs = surah.get("ayahs", [])
    return [a for a in ayahs if start <= a["numberInSurah"] <= end]


async def get_surah_editions(surah_id: int, editions: str, db: AsyncIOMotorDatabase) -> list:
    """Fetch multiple editions of a surah (e.g. quran-uthmani,id.indonesian,ar.alafasy)."""
    cache_key = f"surah_{surah_id}_editions_{editions}"
    cache = await db["quran_cache"].find_one({"_key": cache_key})
    if cache:
        return cache["data"]

    async with httpx.AsyncClient() as client:
        resp = await client.get(f"{ALQURAN_API}/surah/{surah_id}/editions/{editions}", timeout=30)
    resp.raise_for_status()
    data = resp.json()["data"]

    await db["quran_cache"].replace_one(
        {"_key": cache_key},
        {"_key": cache_key, "data": data},
        upsert=True,
    )
    return data


async def get_surah_edition(surah_id: int, edition: str, db: AsyncIOMotorDatabase) -> dict:
    """Fetch a single edition of a surah (e.g. quran-tajweed, id.muntakhab)."""
    cache_key = f"surah_{surah_id}_edition_{edition}"
    cache = await db["quran_cache"].find_one({"_key": cache_key})
    if cache:
        return cache["data"]

    async with httpx.AsyncClient() as client:
        resp = await client.get(f"{ALQURAN_API}/surah/{surah_id}/{edition}", timeout=30)
    resp.raise_for_status()
    data = resp.json()["data"]

    await db["quran_cache"].replace_one(
        {"_key": cache_key},
        {"_key": cache_key, "data": data},
        upsert=True,
    )
    return data


# ─── QuranAPI.dev (secondary source) ────────────────────────────────────────


async def _cache_get_or_fetch(cache_key: str, url: str, db: AsyncIOMotorDatabase, timeout: int = 30):
    """Helper: check MongoDB cache first, else fetch from URL and cache."""
    cache = await db["quran_cache"].find_one({"_key": cache_key})
    if cache:
        return cache["data"]

    async with httpx.AsyncClient() as client:
        resp = await client.get(url, timeout=timeout)
    resp.raise_for_status()
    data = resp.json()

    await db["quran_cache"].replace_one(
        {"_key": cache_key},
        {"_key": cache_key, "data": data},
        upsert=True,
    )
    return data


async def get_reciters(db: AsyncIOMotorDatabase) -> dict:
    """Daftar 5 qari yang tersedia dari QuranAPI.dev."""
    return await _cache_get_or_fetch("qdev_reciters", f"{QURANAPI_DEV}/reciters.json", db)


async def get_surah_audio(surah_id: int, db: AsyncIOMotorDatabase) -> dict:
    """Audio full-surah dari 5 qari."""
    return await _cache_get_or_fetch(
        f"qdev_audio_surah_{surah_id}",
        f"{QURANAPI_DEV}/audio/{surah_id}.json",
        db,
    )


async def get_verse_audio(surah_id: int, ayah: int, db: AsyncIOMotorDatabase) -> dict:
    """Audio per-ayat dari 5 qari."""
    return await _cache_get_or_fetch(
        f"qdev_audio_{surah_id}_{ayah}",
        f"{QURANAPI_DEV}/audio/{surah_id}/{ayah}.json",
        db,
    )


async def get_surah_tafsir(surah_id: int, db: AsyncIOMotorDatabase) -> dict:
    """Tafsir seluruh surah (Ibn Kathir, Maarif Ul Quran, Tazkirul Quran)."""
    return await _cache_get_or_fetch(
        f"qdev_tafsir_surah_{surah_id}",
        f"{QURANAPI_DEV}/tafsir/{surah_id}.json",
        db,
        timeout=60,
    )


async def get_verse_tafsir(surah_id: int, ayah: int, db: AsyncIOMotorDatabase) -> dict:
    """Tafsir per-ayat (Ibn Kathir, Maarif Ul Quran, Tazkirul Quran)."""
    return await _cache_get_or_fetch(
        f"qdev_tafsir_{surah_id}_{ayah}",
        f"{QURANAPI_DEV}/tafsir/{surah_id}_{ayah}.json",
        db,
    )


async def get_surah_full(surah_id: int, db: AsyncIOMotorDatabase) -> dict:
    """Data lengkap surah dari QuranAPI.dev (arabic1, arabic2, english, audio 5 qari)."""
    return await _cache_get_or_fetch(
        f"qdev_surah_{surah_id}",
        f"{QURANAPI_DEV}/{surah_id}.json",
        db,
        timeout=30,
    )
