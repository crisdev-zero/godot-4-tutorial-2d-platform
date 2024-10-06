class_name Hero extends Character

@export var _has_sword : bool
@onready var _attack_input_buffer : Timer = $HitBox/InputBuffer
@warning_ignore("unused_private_class_variable")
@onready var _cooldown : Timer = $HitBox/Cooldown
var _sword : RigidBody2D
@export var _bonus_damage : int

func attack():
	_wants_to_attack = true
	_attack_input_buffer.start()
	await _attack_input_buffer.timeout
	_wants_to_attack = false

func can_equip_sword() -> bool:
	return not _has_sword && not _is_dead

func equip_sword(sword : RigidBody2D):
	_sword = sword
	_has_sword = true

func drop_sword():
	if not _has_sword:
		return
	_has_sword = false
	_sword.be_dropped(global_position)
	_sword = null

func _air_physics(delta : float):
	if _is_attacking && velocity.y > 0:
		velocity.y = 0
	else:
		super._air_physics(delta)

func _die():
	if _has_sword:
		drop_sword()
	super._die()
	
func _on_hit_box_area_entered(area : Area2D, _ignore : int = 0):
	if _is_dead || not _is_attacking:
		return
	if not is_on_floor() && area.global_position.y > global_position.y:
		velocity.y = _jump_velocity / 2
	super._on_hit_box_area_entered(area, _bonus_damage)
	_bonus_damage = 0
