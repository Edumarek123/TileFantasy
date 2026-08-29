from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from jose import JWTError
from app.auth.auth import verify_token_ws
from app.game.game_loop import players

router = APIRouter()

#----------------#Websocket#----------------#

@router.websocket("/ws")
async def websocket_movement(websocket: WebSocket):
    await websocket.accept()

    username = None

    try:
        token = websocket.query_params.get("token")
        print(token)

        if token is None:
            await websocket.close(code=1008)
            return

        try:
            username : str = verify_token_ws(token)

            if username is None:
                await websocket.close(code=1008)
                return

        except JWTError:
            await websocket.close(code=1008)
            return


        #consultar no banco de dados ultima posicao
        players[username] = {

            "websocket": websocket,

            "region" : "steel_city",

            "x": 100.0,
            "y": 100.0,

            "input_x": 0,
            "input_y": 0,

            "speed": 50.0
        }


        print(f"Player {username} connected")


        #Aguarda receber inputs
        while True:
            data = await websocket.receive_json()

            if data.get("type") != "input":
                continue

            input_x = data.get("x", 0)
            input_y = data.get("y", 0)

            input_x = max(-1, min(1, input_x))
            input_y = max(-1, min(1, input_y))

            players[username]["input_x"] = input_x
            players[username]["input_y"] = input_y


    except WebSocketDisconnect:

        if username is not None:

            players.pop(username, None)

            print(f"Player {username} disconnected")


