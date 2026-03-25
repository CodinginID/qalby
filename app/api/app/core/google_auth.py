"""
Verifikasi Google ID Token tanpa Firebase.

Menggunakan google-auth library untuk memvalidasi token yang dikirim
oleh Google Sign-In di mobile client.
"""

from google.oauth2 import id_token
from google.auth.transport import requests as google_requests

from app.core.config import settings

_transport = google_requests.Request()


async def verify_google_id_token(token: str) -> dict:
    """
    Verifikasi Google ID token dan return payload (sub, email, name, picture, dll).

    Raises:
        ValueError: jika token tidak valid atau expired
    """
    payload = id_token.verify_oauth2_token(
        token,
        _transport,
        audience=settings.google_client_id,
    )

    # Pastikan issuer dari Google
    if payload.get("iss") not in ("accounts.google.com", "https://accounts.google.com"):
        raise ValueError("Invalid token issuer")

    return payload
