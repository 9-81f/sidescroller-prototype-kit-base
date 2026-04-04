class_name PlayerFallState extends PlayerState

var was_high_momentum := false

func enter() -> void:
	player.play_animation(EntityEnums.STATE.FALL)
	player.anim_player.speed_scale = 2.0
	
func physics_process(delta: float) -> void:
	if not player: return
	
	var move_dir := player.get_direction()
	
	# Check for coyote time jump speed continuation
	if player.fsm.previous_state is PlayerJumpState:
		was_high_momentum = player.fsm.previous_state.was_running
	elif player.fsm.previous_state is PlayerRunState:
		was_high_momentum = true
	else:
		was_high_momentum = false
		
	var applied_speed := move_dir * (player.movement.settings.run_speed if was_high_momentum else player.movement.settings.walk_speed)
	
	player.velocity = player.movement.get_next_velocity(player.velocity, applied_speed, delta)
	player.movement.set_facing_direction(move_dir)

	if player.coyote_jump_input():
		player.coyote_timer.stop()
		set_state.emit(EntityEnums.STATE.JUMP, self)
	
	if player.is_on_floor():
		if move_dir != 0:
			set_state.emit(EntityEnums.STATE.WALK, self)
		else:
			set_state.emit(EntityEnums.STATE.IDLE, self)

func exit() -> void:
	player.anim_player.speed_scale = 1.0
