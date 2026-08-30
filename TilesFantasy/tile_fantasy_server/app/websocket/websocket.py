from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from jose import JWTError

from app.auth.auth import verify_token_ws
from app.game.game_loop import players
from app.database.database import get_player_location_db

router = APIRouter()

BASE_SPEED : float = 50.0

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


        #consultar no banco de dados ultima posicao
        x, y, r = get_player_location_db(player_id)
        players[player_id] = {
            "websocket": websocket,

            "x": x,
            "y": y,
            "r" : r,

            "input_x": 0,
            "input_y": 0,
            "speed": BASE_SPEED
        }


        print(f"Player {player_id} connected")


        #Aguarda receber inputs
        while True:
            data = await websocket.receive_json()

            if data.get("type") != "input":
                continue

            input_x = data.get("x", 0)
            input_y = data.get("y", 0)

            input_x = max(-1, min(1, input_x))
            input_y = max(-1, min(1, input_y))

            players[player_id]["input_x"] = input_x
            players[player_id]["input_y"] = input_y


    except WebSocketDisconnect:

        if player_id is not None:

            players.pop(player_id, None)

            print(f"Player {player_id} disconnected")


