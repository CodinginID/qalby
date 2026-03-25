from fastapi import APIRouter, Depends, HTTPException, status

from app.core.dependencies import get_current_user
from app.core.database import get_db
from app.features.auth.models import VerifyTokenRequest, UpdateProfileRequest
from app.features.auth import service
from app.shared.models import ok

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/verify-token")
async def verify_token(body: VerifyTokenRequest):
    try:
        db = get_db()
        result = await service.verify_and_upsert_user(body.id_token, db)
        return ok(data=result)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))


@router.get("/profile")
async def get_profile(current_user: dict = Depends(get_current_user)):
    db = get_db()
    user = await service.get_profile(current_user["uid"], db)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return ok(data=user)


@router.put("/profile")
async def update_profile(
    body: UpdateProfileRequest,
    current_user: dict = Depends(get_current_user),
):
    db = get_db()
    payload = body.model_dump(exclude_none=True)
    updated = await service.update_profile(current_user["uid"], payload, db)
    if not updated:
        raise HTTPException(status_code=404, detail="User not found")
    return ok(data=updated)
