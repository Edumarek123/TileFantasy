extends Control


@onready var cursor_left: Sprite2D = $cursor_left
@onready var button: Button = $Button

signal pressed

@export var action : String = ""

var is_selected : bool = false

func _ready() -> void:
	update()

func update():
	cursor_left.frame = int(is_selected)
	button.text = action

func _on_button_pressed() -> void:
	is_selected = true
	update()
	pressed.emit()
