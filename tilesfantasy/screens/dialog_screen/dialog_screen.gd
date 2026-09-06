extends Control

@onready var npc_type_lb: Label = $NpcLBs/NpcTypeLB
@onready var npc_name_lb: Label = $NpcLBs/NpcNameLB
@onready var npc_nation_lb: Label = $NpcLBs/NpcNationLB
@onready var npc_level_lb: Label = $NpcLBs/NpcLevelLB
@onready var npc_frame: Sprite2D = $NpcFrame
@onready var npc_icon: Sprite2D = $NpcIcon

@onready var npc_script: Label = $NpcScript
@onready var dialog_sentence: Label = $DialogSentence

@onready var sentences_controls: Control = $SentencesControls

var npc_data : Dictionary = {}
var npc_name : String = ""
var cursor : String = "start"

var selected_button : int = 0
var dialog_buttons : Array[Control] = []
var wait_time : float = 2.0

func _ready() -> void:
	var data = GlobalFunctions.load_json_data("res://hot_stuff/npc_data.json")
	initialize("Gary Fara", data["Gary Fara"])


func initialize(npcName : String, data : Dictionary):
	npc_data = data
	npc_name = npcName
	
	npc_type_lb.text = data["type"]
	npc_name_lb.text = npcName
	npc_nation_lb.text = data["nation"]
	npc_level_lb.text = "Level " + str(data["level"])

	match npc_name:
		"Sidewalk Sid":
			npc_frame.frame = 1
		_:
			npc_frame.frame = 0
			
	match data["type"]:
		"Merchant":
			npc_icon.frame = 1
		_:
			npc_icon.frame = 0 

	await update_dialog()


func update_dialog(choice : String = ""):
	if choice == ""  and cursor != "start":
		#exit error
		return
	
	if choice != "":
		cursor = choice
	
	npc_script.text = npc_data["dialog"][cursor]["text"]
	dialog_sentence.text = ""
	
	if npc_data["dialog"][cursor].has("action"):
		await comute_action(npc_data["dialog"][cursor]["action"])
		return

	var py : int = 0
	for c in npc_data["dialog"][cursor]["choices"]:
		print(c)
		var bb = load("res://screens/aux_screens/battle_button/BattleButton.tscn").instantiate()
		bb.action = c["text"]
		sentences_controls.add_child(bb)
		dialog_buttons.append(bb)
		bb.button.size. x = 322

		var font := get_theme_font("font")
		var font_size = 16
		var text_size := font.get_multiline_string_size(bb.button.text,HORIZONTAL_ALIGNMENT_LEFT,bb.button.size.x,font_size)

		var lines := int(ceil(text_size.y / font.get_height(font_size)))
		bb.position.y = py

		py += (lines * 16) + 8
		
	dialog_sentence.text = npc_data["dialog"][cursor]["question"]
		
	if dialog_buttons.size() > 0:
		dialog_buttons[0].is_selected = true
		dialog_buttons[0].update()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		selected_button += 1

		if selected_button >= dialog_buttons.size():
			selected_button = 0
		update_buttons()

	if event.is_action_pressed("ui_up"):
		selected_button -= 1

		if selected_button < 0:
			selected_button = dialog_buttons.size() - 1
		update_buttons()

	if event.is_action_pressed("ui_accept"):
		await press_selected_button()


func press_selected_button() -> void:
	if len(dialog_buttons) < 1:
		return
	
	var button = dialog_buttons[selected_button]
	var choice : String = ""
	for c in npc_data["dialog"][cursor]["choices"]:
		if c["text"] == button.action:
			choice = c["next"]
			for b in dialog_buttons:
				b.queue_free()
			dialog_buttons.clear()
			
			await update_dialog(choice)
			return
			
	#error
	return 
	
func update_buttons() -> void:
	for i in dialog_buttons.size():
		dialog_buttons[i].is_selected = i == selected_button
		dialog_buttons[i].update()


func comute_action(action : String = "") -> void:
	print(action)
	await get_tree().create_timer(wait_time).timeout
	match action:
		"open_shop":
			print("lalal")
		"close":
			queue_free()
		_:
			return
