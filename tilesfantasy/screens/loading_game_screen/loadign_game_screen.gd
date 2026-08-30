extends Control

func _ready() -> void:
	connect_to_world()
		

func connect_to_world():
	var response : bool = await ServerComms.connect_websocket()
	
	if response:
		print("conectado")
		ScreenManager.change_screen("GameWorld")
