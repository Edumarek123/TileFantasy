extends Node2D


@onready var region_builder: Node2D = $RegionBuilder
@onready var player: Node2D = $Player
@onready var players: Node2D = $Players

var target_position: Vector2
var players_nodes: Dictionary = {}


func _ready() -> void:
	var map : Dictionary = load_map_json("res://hot_stuff/steel_city.json")
	region_builder.generate_map(map, "steel_city")
	ServerComms.update_region.connect(update_region)
	

func _process(delta):
	player.position = player.position.lerp(target_position, 16.0 * delta)

	for player_id in players_nodes:
		var dummy = players_nodes[player_id]
		dummy.position = dummy.position.lerp(
			dummy.target_position,
			16.0 * delta
		)	

func update_region() -> void:
	#Player
	var player_id = GlobalInfo.CHAR_SHEET.player_id
	var player_data = ServerComms.players[player_id]
	target_position = Vector2(player_data[0], player_data[1])

	#Dummys	
	for p in ServerComms.players:
		if p == player_id:
			continue

		var data = ServerComms.players[p]
		var pos = Vector2(data[0], data[1])

		if not players_nodes.has(p):
			create_dummy(p, pos)

		players_nodes[p].target_position = pos		
		
	check_removed_dummy()


func create_dummy(dummy_id : String, initial_position : Vector2) -> void:
	var dummy = preload("res://screens/aux_screens/player_dummys/player_dummys.tscn").instantiate()
	dummy.position = initial_position
	dummy.target_position = initial_position
	players.add_child(dummy)
	players_nodes[dummy_id] = dummy


func check_removed_dummy() -> void:
	for p in players_nodes.keys():
		if not ServerComms.players.has(p):
			players_nodes[p].queue_free()
			players_nodes.erase(p)


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
