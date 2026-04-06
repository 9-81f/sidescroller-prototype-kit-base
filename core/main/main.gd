class_name Main extends Node

@export var starting_level: BaseLevelTransporter

func _ready() -> void:
	if starting_level:
		SceneLoader.change_scene_to(starting_level.target_level, starting_level.spawn_marker_id)
