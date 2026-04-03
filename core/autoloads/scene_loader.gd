extends Node

var spawn_marker_id: StringName = &"EastEntry01"

var active_level: Node = null

func change_scene_to(path: String, spawn_id: StringName) -> void:
	await get_tree().process_frame
	
	var player_fsm: StateMachineComponent = Globals.player.fsm
	player_fsm.transition_state(EntityEnums.STATE.FREEZED)
	
	spawn_marker_id = spawn_id
	
	active_level = get_tree().root.get_node("/root/Main/ActiveLevel")
	
	## NOTE: Future updates, add level transition here
	
	if active_level:
		var current_level: BaseLevel = null
		
		for child in active_level.get_children():
			if child is BaseLevel:
				current_level = child
		
		if current_level:
			current_level.queue_free()
			
		await _setup_next_level(path, spawn_id)
		
		player_fsm.transition_state(EntityEnums.STATE.IDLE)
		
		#NOTE: End transition here
	else:
		push_error("ActiveLevel not found!")
	
func _setup_next_level(path: String, marker_id: StringName) -> BaseLevel:
	var next: BaseLevel = load(path).instantiate()
		
	active_level.add_child.call_deferred(next)
	
	await get_tree().process_frame
	
	Globals.player.global_position = next.find_child(marker_id).global_position
	
	Globals.main_camera.set_current_level(next)
	Globals.main_camera.set_current_level_limits()
	Globals.main_camera.snap_to_target(Globals.player)
	
	return next
