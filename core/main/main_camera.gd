class_name MainCamera extends Camera2D

@export var follow_target: CharacterBody2D
var current_level: BaseLevel

@export_category("Lookahead Settings")
@export var lookahead := Vector2(15.0, 15.0)
@export var lookahead_speed := Vector2(5.0, 5.0)

#Call these in SceneLoader to setup level and player
func set_current_level(level: BaseLevel) -> void:
	current_level = level
			
	assert(follow_target != null, "ActiveLevel/Player Node is not found!")
		
func set_current_level_limits() -> void:
	if current_level:
		limit_left = int(current_level.settings.left_top_bounds.x)
		limit_right = int(current_level.settings.right_bottom_bounds.x)
		limit_top = int(current_level.settings.left_top_bounds.y)
		limit_bottom = int(current_level.settings.right_bottom_bounds.y)
	else:
		assert(current_level != null, "Current Level Data not found!")
		return

func snap_to_target(node: Node2D) -> void:
	global_position = node.global_position
#end

#LIFECYCLE METHODS	
func _ready() -> void:
	if !Globals.main_camera:
		Globals.register_main_camera(self)

func _physics_process(delta: float) -> void:
	if not follow_target: 
		return

	# 1. Determine base target
	var desired_target = follow_target.global_position
	
	# 2. Simplified Lookahead Logic
	var move_dir = 0.0
	if follow_target.has_method("get_direction"):
		move_dir = follow_target.get_direction()
	
	if move_dir != 0:
		# Boost lookahead if running
		var is_running = follow_target.fsm.current_state is PlayerRunState if follow_target.get("fsm") else false
		var multiplier = 2.0 if is_running else 1.0
		desired_target.x += move_dir * (lookahead.x * multiplier)
	
	# Vertical lookahead
	var y_velocity := follow_target.velocity.y
	if absf(y_velocity) > 10.0:
		desired_target.y += (y_velocity / 100) * lookahead.y

	# 3. Viewport Constraints
	var view_size = get_viewport_rect().size / zoom
	var half_view = view_size / 2.0
	
	# Ensure the limits don't "cross over" in small levels
	var min_x = min(limit_left + half_view.x, limit_right - half_view.x)
	var max_x = max(limit_left + half_view.x, limit_right - half_view.x)
	var min_y = min(limit_top + half_view.y, limit_bottom - half_view.y)
	var max_y = max(limit_top + half_view.y, limit_bottom - half_view.y)
	
	# Clamp the desired target before lerping
	desired_target.x = clamp(desired_target.x, min_x, max_x)
	desired_target.y = clamp(desired_target.y, min_y, max_y)

	# Smooth Follow
	global_position.x = lerp(global_position.x, desired_target.x, lookahead_speed.x * delta)
	global_position.y = lerp(global_position.y, desired_target.y, lookahead_speed.y * delta)
