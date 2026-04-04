class_name CoyoteTimeComponent extends BaseNodeComponent

var actor: CharacterBody2D = null

@export_range(0.0, 1.0, 0.01) var duration: float = 0.1

@onready var _timer: Timer = %Timer

var _was_on_floor: bool = false

func _ready() -> void:
	if entity and entity is CharacterBody2D:
		actor = entity
	else:
		assert(entity is CharacterBody2D, "CoyoteTimeComponent: entity must be present and of type CharacterBody2D")
	
	_timer.one_shot = true
	_timer.autostart = false
	_timer.wait_time = duration
	
func stop() -> void:
	_timer.stop()

func start() -> void:
	_timer.start()
	
func allow_jump() -> bool:
	return !_timer.is_stopped()
	
func _physics_process(_delta: float) -> void:	
	if !actor: return
	
	if _was_on_floor and !actor.is_on_floor() and actor.velocity.y >= 0.0:
		start()
	
	if actor.is_on_floor():
		stop()
		
	_was_on_floor = actor.is_on_floor()
		
