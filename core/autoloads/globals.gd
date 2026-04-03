extends Node

var player: CharacterBody2D = null
var main_camera: MainCamera = null

func register_player(node: Player) -> void:
	player = node

func register_main_camera(camera: MainCamera) -> void:
	main_camera = camera
