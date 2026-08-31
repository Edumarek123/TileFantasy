extends Control


@onready var email_entry: LineEdit = $EmailEntry
@onready var password_entry: LineEdit = $PasswordEntry
@onready var error_lb: Label = $ErrorLB

func get_argument(args: PackedStringArray, argument: String, default_value: String) -> String:
	var index := args.find(argument)

	if index != -1 and index + 1 < args.size():
		return args[index + 1]

	return default_value

func _ready() -> void:
	#deletar
	#email_entry.text = "teste1"
	var args := OS.get_cmdline_args()
	email_entry.text = get_argument(args, "--username", "teste1")
	print(email_entry.text)
	password_entry.text = "123"
	_on_login_btn_pressed()
	

func display_error(error : String):
	error_lb.text = error
	error_lb.show()
	await get_tree().create_timer(5.0).timeout
	error_lb.hide()


func _on_login_btn_pressed() -> void:
	var user :  String = email_entry.text
	var password :  String = password_entry.text
	
	var response : int = await ServerComms.login(user, password)
	
	match response:
		200:
			var sheet : Dictionary = await ServerComms.get_charactere_sheet()
			GlobalInfo.CHAR_SHEET.load_charactere(sheet)
			#GlobalInfo.CHAR_SHEET.print_sheet()
			
			ScreenManager.change_screen("MenuScreen")
		_:
			var err = "Login error code: " + str(response)
			display_error(err)
	
