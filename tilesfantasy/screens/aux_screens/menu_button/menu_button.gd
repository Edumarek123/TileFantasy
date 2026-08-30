extends Control


@export var ButtonText : String = "error"
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var button: Button = $Button

signal pressed


func _ready() -> void:
	button.text = ButtonText

func _on_button_button_down() -> void:
	sprite_2d.frame = 1

func _on_button_button_up() -> void:
	sprite_2d.frame = 0

func _on_button_pressed() -> void:
	pressed.emit()
