from pydantic import BaseModel
from typing import Optional, List


class PlaylistItem(BaseModel):
    surah_id: int
    surah_name: str
    ayat_start: int
    ayat_end: int
    order: int


class CreatePlaylistRequest(BaseModel):
    name: str
    description: Optional[str] = ""


class UpdatePlaylistRequest(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None


class AddItemRequest(BaseModel):
    surah_id: int
    surah_name: str
    surah_name_arabic: Optional[str] = ""
    ayat_start: int
    ayat_end: int


class ReorderItemsRequest(BaseModel):
    item_ids: List[str]  # urutan baru item_id
