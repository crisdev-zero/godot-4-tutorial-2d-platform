class_name Data extends Resource

@export var coins: int
@export var lives: int
@export var has_key: bool
@export var checkpoint: int
@export var world: int
@export var level: int


# Built-in methods
func _init():
	world = 1
	level = 1
	coins = 0
	lives = 3
	checkpoint = 0
	has_key = false


# Public methods
func retry():
	coins = 0
	lives = 3
	checkpoint = 0
	has_key = false
