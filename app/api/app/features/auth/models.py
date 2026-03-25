from pydantic import BaseModel
from typing import Optional


class VerifyTokenRequest(BaseModel):
    id_token: str


class UpdateProfileRequest(BaseModel):
    display_name: Optional[str] = None
    photo_url: Optional[str] = None
    fcm_token: Optional[str] = None


class UserProfile(BaseModel):
    uid: str
    email: str
    display_name: Optional[str] = None
    photo_url: Optional[str] = None
