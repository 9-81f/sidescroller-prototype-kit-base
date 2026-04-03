class_name PlayerFallState extends PlayerState

func enter() -> void:
	player.play_animation(EntityEnums.STATE.FALL)
	player.anim_player.speed_scale = 2.0
	
func physics_process(delta: float) -> void:
	if not player: return
	
	var move_dir := player.get_direction()
	
	var was_high_momentum: bool = false
	if player.fsm.previous_state is PlayerJumpState:
		was_high_momentum = (player.fsm.previous_state as PlayerJumpState).was_running
		
	var applied_speed := move_dir * (player.movement.settings.run_speed if was_high_momentum else player.movement.settings.walk_speed)
	
	player.velocity = player.movement.get_next_velocity(player.velocity, applied_speed, delta)
	player.movement.set_facing_direction(move_dir)
	
	if player.is_on_floor():
		if move_dir != 0:
			set_state.emit(EntityEnums.STATE.WALK)
		else:
			set_state.emit(EntityEnums.STATE.IDLE)

func exit() -> void:
	player.anim_player.speed_scale = 1.0
