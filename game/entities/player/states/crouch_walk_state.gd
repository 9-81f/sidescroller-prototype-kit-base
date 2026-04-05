class_name PlayerCrouchWalkState extends PlayerState

func _ready() -> void:
	register_state_key(EntityEnums.STATE.CROUCH_WALK)
	super._ready()

func enter() -> void:
	player.play_animation(EntityEnums.STATE.CROUCH_WALK)

func physics_process(delta: float) -> void:
	if not player: return
	
	var move_dir := player.get_direction()
	
	var applied_speed := move_dir * player.movement.settings.walk_speed
	
	player.velocity = player.movement.get_next_velocity(player.velocity, applied_speed, delta)
	player.movement.set_facing_direction(move_dir)
	
	if player.is_on_floor():
		if player.get_direction() == 0.0:
			set_state.emit(EntityEnums.STATE.CROUCH_IDLE, self)
			return
		if player.stand_input():
			set_state.emit(EntityEnums.STATE.IDLE, self)
			return
		if player.run_input():
			set_state.emit(EntityEnums.STATE.RUN, self)
			return
