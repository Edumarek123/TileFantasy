extends Node2D


@onready var region_builder: Node2D = $RegionBuilder
@onready var player: Node2D = $Player

var target_position: Vector2


func _ready() -> void:
	var map : Dictionary = load_map_json("res://hot_stuff/steel_city.json")
	region_builder.generate_map(map, "steel_city")
	ServerComms.update_region.connect(update_region)
	

func _process(delta):
	player.position = player.position.lerp(target_position, 16.0 * delta)
	

func update_region():
	var data = ServerComms.players["JmA9WItkRgaJYVzdqzSh-A"]
	target_position = Vector2(data[0], data[1])


func load_map_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)

	if file == null:
		push_error("Não foi possível abrir o arquivo: " + path)
		return {}

	var content := file.get_as_text()
	var data = JSON.parse_string(content)

	if data == null:
		push_error("JSON inválido: " + path)
		return {}
	
	return data
