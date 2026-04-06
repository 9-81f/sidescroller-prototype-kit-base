extends Node

var spawn_marker_id: StringName = &"EastEntry01"

var active_level: Node = null

var canvas_layer: CanvasLayer = null

var _is_transitioning := false

func change_scene_to(path: String, spawn_id: StringName) -> void:
	if _is_transitioning: return
	
	_is_transitioning = true
	
	_check_tree()
	
	var player_fsm: StateMachineComponent = Globals.player.fsm
	player_fsm.transition_state(EntityEnums.STATE.FREEZED, player_fsm.current_state)
	
	_create_canvas_layer_instance()
	
	var transition_rect := _create_color_rect_instance()
	
	var in_tween := _color_rect_fade_in(transition_rect)
	
	await in_tween.finished
	
	spawn_marker_id = spawn_id
	
	if active_level:
		var current_level: BaseLevel = null
		
		for child in active_level.get_children():
			if child is BaseLevel:
				current_level = child
		
		if current_level:
			current_level.queue_free()
			
		await _setup_next_level(path, spawn_id)
		
		_color_rect_fade_out(transition_rect)		
		
		player_fsm.transition_state(EntityEnums.STATE.IDLE, player_fsm.current_state)
	else:
		push_error("ActiveLevel not found!")	
		
	_is_transitioning = false
		
func _check_tree() -> void:
	if not is_inside_tree():
		await ready
	
	var tree := get_tree()
	active_level = tree.get_first_node_in_group(&"level_container")
	
	if not active_level:
		push_error("SceneLoader: Node in group 'level_container' not found!")
		return
	
func _create_canvas_layer_instance() -> void:
	var new_canvas: CanvasLayer = CanvasLayer.new()
	canvas_layer = new_canvas
	add_child(canvas_layer)
	
func _free_canvas_layer_instance() -> void:
	canvas_layer.queue_free()
	
func _create_color_rect_instance(color: Color = Color.BLACK) -> ColorRect:
	var new_rect: ColorRect = ColorRect.new()
	new_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	new_rect.color = color
	new_rect.color.a = 0.0
	canvas_layer.add_child(new_rect)
	return new_rect
	
func _color_rect_fade_in(rect: ColorRect, duration: float = 0.25) -> Tween:
	var tween := rect.create_tween()
	tween.tween_property(rect, "color:a", 1.0, duration).set_ease(Tween.EASE_OUT)
	return tween
	
func _color_rect_fade_out(rect: ColorRect, duration: float = 0.25) -> void:
	var out_tween := rect.create_tween()
	out_tween.tween_property(rect, "color:a", 0.0, duration).set_ease(Tween.EASE_IN)
	await out_tween.finished
	_free_transition_instances(rect)
	
func _free_transition_instances(rect: ColorRect) -> void:
	rect.queue_free()
	_free_canvas_layer_instance()
	
func _setup_next_level(path: String, marker_id: StringName) -> BaseLevel:
	var next: BaseLevel = load(path).instantiate()
		
	active_level.add_child.call_deferred(next)
	
	await get_tree().process_frame
	
	if Globals.player:
		Globals.player.spawn_setup()
	
		Globals.player.global_position = next.find_child(marker_id).global_position
		
		Globals.main_camera.set_current_level(next)
		Globals.main_camera.set_current_level_limits()
		Globals.main_camera.snap_to_target(Globals.player)
	
	return next
