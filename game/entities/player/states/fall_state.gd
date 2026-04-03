class_name PlayerFallState extends PlayerState

func enter() -> void:
	player.play_animation(EntityEnums.STATE.FALL)
	player.anim_player.speed_scale = 2.0
	
func physics_process(delta: float) -> void:
	if not player: return
	
	var move_dir := player.get_direction()
	var applied_speed := move_dir * player.movement.settings.walk_speed
	player.velocity = player.movement.get_next_velocity(player.velocity, applied_speed, delta)
	player.movement.set_facing_direction(move_dir)
	
	if player.is_on_floor():
		set_state.emit(EntityEnums.STATE.IDLE)

func exit() -> void:
	player.anim_player.speed_scale = 1.0
