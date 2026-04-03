class_name PlayerState extends BaseState

var player: Player = null

func _ready() -> void:
	super._ready()
	
	var entity := fsm.entity
	
	assert(entity is Player, "PlayerState: Player State's State Machine Entity must be of type Player!")
	player = entity
