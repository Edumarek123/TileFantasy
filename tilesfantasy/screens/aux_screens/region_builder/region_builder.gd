extends Node2D

@onready var ground_layer: TileMapLayer = $TileMapLayer

const TILE_SIZE := 16
const TILESET_WIDTH := 1024
const TILES_PER_ROW := TILESET_WIDTH / TILE_SIZE


func generate_map(json_data: Dictionary, region: String) -> void:
	if not json_data.has(region):
		push_error("Região não encontrada: " + region)
		return

	var map_data: Dictionary = json_data[region]["map"]

	ground_layer.clear()

	for y_key in map_data:
		var row = map_data[y_key]
		var y := int(y_key)

		for x in range(row.size()):
			var tile_id: int = int(row[x])
			ground_layer.set_cell(Vector2i(x, y), 0, Vector2i(tile_id % TILES_PER_ROW, tile_id / TILES_PER_ROW))
