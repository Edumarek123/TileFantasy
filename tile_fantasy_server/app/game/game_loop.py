import asyncio

from app.database.database import update_player_position_db
from app.game.map_manager import MapManager

#------------#World Positions#------------#

players = {}


#------------#Game Settings#------------#

SAVE_INTERVAL = 120.0
BASE_SPEED: float = 50.0

map_manager = MapManager()


#------------#Websocket#------------#

async def game_loop():

    loop = asyncio.get_running_loop()

    previous_time = loop.time()

    while True:

        # Loop Timers
        current_time = loop.time()
        delta = current_time - previous_time
        previous_time = current_time

        delta = min(delta, 0.1)

        # Physics
        physics_update(delta)

        # Send Positions
        await broadcast_positions()

        await asyncio.sleep(0.05)


async def broadcast_positions():

    # Copia o dicionario: jogadores podem conectar/desconectar durante os awaits
    snapshot = list(players.items())

    regions: dict = {}

    for player_id, p in snapshot:
        regions.setdefault(p["r"], []).append({
            "player_id": player_id,
            "x": p["x"],
            "y": p["y"],
            "r": p["r"]
        })

    for player_id, player in snapshot:

        try:
            await player["websocket"].send_json({
                "type": "positions",
                "players": regions.get(player["r"], [])
            })

        except Exception as error:

            # Um socket morto nao pode derrubar o loop de todos
            print(f"Erro ao enviar para {player_id}: {error}")

            if players.get(player_id) is player:
                players.pop(player_id, None)


#------------#Physics#------------#

def physics_update(delta: float):

    for player in players.values():

        movement_x = (player["input_x"] * BASE_SPEED * delta)

        new_x = player["x"] + movement_x

        if not map_manager.is_position_blocked(player["r"], new_x, player["y"]):
            player["x"] = round(new_x, 3)

        else:
            tile_x, tile_y = map_manager.world_to_tile(new_x, player["y"])

            if movement_x > 0:
                player["x"] = tile_x * map_manager.TILE_SIZE

            elif movement_x < 0:
                player["x"] = (tile_x + 1) * map_manager.TILE_SIZE


        movement_y = (player["input_y"] * BASE_SPEED * delta)

        new_y = player["y"] + movement_y

        if not map_manager.is_position_blocked(player["r"], player["x"], new_y):
            player["y"] = round(new_y, 3)

        else:
            tile_x, tile_y = map_manager.world_to_tile(player["x"], new_y)

            if movement_y > 0:
                player["y"] = tile_y * map_manager.TILE_SIZE

            elif movement_y < 0:
                player["y"] = (tile_y + 1) * map_manager.TILE_SIZE

        teleport = map_manager.get_teleport(player["r"], player["x"], player["y"])

        if teleport is not None:
            tx, ty = map_manager.tile_to_world(teleport["target_x"], teleport["target_y"])

            player["r"] = teleport["target_r"]
            player["x"] = tx
            player["y"] = ty


#------------#Save Loop#------------#

async def save_loop():

    while True:

        await asyncio.sleep(SAVE_INTERVAL)

        if len(players) > 0:
            await save_all_players_positons()


#------------#Save Positions#------------#

async def save_all_players_positons():

    print(f"Salvando {len(players)} jogadores...")

    tasks = []

    snapshot = list(players.items())

    for player_id, player in snapshot:

        tasks.append(
            asyncio.to_thread(
                update_player_position_db,
                player_id,
                player["x"],
                player["y"],
                player["r"]
            )
        )

    if tasks:

        task_results = await asyncio.gather(*tasks, return_exceptions=True)

        for (player_id, _), result in zip(snapshot, task_results):

            if isinstance(result, Exception):

                print(
                    f"Erro ao salvar "
                    f"{player_id}: {result}"
                )