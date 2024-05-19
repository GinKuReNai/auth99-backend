from . import root
from fastapi import APIRouter

api_router = APIRouter()

api_router.include_router(root.router, tags=["Root"])
