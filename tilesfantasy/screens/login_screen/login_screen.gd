extends Control


@onready var email_entry: LineEdit = $EmailEntry
@onready var password_entry: LineEdit = $PasswordEntry
@onready var error_lb: Label = $ErrorLB


func _ready() -> void:
	#deletar
	email_entry.text = "teste1"
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
			ScreenManager.change_screen("MenuScreen")
		_:
			var err = "Login error code: " + str(response)
			display_error(err)
	
