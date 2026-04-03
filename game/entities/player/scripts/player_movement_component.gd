class_name PlayerMovementComponent extends MovementComponent

var player: Player = null
var last_facing_direction: EntityEnums.FACING

func _ready() -> void:
	assert(entity is Player and player != null, "Entity is not of type Player!")
	
	if entity and entity is Player:
		player = entity
