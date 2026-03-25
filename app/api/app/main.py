from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.database import init_db, close_db
from app.features.auth.router import router as auth_router
from app.features.quran.router import router as quran_router
from app.features.playlist.router import router as playlist_router
from app.features.practice.router import router as practice_router
from app.features.prayer.router import router as prayer_router
from app.features.recommendation.router import router as recommendation_router
from app.features.sunnah.router import router as sunnah_router
from app.features.recitation.router import router as recitation_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    await init_db()
    yield
    await close_db()


app = FastAPI(
    title="Qalby API",
    description="Backend untuk aplikasi Qalby - Quran Memorization",
    version="0.2.0",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth_router, prefix="/api/v1")
app.include_router(quran_router, prefix="/api/v1")
app.include_router(playlist_router, prefix="/api/v1")
app.include_router(practice_router, prefix="/api/v1")
app.include_router(prayer_router, prefix="/api/v1")
app.include_router(recommendation_router, prefix="/api/v1")
app.include_router(sunnah_router, prefix="/api/v1")
app.include_router(recitation_router, prefix="/api/v1")


@app.get("/")
async def root():
    return {"app": "Qalby API", "version": "0.2.0", "status": "ok"}


@app.get("/health")
async def health():
    return {"status": "ok"}
