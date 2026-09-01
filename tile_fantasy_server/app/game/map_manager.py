import json
from pathlib import Path

class MapManager:

    TILE_SIZE = 16

    COLLISION_TILES = {15}


    #------------#Load#------------#

    def __init__(self):

        self.data_path = (Path(__file__).resolve().parent.parent / "game_data")

        self.maps: dict = {}

        self.load_maps()


    def load_maps(self) -> None:

        if not self.data_path.exists():
            raise FileNotFoundError(
                f"Game data directory not found: {self.data_path}"
            )

        for file_path in self.data_path.glob("*.json"):

            try:
                with open(file_path, "r", encoding="utf-8") as file:
                    data = json.load(file)

                if not isinstance(data, dict):
                    print(f"Invalid JSON format: {file_path.name}")
                    continue

                for region_name, region_data in data.items():

                    self.maps[region_name] = region_data

                    print(
                        f"Loaded region: "
                        f"{region_name} "
                        f"({file_path.name})")

            except json.JSONDecodeError as error:

                print(f"Invalid JSON: {file_path.name}")
                print(error)

            except Exception as error:

                print(
                    f"Error loading "
                    f"{file_path.name}: {error}"
                )


    #------------#Region#------------#

    def get_region(self, region: str) -> dict | None:

        return self.maps.get(region)


    #------------#Tile#------------#

    def get_tile(self, region: str, tile_x: int, tile_y: int) -> int:

        region_data = self.maps.get(region)

        if region_data is None:
            return 15

        map_data = region_data.get("map")

        if map_data is None:
            return 15

        row = map_data.get(str(tile_y))

        if row is None:
            return 15

        if tile_x < 0 or tile_x >= len(row):
            return 15

        return int(row[tile_x])

    #------------#Collision#------------#

    def is_blocked(self, region: str, tile_x: int, tile_y: int) -> bool:

        tile = self.get_tile(region, tile_x, tile_y)

        return tile in self.COLLISION_TILES


    #------------#World Position#------------#

    def world_to_tile(self, x: float, y: float) -> tuple[int, int]:

        return (int(x // self.TILE_SIZE), int(y // self.TILE_SIZE))

    def tile_to_world(self, tx: float, ty: float) -> tuple[int, int]:

        return (int(tx * self.TILE_SIZE), int(ty * self.TILE_SIZE))


    def is_position_blocked(self, region: str, x: float, y: float) -> bool:

        tile_x, tile_y = self.world_to_tile(x, y)

        return self.is_blocked(region, tile_x, tile_y)


    #------------#Teleport#------------#

    def get_teleport(self, region: str, x: float, y: float) -> dict | None:

        region_data = self.maps.get(region)

        if region_data is None:
            return None

        teleports = region_data.get("teleports", [])

        tile_x, tile_y = self.world_to_tile(x, y)

        for teleport in teleports:

            tx = teleport["x"]
            ty = teleport["y"]

            width = teleport["w"]
            height = teleport["h"]

            if tx <= tile_x < tx + width and ty <= tile_y < ty + height:                
                return teleport

        return None