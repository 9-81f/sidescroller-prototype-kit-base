class_name PlayerSlideState extends PlayerState

var _slide_timer := 0.0
var _slide_direction: float

func _ready() -> void:
	register_state_key(EntityEnums.STATE.SLIDE)
	super._ready()

func enter() -> void:
	if not player: return
	
	player.play_animation(EntityEnums.STATE.SLIDE)
	
	_slide_timer = 0.0
	_slide_direction = 1.0 if player.visual_root.scale.x > 0.0 else -1.0
	
	player.velocity.x = _slide_direction * player.movement.settings.slide_force
	player.velocity.y = 0.0
	
func physics_process(delta: float) -> void:
	if !player: return
	
	_slide_timer += delta
	
	var time_left_ratio := 1.0 - (_slide_timer / player.movement.settings.slide_duration)
	player.velocity.x = _slide_direction * player.movement.settings.slide_force * time_left_ratio
	
	if player.is_on_floor():
		if player.is_on_wall():
			player.movement.kill_velocity_x()
			set_state.emit(EntityEnums.STATE.SLIDE_RECOVERY)
			return
			
		if _slide_timer >= player.movement.settings.slide_duration:
			player.movement.kill_velocity_x()
			set_state.emit(EntityEnums.STATE.SLIDE_RECOVERY)
	else:
		set_state.emit(EntityEnums.STATE.FALL, self)

func exit() -> void:
	player.movement.kill_velocity_x()
	
