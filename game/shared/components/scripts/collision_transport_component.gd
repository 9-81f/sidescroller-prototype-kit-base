class_name CollisionTransportComponent extends Area2D

@export var transporter: BaseLevelTransporter

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"actor"):
		SceneLoader.change_scene_to(transporter.target_level, transporter.spawn_marker_id)
