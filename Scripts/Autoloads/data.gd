class_name Data extends Resource

enum Progress
{
	UNLOCKED		= 1, # 0000 0001
	COMPLETED		= 2, # 0000 0010
	CHEST_OPENED	= 4, # 0000 0100
	ANOTHER_THING	= 8, # 0000 1000
	ETC				= 16 # 0001 0000
}

@export var world : int
@export var level : int
@export var coins : int
@export var lives : int
@export var checkpoint : int
@export var has_key : bool
@export var progress : Array[Array]

func _init():
	world = 1
	level = 1
	coins = 0
	lives = 3
	checkpoint = 0
	has_key = false
	progress = [[Progress.UNLOCKED, 0, 0, 0]]

#progress[0][0] = 00000000 00000000 00000000 00000000 <- LOCKED
#progress[0][0] = 00000000 00000000 00000000 00000001 <- UNLOCKED
#progress[0][0] = 00000000 00000000 00000000 00000011 <- UNLOCKED & COMPLETED

func set_progress_marker(marker : Progress, world_id : int = world, level_id : int = level, on : bool = true):
	if world_id <= 0 || world_id > progress.size() || level_id <= 0 || level_id > progress[world_id - 1].size():
		push_warning("Invalid set progress marker index at world " + str(world_id) + " level " + str(level_id))
		return
	if on:
		progress[world_id - 1][level_id - 1] |= marker
	else: #off
		progress[world_id - 1][level_id - 1] &= !marker

func check_progress_marker(marker : Progress, world_id : int = world, level_id : int = level) -> bool:
	if world_id <= 0 || world_id > progress.size() || level_id <= 0 || level_id > progress[world_id - 1].size():
		push_warning("Invalid check progress marker index at world " + str(world_id) + " level " + str(level_id))
		return false
	return progress[world_id - 1][level_id - 1] & marker

func reset(game_over : bool):
	if game_over:
		coins = 0
		lives = 3
	checkpoint = 0
	has_key = false
