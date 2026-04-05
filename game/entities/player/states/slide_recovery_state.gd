class_name PlayerSlideRecoveryState extends PlayerState

func _ready() -> void:
	register_state_key(EntityEnums.STATE.SLIDE_RECOVERY)
	super._ready()

func enter() -> void:
	if player.is_on_floor():
		player.set_animation_speed_scale(4.0)
		player.play_animation(EntityEnums.STATE.SLIDE_RECOVERY)
		player.movement.stop()
		await player.anim_player.animation_finished
		set_state.emit(EntityEnums.STATE.IDLE)
	else:
		set_state.emit(EntityEnums.STATE.FALL)
	
func exit() -> void:
	player.reset_animation_speed_scale()
