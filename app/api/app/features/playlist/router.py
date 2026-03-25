from fastapi import APIRouter, Depends, HTTPException

from app.core.dependencies import get_current_user
from app.core.database import get_db
from app.features.playlist.models import (
    CreatePlaylistRequest,
    UpdatePlaylistRequest,
    AddItemRequest,
    ReorderItemsRequest,
)
from app.features.playlist import service
from app.shared.models import ok

router = APIRouter(prefix="/playlists", tags=["playlist"])


@router.get("")
async def list_playlists(current_user: dict = Depends(get_current_user)):
    db = get_db()
    data = await service.get_playlists(current_user["uid"], db)
    return ok(data=data)


@router.post("")
async def create_playlist(
    body: CreatePlaylistRequest,
    current_user: dict = Depends(get_current_user),
):
    db = get_db()
    data = await service.create_playlist(current_user["uid"], body.name, body.description, db)
    return ok(data=data)


@router.get("/{playlist_id}")
async def get_playlist(playlist_id: str, current_user: dict = Depends(get_current_user)):
    db = get_db()
    data = await service.get_playlist(playlist_id, current_user["uid"], db)
    if not data:
        raise HTTPException(status_code=404, detail="Playlist tidak ditemukan")
    return ok(data=data)


@router.put("/{playlist_id}")
async def update_playlist(
    playlist_id: str,
    body: UpdatePlaylistRequest,
    current_user: dict = Depends(get_current_user),
):
    db = get_db()
    payload = body.model_dump(exclude_none=True)
    data = await service.update_playlist(playlist_id, current_user["uid"], payload, db)
    if not data:
        raise HTTPException(status_code=404, detail="Playlist tidak ditemukan")
    return ok(data=data)


@router.delete("/{playlist_id}")
async def delete_playlist(playlist_id: str, current_user: dict = Depends(get_current_user)):
    db = get_db()
    success = await service.delete_playlist(playlist_id, current_user["uid"], db)
    if not success:
        raise HTTPException(status_code=404, detail="Playlist tidak ditemukan")
    return ok(message="Playlist dihapus")


@router.post("/{playlist_id}/items")
async def add_item(
    playlist_id: str,
    body: AddItemRequest,
    current_user: dict = Depends(get_current_user),
):
    db = get_db()
    item = await service.add_item(playlist_id, current_user["uid"], body.model_dump(), db)
    if not item:
        raise HTTPException(status_code=404, detail="Playlist tidak ditemukan")
    return ok(data=item)


@router.put("/{playlist_id}/items/reorder")
async def reorder_items(
    playlist_id: str,
    body: ReorderItemsRequest,
    current_user: dict = Depends(get_current_user),
):
    db = get_db()
    data = await service.reorder_items(playlist_id, current_user["uid"], body.item_ids, db)
    if not data:
        raise HTTPException(status_code=404, detail="Playlist tidak ditemukan")
    return ok(data=data)


@router.delete("/{playlist_id}/items/{item_id}")
async def delete_item(
    playlist_id: str,
    item_id: str,
    current_user: dict = Depends(get_current_user),
):
    db = get_db()
    success = await service.delete_item(playlist_id, current_user["uid"], item_id, db)
    if not success:
        raise HTTPException(status_code=404, detail="Playlist tidak ditemukan")
    return ok(message="Item dihapus")
