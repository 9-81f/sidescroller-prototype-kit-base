class_name PlayerWalkState extends PlayerState

func enter() -> void:
	player.play_animation(EntityEnums.STATE.WALK)
	
func physics_process(delta: float) -> void:
	if not player: return
	
	var move_dir := player.get_direction()
	
	var applied_speed := move_dir * player.movement.settings.walk_speed
	
	player.velocity = player.movement.get_next_velocity(player.velocity, applied_speed, delta)
	player.movement.set_facing_direction(move_dir)
	
	if player.is_on_floor():
		if player.get_direction() == 0.0:
			set_state.emit(EntityEnums.STATE.IDLE, self)
			return
		if player.run_input():
			set_state.emit(EntityEnums.STATE.RUN, self)
			return
		if player.crouch_input():
			set_state.emit(EntityEnums.STATE.CROUCH_IDLE, self)
			return
		if player.jump_input():
			set_state.emit(EntityEnums.STATE.JUMP, self)
			return
	
