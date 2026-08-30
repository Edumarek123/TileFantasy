extends Control

@onready var action_button_1: Control = $MainActions/ActionButton1
@onready var action_button_2: Control = $MainActions/ActionButton2
@onready var action_button_3: Control = $MainActions/ActionButton3
@onready var action_button_4: Control = $MainActions/ActionButton4
@onready var action_button_5: Control = $MainActions/ActionButton5

var last_selected = null
@onready var buttons: Array[Control] = [
		action_button_1,
		action_button_2,
		action_button_3,
		action_button_4,
		action_button_5]
	
var selected_index: int = 0

func desselect_buttons(b : int) -> void:
	if last_selected != null:
		last_selected.is_selected = false
		last_selected.update()
		
	match b:
		1:
			last_selected = action_button_1
		2:
			last_selected = action_button_2
		3:
			last_selected = action_button_3
		4:
			last_selected = action_button_4
		5:
			last_selected = action_button_5
		_:
			last_selected = null

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_right") or event.is_action_pressed("ui_down") or event.is_action_pressed("ui_left") or event.is_action_pressed("ui_up")) and last_selected == null:
		last_selected = action_button_1
		last_selected.is_selected = true
		last_selected.update()
		selected_index = 0
		return
		
	if event.is_action_pressed("ui_right") or event.is_action_pressed("ui_down"):
		selected_index += 1
		
		if selected_index >= buttons.size():
			selected_index = 0
		
		if last_selected != null:
			last_selected.is_selected = false
			last_selected.update()
		
		last_selected = buttons[selected_index]
		last_selected.is_selected = true
		last_selected.update()


	elif event.is_action_pressed("ui_left") or event.is_action_pressed("ui_up"):
		selected_index -= 1
		
		if selected_index < 0:
			selected_index = buttons.size() - 1
		
		if last_selected != null:
			last_selected.is_selected = false
			last_selected.update()
		
		last_selected = buttons[selected_index]
		last_selected.is_selected = true
		last_selected.update()


	elif event.is_action_pressed("ui_accept"):
		print("Comutar acao")
		print(selected_index)
		if last_selected != null:
			last_selected.pressed.emit()
			last_selected = null
			selected_index = 0
	
	
func _on_action_button_1_pressed() -> void:
	desselect_buttons(1)

func _on_action_button_2_pressed() -> void:
	desselect_buttons(2)


func _on_action_button_3_pressed() -> void:
	desselect_buttons(3)


func _on_action_button_4_pressed() -> void:
	desselect_buttons(4)


func _on_action_button_5_pressed() -> void:
	desselect_buttons(5)
