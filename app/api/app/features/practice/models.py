from pydantic import BaseModel
from typing import Optional, List


class StartSessionRequest(BaseModel):
    playlist_id: str


class ItemProgress(BaseModel):
    item_id: str
    repetitions: int
    status: str  # "not_started" | "in_progress" | "done"


class UpdateSessionRequest(BaseModel):
    items_progress: List[ItemProgress]
    notes: Optional[str] = ""
    ended: Optional[bool] = False
