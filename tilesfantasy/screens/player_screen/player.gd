extends Node2D


var PLAYER_INPUT : Vector2 = Vector2.ZERO
var LAST_INPUT : Vector2 = Vector2.ZERO


func _ready() -> void:
	#await ServerComms.login()
	pass

func _process(delta):
	if ServerComms.online_moving:
		send_input()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("ui_right"):
		PLAYER_INPUT = Vector2.RIGHT
	elif Input.is_action_pressed("ui_left"):
		PLAYER_INPUT = Vector2.LEFT
	elif Input.is_action_pressed("ui_down"):
		PLAYER_INPUT = Vector2.DOWN
	elif Input.is_action_pressed("ui_up"):
		PLAYER_INPUT = Vector2.UP
	else:
		PLAYER_INPUT = Vector2.ZERO
		
func send_input():
	if PLAYER_INPUT != LAST_INPUT:
		LAST_INPUT = PLAYER_INPUT
		var message = {"type": "input", "x": PLAYER_INPUT.x, "y": PLAYER_INPUT.y}
		ServerComms.WEBSOCKET.send_text(JSON.stringify(message))
	
