extends Control



func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("#040404"))
	
	await get_tree().create_timer(0.10).timeout
	
	ScreenManager.change_screen("LoginScreen")
	
	queue_free()
