from typing import Optional
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    app_env: str = "development"
    app_port: int = 8000

    # Google OAuth — client ID dari Google Cloud Console (untuk verifikasi ID token)
    google_client_id: str

    # JWT secret — dipakai backend untuk sign/verify token session sendiri
    jwt_secret: str
    jwt_algorithm: str = "HS256"
    jwt_expire_hours: int = 24 * 7  # 7 hari

    # MongoDB
    mongodb_uri: str = "mongodb://localhost:27017"
    mongodb_db_name: str = "qalby"

    # Future features — opsional, fitur terkait return 503 jika belum diset
    gemini_api_key: Optional[str] = None
    openai_api_key: Optional[str] = None

    model_config = {"env_file": ".env"}


settings = Settings()
