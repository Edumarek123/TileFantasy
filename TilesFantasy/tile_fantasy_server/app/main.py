
from fastapi import FastAPI, HTTPException
import asyncio

from app.api.api import router as api_router
from app.websocket.websocket import router as ws_router
from app.game.game_loop import game_loop, save_loop


app = FastAPI()

app.include_router(api_router)
app.include_router(ws_router)

game_task = None
save_task = None


@app.on_event("startup")
async def startup():
    global game_task
    global save_task

    game_task = asyncio.create_task(game_loop())
    save_task = asyncio.create_task(save_loop())


@app.on_event("shutdown")
async def shutdown():
    global game_task
    global save_task

    game_task.cancel()
    save_task.cancel()

    try:
        await game_task
    except asyncio.CancelledError:
        pass

    try:
        await save_task
    except asyncio.CancelledError:
        pass