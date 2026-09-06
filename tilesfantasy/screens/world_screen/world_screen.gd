extends Node2D


@onready var region_builder: Node2D = $RegionBuilder
@onready var player: Node2D = $Player
@onready var players: Node2D = $Players

var target_position: Vector2
var region : String = ""
var players_nodes: Dictionary = {}


func _ready() -> void:
	region = GlobalInfo.CHAR_SHEET.positionR
	var map : Dictionary = load_map_json(region)
	player.position = Vector2(GlobalInfo.CHAR_SHEET.positionX, GlobalInfo.CHAR_SHEET.positionY)

	region_builder.generate_map(map, region)
	ServerComms.update_region.connect(update_region)
	

func _process(delta):
	player.position = player.position.lerp(target_position, 16.0 * delta)

	for player_id in players_nodes:
		var dummy = players_nodes[player_id]
		dummy.position = dummy.position.lerp(
			dummy.target_position,
			16.0 * delta
		)	

func change_region(new_region : String):
	var map : Dictionary = load_map_json(new_region)
	region_builder.generate_map(map, new_region)
	region = new_region
	

func update_region() -> void:
	#Player
	var player_id = GlobalInfo.CHAR_SHEET.player_id
	var player_data = ServerComms.players[player_id]
	
	if region != player_data["r"]:
		change_region(player_data["r"])
		
	target_position = Vector2(player_data["p"][0], player_data["p"][1])

	#Dummys	
	for p in ServerComms.players:
		if p == player_id:
			continue

		var data = ServerComms.players[p]
		var pos = Vector2(data["p"][0], data["p"][1])

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


func load_map_json(region: String) -> Dictionary:
	var path : String = "res://hot_stuff/" + region + ".json"
	var data = GlobalFunctions.load_json_data(path)

	return data
