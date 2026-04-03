class_name Player extends CharacterBody2D

#COMPONENTS
@onready var fsm: StateMachineComponent = %PlayerStateMachineComponent
@onready var movement: MovementComponent = %PlayerMovementComponent
var is_freezed: bool = false

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var visual_root: Node2D = $VisualComponent
@onready var sprite: Sprite2D = $VisualComponent/Sprite2D

## PUBLIC METHODS
func get_direction() -> float:
	return Input.get_axis("ui_left", "ui_right")

func stand_input() -> float:
	return Input.is_action_just_pressed("ui_up")
	
func run_input(is_released: bool = false) -> bool:
	return (Input.is_action_pressed("shift") if !is_released else Input.is_action_just_released("shift")) and movement.settings.can_run
	
func jump_input() -> bool:
	return Input.is_action_just_pressed("ui_up") and movement.settings.can_jump

func crouch_input() -> bool:
	return Input.is_action_just_pressed("ui_down") and movement.settings.can_crouch
	
func slide_input() -> bool:
	return Input.is_action_just_pressed("ui_down") and movement.settings.can_slide
	
func freeze() -> void:
	is_freezed = true
	
func unfreeze() -> void:
	is_freezed = false

func play_animation(state: EntityEnums.STATE) -> void:
	match state:
		EntityEnums.STATE.IDLE: anim_player.play("idle")
		EntityEnums.STATE.WALK: anim_player.play("walk")
		EntityEnums.STATE.RUN: anim_player.play("run")
		EntityEnums.STATE.JUMP: anim_player.play("jump")
		EntityEnums.STATE.FALL: anim_player.play("fall")
		EntityEnums.STATE.CROUCH_IDLE: anim_player.play("crouch_idle")
		EntityEnums.STATE.CROUCH_WALK: anim_player.play("crouch_walk")
		EntityEnums.STATE.SLIDE: anim_player.play("slide")
		EntityEnums.STATE.SLIDE_RECOVERY: anim_player.play("slide_recovery")
		
func change_collision_lane(layer_num: int = 2, activate: bool = true) -> void:
	set_collision_layer_value(layer_num, activate)
	set_collision_mask_value(layer_num, activate)
	
# LIFECYCLE METHODS
func _ready() -> void:
	if !Globals.player:
		Globals.register_player(self)
	
	if movement:
		movement.facing.connect(_on_facing)
		
func _physics_process(_delta: float) -> void:
	if is_freezed: return
	move_and_slide()
	
func _on_facing(direction: EntityEnums.FACING) -> void:
	visual_root.scale.x = 1.0 if direction == EntityEnums.FACING.RIGHT else -1.0
