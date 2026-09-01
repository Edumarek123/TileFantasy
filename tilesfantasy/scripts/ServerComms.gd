extends Node

const SERVER_URL = "http://127.0.0.1:27720"
const SERVER_WS_URL = "ws://127.0.0.1:27720/ws"
const GAME_VERSION = "0.0.1"

@onready var REQUEST : HTTPRequest = HTTPRequest.new()
@onready var WEBSOCKET := WebSocketPeer.new()

var players := {}
var TOKEN := ""
var online_moving : bool = false

signal update_region

func _ready():
	REQUEST.timeout = 5
	add_child(REQUEST)

func _process(delta):
	if not online_moving:
		return
		
	WEBSOCKET.poll()
	
	var state = WEBSOCKET.get_ready_state()

	if state == WebSocketPeer.STATE_OPEN:
		receive_messages()

	elif state == WebSocketPeer.STATE_CLOSED:
		pass
		print("WebSocket fechado")


#----------------#REQUEST#----------------#
func make_request(address : String, payload : String):
	#return [null, 500, null, "".to_utf8_buffer()]
	#print(payload)
	
	if REQUEST.get_http_client_status() != 0:
		while REQUEST.get_http_client_status() !=0:
			await get_tree().create_timer(0.05).timeout
	
	REQUEST.request(address, ["Content-Type: application/json"], HTTPClient.METHOD_POST, payload)
	var response = await REQUEST.request_completed
	return response


#----------------#LOGIN#----------------#
func login(user : String, password : String) -> int:
	var payload = JSON.stringify({"token" : "1", "payload": {"username": user, "password": password, "version": GAME_VERSION}})

	var response = await make_request(SERVER_URL + "/login", payload)
	var code = response[1]

	if code != 200:
		print("Login failed: ", code)
		return code

	var data = JSON.parse_string(response[3].get_string_from_utf8())
	TOKEN = data["token"]
	
	return code

func get_charactere_sheet() -> Dictionary:
	var payload = JSON.stringify({"token" : TOKEN, "payload": {}})

	var response = await make_request(SERVER_URL + "/get_charactere_sheet", payload)
	var code = response[1]

	if code != 200:
		print("Sheet failed: ", code)
		return code

	var data = JSON.parse_string(response[3].get_string_from_utf8())
	
	return data

#----------------#WEBSOCKET#----------------#
func connect_websocket() -> bool:
	var error = WEBSOCKET.connect_to_url(SERVER_WS_URL+"?token="+TOKEN, TLSOptions.client_unsafe())

	if error != OK:
		print("Erro ao conectar WebSocket: ", error)
		return false
	print("Conectando WebSocket...")
	online_moving = true

	return true
	
#----------------#WEBSOCKET#----------------#
func receive_messages():
	while WEBSOCKET.get_available_packet_count() > 0:
		var packet = WEBSOCKET.get_packet()
		var message = JSON.parse_string(packet.get_string_from_utf8())

		if message == null:
			continue

		if message.get("type") == "positions":
			#print(message)
			update_positions(message["players"])

#----------------#WEBSOCKET#----------------#
func update_positions(position_list):
	players.clear()
	
	for player_data in position_list:
		var player_id = player_data["player_id"]
		var position = Vector2(player_data["x"], player_data["y"])
		var region = player_data["r"]

		players[player_id] = {"p" : position, "r" : region}
	update_region.emit()
	
