class_name JumpBufferComponent extends BaseNodeComponent

@export_range(0.0, 1.0, 0.01) var duration: float = 0.1

@onready var _timer: Timer = %Timer

var actor: CharacterBody2D = null

func _ready() -> void:
	if entity and entity is CharacterBody2D:
		actor = entity
	else:
		assert(entity is CharacterBody2D, "JumpBufferComponent: entity must be present and of type CharacterBody2D")
	
	_timer.one_shot = true
	_timer.autostart = false
	_timer.wait_time = duration

func stop() -> void:
	_timer.stop()

func start() -> void:
	_timer.start()
	
func is_buffered() -> bool:
	return !_timer.is_stopped()
