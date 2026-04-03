class_name PlayerCrouchIdleState extends PlayerState

func enter() -> void:
	player.movement.stop()
	player.play_animation(EntityEnums.STATE.CROUCH_IDLE)
	
func physics_process(_delta: float) -> void:
	if not player: return
	
	if player.is_on_floor():
		if player.get_direction() != 0.0:
			set_state.emit(EntityEnums.STATE.CROUCH_WALK, self)
			return
		if player.stand_input():
			set_state.emit(EntityEnums.STATE.IDLE, self)
			return
