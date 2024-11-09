class_name Data extends Resource

@export var coins: int
@export var lives: int
@export var has_key: bool
@export var checkpoint: int


func _init():
	coins = 0
	lives = 3
	checkpoint = 0
	has_key = false
