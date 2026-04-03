class_name PlayerRunState extends PlayerState

func enter() -> void:
	player.play_animation(EntityEnums.STATE.RUN)

func physics_process(delta: float) -> void:
	if not player: return
	
	var move_dir := player.get_direction()
	
	var applied_speed := move_dir * player.movement.settings.run_speed
	
	player.velocity = player.movement.get_next_velocity(player.velocity, applied_speed, delta)
	player.movement.set_facing_direction(move_dir)
	
	if player.is_on_floor():
		if player.get_direction() == 0.0:
			set_state.emit(EntityEnums.STATE.IDLE, self)
			return
		if player.run_input(true):
			set_state.emit(EntityEnums.STATE.WALK, self)
			return
		if player.slide_input():
			set_state.emit(EntityEnums.STATE.SLIDE, self)
			return
		if player.crouch_input():
			set_state.emit(EntityEnums.STATE.CROUCH_IDLE, self)
			return
		if player.jump_input():
			set_state.emit(EntityEnums.STATE.JUMP, self)
			return
	else:
		set_state.emit(EntityEnums.STATE.FALL, self)
