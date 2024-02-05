extends BossEncounter

@onready var _timer : Timer = $Timer
@onready var _rng : RandomNumberGenerator = RandomNumberGenerator.new()
var _random : int

func _decide_next_attack():
	for boss in _bosses:
		_random = _rng.randi_range(0, 2)
		match _random:
			1:
				boss.face_left()
				boss.fire()
			2:
				boss.face_right()
				boss.fire()

func _phase_check(percentage : float):
	if percentage < 0.333:
		_timer.wait_time = 0.7
	elif percentage < 0.667:
		_timer.wait_time = 0.9

func _start_encounter():
	super._start_encounter()
	_timer.start()

func _end_encounter():
	super._end_encounter()
	_timer.stop()
