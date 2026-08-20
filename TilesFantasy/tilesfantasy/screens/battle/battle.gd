extends Control

@onready var battle_button_1: Node2D = $buttons/BattleButton1
@onready var battle_button_2: Node2D = $buttons/BattleButton2
@onready var battle_button_3: Node2D = $buttons/BattleButton3
@onready var battle_button_4: Node2D = $buttons/BattleButton4
@onready var battle_button_5: Node2D = $buttons/BattleButton5
@onready var battle_button_6: Node2D = $buttons/BattleButton6

var last_selected = null
@onready var buttons: Array[Node2D] = [
		battle_button_1,
		battle_button_2,
		battle_button_3,
		battle_button_4,
		battle_button_5,
		battle_button_6]
	
var selected_index: int = 0

func desselect_buttons(b : int) -> void:
	if last_selected != null:
		last_selected.is_selected = false
		last_selected.update()
		
	match b:
		1:
			last_selected = battle_button_1
		2:
			last_selected = battle_button_2
		3:
			last_selected = battle_button_3
		4:
			last_selected = battle_button_4
		5:
			last_selected = battle_button_5
		6:
			last_selected = battle_button_6
		_:
			last_selected = null

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_right") or event.is_action_pressed("ui_down") or event.is_action_pressed("ui_left") or event.is_action_pressed("ui_up")) and last_selected == null:
		last_selected = battle_button_1
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
	
	
func _on_battle_button_1_pressed() -> void:
	desselect_buttons(1)

func _on_battle_button_2_pressed() -> void:
	desselect_buttons(2)


func _on_battle_button_3_pressed() -> void:
	desselect_buttons(3)


func _on_battle_button_4_pressed() -> void:
	desselect_buttons(4)


func _on_battle_button_5_pressed() -> void:
	desselect_buttons(5)


func _on_battle_button_6_pressed() -> void:
	desselect_buttons(6)
