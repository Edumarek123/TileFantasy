from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from jose import JWTError
import math

from app.auth.auth import verify_token_ws
from app.game.game_loop import players
from app.database.database import get_player_location_db

router = APIRouter()



#----------------#Trata Inputs#----------------#
def normalize_input(x: float, y: float):

    x = max(-1.0, min(1.0, x))
    y = max(-1.0, min(1.0, y))

    length = math.sqrt(x * x + y * y)

    if length > 1.0:
        x /= length
        y /= length

    return x, y

#----------------#Websocket#----------------#
@router.websocket("/ws")
async def websocket_movement(websocket: WebSocket):
    await websocket.accept()

    player_id = None

    try:
        token = websocket.query_params.get("token")

        if token is None:
            await websocket.close(code=1008)
            return

        try:
            player_id : str = verify_token_ws(token)

            if player_id is None:
                await websocket.close(code=1008)
                return

        except JWTError:
            await websocket.close(code=1008)
            return


        x, y, r = get_player_location_db(player_id)
        players[player_id] = {
            "websocket": websocket,

            "x": x,
            "y": y,
            "r" : r,

            "input_x": 0,
            "input_y": 0,
        }

        print(f"Player {player_id} connected")

        #Aguarda receber inputs
        while True:
            data = await websocket.receive_json()

            if data.get("type") != "input":
                continue

            input_x, input_y = normalize_input(data.get("x", 0), data.get("y", 0))
            players[player_id]["input_x"] = input_x
            players[player_id]["input_y"] = input_y

    except WebSocketDisconnect:
        if player_id is not None:
            players.pop(player_id, None)
            print(f"Player {player_id} disconnected")


