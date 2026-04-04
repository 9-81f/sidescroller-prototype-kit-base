class_name StateMachineComponent extends BaseNodeComponent

@export var _default_state: BaseState
var _states: Dictionary[EntityEnums.STATE, BaseState] = {}
var current_state: BaseState
var previous_state: BaseState

# PUBLIC METHODS
func reset_state() -> void:
	if current_state:
		current_state.exit()
		previous_state = current_state
	current_state = _default_state
	current_state.enter()

func transition_state(new_state_enum: EntityEnums.STATE, prev_state: BaseState = null) -> void:
	_on_set_state(new_state_enum, prev_state)

# PRIVATE METHODS
func _ready() -> void:	
	if get_child_count() > 0:
		for state in get_children():
			if state is BaseState:
				state.set_state.connect(_on_set_state)
				_states[state.key] = state
	else:
		push_error("Min. 1 child state node under StateMachine")

	if entity:
		if not entity.is_node_ready():
			await entity.ready

	if _default_state:
		_default_state.enter()
		current_state = _default_state
	
func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_process(delta)
		
func _input(event: InputEvent) -> void:
	if current_state:
		current_state.input(event)

func _on_set_state(new_state_enum: EntityEnums.STATE, prev_state: BaseState = null) -> void:
		var new_state_canditate: BaseState = _states[new_state_enum]
		
		if new_state_canditate:
			if current_state != new_state_canditate:
				current_state.exit()
				previous_state = prev_state if prev_state else current_state
				current_state = new_state_canditate
				current_state.enter()
		else:
			push_error("Invalid new state candidate! Check if state is registered.")
			return
