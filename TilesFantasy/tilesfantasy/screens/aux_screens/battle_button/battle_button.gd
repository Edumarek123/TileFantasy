extends Node2D


@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var cursor_right: Sprite2D = $cursor_right
@onready var cursor_left: Sprite2D = $cursor_left

@onready var skill_sprite: Sprite2D = $SkillSprite
@onready var skill_name_lb: Label = $SkillName

signal pressed

@export var is_left : bool = false
@export var skill_name : String = ""

var is_selected : bool = false

func _ready() -> void:
	update()

func update():
	cursor_left.visible = is_left
	cursor_right.visible = not is_left
	sprite_2d.frame = int(is_selected) 
	cursor_left.frame = int(is_selected) 
	cursor_right.frame = int(is_selected) 

	skill_name_lb.text = skill_name

func _on_button_pressed() -> void:
	is_selected = true
	update()
	
	pressed.emit()
