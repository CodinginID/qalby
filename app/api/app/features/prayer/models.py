from pydantic import BaseModel
from typing import Optional


class CreateReminderRequest(BaseModel):
    prayer_name: str  # "fajr" | "dhuhr" | "asr" | "maghrib" | "isha"
    offset_minutes: Optional[int] = 0


class AdaptiveReminderSettingsRequest(BaseModel):
    enabled: bool = True
    preferred_prayers: Optional[list[str]] = None  # subset dari 5 waktu sholat
    learning_window_days: Optional[int] = 7  # berapa hari histori yang dianalisis
