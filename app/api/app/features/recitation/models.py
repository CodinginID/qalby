from pydantic import BaseModel
from typing import Optional, List


class RecitationFeedback(BaseModel):
    score: float  # 0.0 - 100.0
    tajwid_errors: List[str]
    makhraj_notes: Optional[str] = None
    overall_feedback: str


class AnalyzeRecitationResponse(BaseModel):
    surah_id: int
    ayat_start: int
    ayat_end: int
    feedback: RecitationFeedback
