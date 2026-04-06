class_name PlayerIdleState extends PlayerState

func _ready() -> void:
	register_state_key(EntityEnums.STATE.IDLE)
	super._ready()

func enter() -> void:
	player.movement.stop()
	player.play_animation(EntityEnums.STATE.IDLE)
	
func physics_process(_delta: float) -> void:
	if !player: return
	
	if player.is_on_floor():
		if player.get_direction() != 0:
			set_state.emit(EntityEnums.STATE.WALK, self)
			return
		if player.jump_input():
			set_state.emit(EntityEnums.STATE.JUMP, self)
			return
		if player.crouch_input():
			set_state.emit(EntityEnums.STATE.CROUCH_IDLE, self)
			return
	else:
		set_state.emit(EntityEnums.STATE.FALL, self)
