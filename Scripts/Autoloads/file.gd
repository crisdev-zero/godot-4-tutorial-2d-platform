extends Node

var data: Data


#temporary
func _ready():
	new_game()


func save_file_exists() -> bool:
	return false


func new_game():
	data = Data.new()


func save_game():
	pass


func load_game():
	pass
