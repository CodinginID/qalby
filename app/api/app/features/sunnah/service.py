import uuid
from datetime import datetime, timezone, date as date_type
from motor.motor_asyncio import AsyncIOMotorDatabase

from app.core.database import strip_id

SUNNAH_LIST = [
    {"id": "sholat_fajar", "name": "Sholat Sunnah Fajar", "description": "2 rakaat sebelum Subuh", "category": "sholat"},
    {"id": "sholat_dhuha", "name": "Sholat Dhuha", "description": "Minimal 2 rakaat setelah matahari terbit", "category": "sholat"},
    {"id": "sholat_tahajud", "name": "Sholat Tahajud", "description": "Sholat malam setelah bangun tidur", "category": "sholat"},
    {"id": "sholat_rawatib", "name": "Sholat Rawatib", "description": "Sholat sunnah qabliyah dan ba'diyah", "category": "sholat"},
    {"id": "puasa_senin", "name": "Puasa Senin", "description": "Puasa sunnah setiap hari Senin", "category": "puasa"},
    {"id": "puasa_kamis", "name": "Puasa Kamis", "description": "Puasa sunnah setiap hari Kamis", "category": "puasa"},
    {"id": "baca_quran", "name": "Baca Al-Quran", "description": "Membaca Al-Quran minimal 1 halaman", "category": "quran"},
    {"id": "dzikir_pagi", "name": "Dzikir Pagi", "description": "Dzikir setelah Subuh", "category": "dzikir"},
    {"id": "dzikir_petang", "name": "Dzikir Petang", "description": "Dzikir setelah Ashar", "category": "dzikir"},
    {"id": "sedekah", "name": "Sedekah", "description": "Bersedekah setiap hari", "category": "amal"},
]

SUNNAH_MAP = {s["id"]: s for s in SUNNAH_LIST}


def get_sunnah_list() -> list:
    return SUNNAH_LIST


async def log_sunnah(uid: str, sunnah_id: str, log_date: str, notes: str, db: AsyncIOMotorDatabase) -> dict | None:
    if sunnah_id not in SUNNAH_MAP:
        return None

    if not log_date:
        log_date = date_type.today().isoformat()

    log_id = str(uuid.uuid4())
    now = datetime.now(timezone.utc)
    data = {
        "id": log_id,
        "user_id": uid,
        "sunnah_id": sunnah_id,
        "sunnah_name": SUNNAH_MAP[sunnah_id]["name"],
        "date": log_date,
        "notes": notes or "",
        "created_at": now,
    }
    await db["sunnah_logs"].insert_one(data)
    return strip_id(data)


async def get_logs(uid: str, log_date: str, db: AsyncIOMotorDatabase) -> list:
    if not log_date:
        log_date = date_type.today().isoformat()

    docs = await db["sunnah_logs"].find({"user_id": uid, "date": log_date}).to_list(length=None)
    return [strip_id(d) for d in docs]


async def delete_log(log_id: str, uid: str, db: AsyncIOMotorDatabase) -> bool:
    result = await db["sunnah_logs"].delete_one({"id": log_id, "user_id": uid})
    return result.deleted_count > 0


async def get_stats(uid: str, db: AsyncIOMotorDatabase) -> dict:
    docs = await db["sunnah_logs"].find({"user_id": uid}).to_list(length=None)
    logs = [strip_id(d) for d in docs]

    total_logs = len(logs)
    per_sunnah: dict[str, int] = {}
    for log in logs:
        sid = log["sunnah_id"]
        per_sunnah[sid] = per_sunnah.get(sid, 0) + 1

    most_frequent = sorted(per_sunnah.items(), key=lambda x: x[1], reverse=True)
    most_frequent_list = [
        {"sunnah_id": k, "sunnah_name": SUNNAH_MAP.get(k, {}).get("name", k), "count": v}
        for k, v in most_frequent
    ]

    return {
        "total_logs": total_logs,
        "unique_sunnah_done": len(per_sunnah),
        "per_sunnah": most_frequent_list,
    }
