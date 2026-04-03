class_name PlayerFreezedState extends PlayerState

func enter() -> void:
	player.play_animation(EntityEnums.STATE.IDLE)
	player.freeze()
	player.movement.stop()

func exit() -> void:
	player.unfreeze()
