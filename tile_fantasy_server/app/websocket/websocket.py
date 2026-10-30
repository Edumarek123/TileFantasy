from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from jose import JWTError
import asyncio
import math

from app.auth.auth import verify_token_ws
from app.game.game_loop import players
from app.database.database import get_player_location_db, update_player_position_db

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


def parse_axis(value) -> float:

    # bool e subclasse de int; NaN/inf nao sao inputs validos
    if isinstance(value, bool) or not isinstance(value, (int, float)):
        return 0.0

    if not math.isfinite(value):
        return 0.0

    return float(value)

#----------------#Websocket#----------------#
@router.websocket("/ws")
async def websocket_movement(websocket: WebSocket):
    await websocket.accept()

    player_id = None
    player = None

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

        if x is None:
            await websocket.close(code=1011)
            return

        # Mesmo jogador conectando de novo: derruba a sessao antiga
        old_player = players.get(player_id)
        if old_player is not None:
            try:
                await old_player["websocket"].close(code=4000)
            except Exception:
                pass

        player = {
            "websocket": websocket,

            "x": x,
            "y": y,
            "r" : r,

            "input_x": 0,
            "input_y": 0,
        }
        players[player_id] = player

        print(f"Player {player_id} connected")

        #Aguarda receber inputs
        while True:
            data = await websocket.receive_json()

            if not isinstance(data, dict) or data.get("type") != "input":
                continue

            input_x, input_y = normalize_input(parse_axis(data.get("x", 0)), parse_axis(data.get("y", 0)))
            player["input_x"] = input_x
            player["input_y"] = input_y

    except WebSocketDisconnect:
        pass

    except Exception as error:
        print(f"Erro no websocket de {player_id}: {error}")

    finally:
        # So remove se a entrada ainda for desta conexao (nao de uma reconexao)
        if player is not None and players.get(player_id) is player:
            players.pop(player_id, None)

            try:
                await asyncio.to_thread(update_player_position_db, player_id, player["x"], player["y"], player["r"])
            except Exception as error:
                print(f"Erro ao salvar {player_id}: {error}")

            print(f"Player {player_id} disconnected")
