extends Node

const INITIAL_SCREEN = preload("res://screens/initial_scene.tscn")
const LOGIN_SCREEN = preload("res://screens/login_screen/login_screen.tscn")
const MENU_SCREEN = preload("res://screens/menu_screen/menu_screen.tscn")
const LOADING_GAME_SCREEN = preload("res://screens/loading_game_screen/loadign_game_screen.tscn")
const GAME_WORLD = preload("res://screens/world_screen/world_screen.tscn")

#const FIND_GAME = preload("res://scenes/Menus/FindGame/FindGame.tscn")
#const CONFIGURATION_SCREEN = preload("res://screens/configurations_screen/configurations_screen.tscn")


@onready var NOW_SCREEN = null

func change_screen(screenName : String, _args = null):
	var screen

	match screenName:
		"InitialScreen":
			screen = INITIAL_SCREEN.instantiate()
			pass
		"LoginScreen":
			screen = LOGIN_SCREEN.instantiate()	
		"MenuScreen":
			screen = MENU_SCREEN.instantiate()
		"LoadingGameScreen":
			screen = LOADING_GAME_SCREEN.instantiate()	
		"GameWorld":
			screen = GAME_WORLD.instantiate()
		"ConfigurationScreen":
			#screen = CONFIGURATION_SCREEN.instantiate()
			pass
		_:
			pass
	
	if NOW_SCREEN:
		NOW_SCREEN.queue_free()
	
	NOW_SCREEN = screen
	add_child(NOW_SCREEN)
	
