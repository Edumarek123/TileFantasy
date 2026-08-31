extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

var dummy_id : String = ""
var dummy_name : String = ""
var dummy_sprite : int = 0

var target_position : Vector2 = Vector2.ZERO

func _ready() -> void:
	update()

func update():
	sprite_2d.frame = dummy_sprite
	
