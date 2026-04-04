@abstract
class_name BaseState extends Node

signal set_state(to_state: EntityEnums.STATE, previous_state: BaseState)

@export var key: EntityEnums.STATE = EntityEnums.STATE.IDLE

var fsm: StateMachineComponent = null

func _ready() -> void:	
	if !fsm:
		fsm = get_parent() as StateMachineComponent
	else:
		push_error("Parent State Machine not found!")
		return

func enter() -> void: pass
func exit() -> void: pass
func process(_delta: float) -> void: pass
func physics_process(_delta: float) -> void: pass
func input(_event: InputEvent) -> void: pass
