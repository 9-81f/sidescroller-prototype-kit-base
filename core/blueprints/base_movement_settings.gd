class_name BaseMovementSettings extends Resource

@export_group("Horizontal Movement")
@export_range(5.0, 500.0) var walk_speed := 80.0
@export_range(100.0, 900.0) var run_speed := 100.0
@export_range(100.0, 5000.0) var acceleration := 2000.0
@export_range(100.0, 5000.0) var friction := 1500.0

@export_group("Vertical Movement")
@export_range(-1000.0, 0.0) var jump_velocity := -45.0
@export var max_fall_speed := 800.0
@export_range(100.0, 5000.0) var air_acceleration := 2500.0
@export_range(100.0, 5000.0) var air_friction := 200.0
@export_range(1, 20) var gravity_multiplier: int

@export_group("Abilities")
@export_range(100.0, 2000.0) var slide_force := 800.0
@export var slide_duration := 0.3

@export_group("Movement Toggle")
@export var can_run: bool = true
@export var can_jump: bool = true
@export var can_crouch: bool = true
@export var can_slide: bool = true

var gravity: float : 
	get: 
		return ProjectSettings.get_setting("physics/2d/default_gravity") * gravity_multiplier
var applied_speed: float
