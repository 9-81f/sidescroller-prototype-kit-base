class_name PlayerJumpState extends PlayerState

var was_running: bool = false

func enter() -> void:
	var prev = player.fsm.previous_state
	
	player.play_animation(EntityEnums.STATE.JUMP)
	player.anim_player.speed_scale = 2.0
	player.velocity.y = player.movement.settings.jump_velocity	
	
	var came_from_run = prev is PlayerRunState
	var came_from_high_momentum_fall = prev is PlayerFallState and prev.was_high_momentum
	
	was_running = came_from_run or came_from_high_momentum_fall
	
func physics_process(delta: float) -> void:
	if not player: return
	
	var move_dir := player.get_direction()
	var applied_speed = move_dir * (player.movement.settings.run_speed if was_running else player.movement.settings.walk_speed)
	player.velocity = player.movement.get_next_velocity(player.velocity, applied_speed, delta)
	player.movement.set_facing_direction(move_dir)
	
	if player.velocity.y < 0.0 or player.is_on_ceiling():
		set_state.emit(EntityEnums.STATE.FALL, self)
		
func exit() -> void:
	player.anim_player.speed_scale = 1.0
