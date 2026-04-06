class_name PlayerFreezedState extends PlayerState

func _ready() -> void:
	register_state_key(EntityEnums.STATE.FREEZED)
	super._ready()

func enter() -> void:
	## Uncomment below if player need to change back to idle when body collide with transporter components
	#player.play_animation(EntityEnums.STATE.IDLE)
	player.freeze()
	player.movement.stop()

func exit() -> void:
	player.unfreeze()
