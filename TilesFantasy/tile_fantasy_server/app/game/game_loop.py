import asyncio


players = {}

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

            player["x"] += (
                player["input_x"]
                * player["speed"]
                * delta
            )

            player["y"] += (
                player["input_y"]
                * player["speed"]
                * delta
            )
            
            #verificar colisoes

        #envia posicoess
        for player in players.values():
            await player["websocket"].send_json({
                "type": "positions",

                "players": [
                    {
                        "player_id": player_id,
                        "x": p["x"],
                        "y": p["y"]
                    }

                    for player_id, p in players.items()
                ]
            })

        await asyncio.sleep(0.05)
