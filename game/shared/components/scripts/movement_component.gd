class_name MovementComponent extends BaseNode2DComponent

signal facing(direction: EntityEnums.FACING)

var body: CharacterBody2D
@export var settings: BaseMovementSettings
@export var default_facing: EntityEnums.FACING = EntityEnums.FACING.RIGHT

var last_facing: EntityEnums.FACING

func _ready() -> void:
	assert(entity != null, "Movement Component: Entity not found!")
	if entity is CharacterBody2D:
		body = entity
	else:
		push_error("Movement Component: Entity must be of type CharacterBody2D!")
	
	if default_facing:
		last_facing = default_facing
		
func stop() -> void:
	body.velocity = Vector2.ZERO

func kill_velocity_x() -> void:
	body.velocity.x = 0.0
		
func get_next_velocity(current_velocity: Vector2, target_x: float, delta: float, is_jumping: bool = false, is_jump_cancelled: bool = false) -> Vector2:
	var out := current_velocity
	
	var applied_accel: float = 0.0
	var x_accel := settings.acceleration if target_x != 0.0 else settings.friction
	var y_accel := settings.air_acceleration if target_x != 0.0 else settings.air_friction
	
	if body.is_on_floor():
		applied_accel = x_accel
	else:
		applied_accel = y_accel
	
	out.x = move_toward(out.x, target_x, applied_accel * delta)
	
	var applied_gravity := settings.gravity
	
	if settings.can_variable_jump_height and is_jumping and is_jump_cancelled and out.y < 0.0:
		applied_gravity *= settings.mid_jump_cancel_weight
	
	if not body.is_on_floor():
		out.y += applied_gravity * delta
		out.y = min(out.y, settings.max_fall_speed)
	
	return out
		
func set_facing_direction(move_dir: float) -> void:
	if move_dir > 0:
		last_facing = EntityEnums.FACING.RIGHT
		facing.emit(last_facing)
	elif move_dir < 0:
		last_facing = EntityEnums.FACING.LEFT
		facing.emit(last_facing)
