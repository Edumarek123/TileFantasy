extends Node

const SERVER_URL = "http://127.0.0.1:27720"
const SERVER_WS_URL = "ws://127.0.0.1:27720/ws"

@onready var REQUEST : HTTPRequest = HTTPRequest.new()
@onready var WEBSOCKET := WebSocketPeer.new()

var players := {}
var TOKEN := ""
var online_moving : bool = false


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
func login():
	var payload = JSON.stringify({"token" : "1", "payload": {"username": "admin", "password": "123", "version": "0.0.1"}})

	var response = await make_request(SERVER_URL + "/login", payload)
	var code = response[1]

	if code != 200:
		print("Login falhou: ", code)
		return

	var data = JSON.parse_string(response[3].get_string_from_utf8())
	TOKEN = data["token"]
	print(TOKEN)
	
	connect_websocket()


#----------------#WEBSOCKET#----------------#
func connect_websocket():

	var error = WEBSOCKET.connect_to_url(SERVER_WS_URL+"?token="+TOKEN, TLSOptions.client_unsafe())

	if error != OK:
		print("Erro ao conectar WebSocket: ", error)
		return
	print("Conectando WebSocket...")
	online_moving = true

#----------------#WEBSOCKET#----------------#
func receive_messages():
	while WEBSOCKET.get_available_packet_count() > 0:
		var packet = WEBSOCKET.get_packet()
		var message = JSON.parse_string(packet.get_string_from_utf8())

		if message == null:
			continue

		if message.get("type") == "positions":
			print(message)
			update_positions(message["players"])

#----------------#WEBSOCKET#----------------#
func update_positions(position_list):

	for player_data in position_list:
		var player_id = player_data["player_id"]
		var position = Vector2(player_data["x"], player_data["y"])

		players[player_id] = position
		
		#print(players)
		
	
