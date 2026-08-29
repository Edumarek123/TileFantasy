from app.api.api import router as api_router
from app.websocket.websocket import router as ws_router
from app.game.game_loop import game_loop

from fastapi import FastAPI, HTTPException
import asyncio


app = FastAPI()
game_task = None

app.include_router(api_router)
app.include_router(ws_router)


@app.on_event("startup")
async def startup():
    global game_task
    game_task = asyncio.create_task(game_loop())


@app.on_event("shutdown")
async def shutdown():

    game_task.cancel()

    try:
        await game_task
    except asyncio.CancelledError:
        pass