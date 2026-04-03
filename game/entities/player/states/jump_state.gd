class_name PlayerJumpState extends PlayerState

func enter() -> void:
	player.play_animation(EntityEnums.STATE.JUMP)
	player.anim_player.speed_scale = 2.0
	player.velocity.y = player.movement.settings.jump_velocity
	
func physics_process(delta: float) -> void:
	if not player: return
	
	var move_dir := player.get_direction()
	var applied_speed := move_dir * (player.movement.settings.run_speed if player.fsm.previous_state is PlayerRunState else player.movement.settings.walk_speed)
	player.velocity = player.movement.get_next_velocity(player.velocity, applied_speed, delta)
	player.movement.set_facing_direction(move_dir)
	
	if player.velocity.y < 0.0:
		set_state.emit(EntityEnums.STATE.FALL, self)
		
func exit() -> void:
	player.anim_player.speed_scale = 1.0
