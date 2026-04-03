class_name PlayerSlideRecoveryState extends PlayerState

func enter() -> void:
	player.anim_player.speed_scale = 2.0
	player.play_animation(EntityEnums.STATE.SLIDE_RECOVERY)
	player.movement.stop()
	await player.anim_player.animation_finished
	set_state.emit(EntityEnums.STATE.IDLE)
	
func exit() -> void:
	player.anim_player.speed_scale = 1.0
