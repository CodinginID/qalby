from pydantic import BaseModel
from typing import Optional


class LogSunnahRequest(BaseModel):
    sunnah_id: str
    date: Optional[str] = None  # YYYY-MM-DD, default today
    notes: Optional[str] = ""
