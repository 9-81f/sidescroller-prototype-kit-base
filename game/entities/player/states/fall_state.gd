class_name PlayerFallState extends PlayerState

var was_high_momentum := false
var is_jump_cancelled := false

func _ready() -> void:
	register_state_key(EntityEnums.STATE.FALL)
	super._ready()

func enter() -> void:
	player.play_animation(EntityEnums.STATE.FALL)
	
	player.set_animation_speed_scale(2.0)
	
	if player.fsm.previous_state is PlayerJumpState:
		is_jump_cancelled = (player.fsm.previous_state as PlayerJumpState).is_cancelled
	else:
		is_jump_cancelled = false
	
	
func physics_process(delta: float) -> void:
	if not player: return
	
	if player.jump_input_released():
		is_jump_cancelled = true
	
	var move_dir := player.get_direction()
	
	# Check for coyote time jump speed continuation
	if player.fsm.previous_state is PlayerJumpState:
		was_high_momentum = player.fsm.previous_state.was_running
	elif player.fsm.previous_state is PlayerRunState:
		was_high_momentum = true
	else:
		was_high_momentum = false
		
	var applied_speed := move_dir * (player.movement.settings.run_speed if was_high_momentum else player.movement.settings.walk_speed)
	
	player.velocity = player.movement.get_next_velocity(player.velocity, applied_speed, delta, true, is_jump_cancelled)
	player.movement.set_facing_direction(move_dir)

	if player.jump_input():
		if player.use_coyote_timer():
			set_state.emit(EntityEnums.STATE.JUMP, self)
		else:
			player.use_jump_buffer()
	
	if player.is_on_floor():
		if player.jump_buffer and player.jump_buffer.is_buffered(): 
			player.jump_buffer.stop()
			set_state.emit(EntityEnums.STATE.JUMP, self)
		elif move_dir != 0:
			set_state.emit(EntityEnums.STATE.WALK, self)
		else:
			set_state.emit(EntityEnums.STATE.IDLE, self)

func exit() -> void:
	player.reset_animation_speed_scale()
