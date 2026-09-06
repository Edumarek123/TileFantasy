extends Node




func load_json_data(path : String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)

	if file == null:
		push_error("Não foi possível abrir o arquivo: " + path)
		return {}

	var content := file.get_as_text()
	var data = JSON.parse_string(content)

	if data == null:
		push_error("JSON inválido: " + path)
		return {}
	
	return data
