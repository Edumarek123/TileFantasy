import asyncio
from app.database.database import update_player_position_db

#----------------#WORLD-POSITIONS#----------------#
players = {}
SAVE_INTERVAL = 120.0

#----------------#Websocket#----------------#
async def game_loop():
    loop = asyncio.get_running_loop()

    previous_time = loop.time()

    while True:

        current_time = loop.time()

        delta = current_time - previous_time
        previous_time = current_time

        delta = min(delta, 0.1)

        #fisica do jogo

        for player in players.values():

            player["x"] += round(player["input_x"] * player["speed"] * delta, 3)
            player["y"] += round(player["input_y"] * player["speed"] * delta, 3)
            
            #verificar colisoes

        #envia posicoess
        for player in players.values():
            await player["websocket"].send_json({
                "type": "positions",

                "players": [
                    {
                        "player_id": player_id,
                        "x": p["x"],
                        "y": p["y"],
                        "r": p["r"]
                    }

                    for player_id, p in players.items()
                ]
            })

        await asyncio.sleep(0.05)



#----------------#Save-Loop#----------------#
async def save_loop():
    while True:
        await asyncio.sleep(SAVE_INTERVAL)

        if len(players) > 0:
            await save_all_players_positons()


async def save_all_players_positons():
    print(f"Salvando {len(players)} jogadores...")

    tasks = []

    for player_id, player in players.items():

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
        taks_results = await asyncio.gather(*tasks, return_exceptions = True)

        for player_id, result in zip(players.keys(), taks_results):
            if isinstance(result, Exception):
                print(f"Erro ao salvar {player_id}: {result}")