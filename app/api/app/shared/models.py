from typing import Any, Optional
from pydantic import BaseModel


class SuccessResponse(BaseModel):
    success: bool = True
    data: Any = None
    message: Optional[str] = None


class ErrorDetail(BaseModel):
    code: str
    message: str


class ErrorResponse(BaseModel):
    success: bool = False
    error: ErrorDetail


def ok(data: Any = None, message: str = None) -> dict:
    return {"success": True, "data": data, "message": message}


def err(code: str, message: str) -> dict:
    return {"success": False, "error": {"code": code, "message": message}}
