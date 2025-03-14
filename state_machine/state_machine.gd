@tool
class_name StateMachine
extends Node

signal state_changed

var active_states: Dictionary[String, State] = {}

func _ready() -> void:
	if not Engine.is_editor_hint():
		for group: StateGroup in get_children():
			call_deferred("enter_state", group.name, group.default_state.name)
			
func _get_configuration_warnings() -> PackedStringArray:
	var warnings:=[]
	if get_children().size() == 0:
		warnings.append("StateMachine has no StateGroups")
	for state: Node in get_children():
		if state is not StateGroup:
			warnings.append("%s is not a StateGroup" % state.name)
	return warnings

func enter_state(group_name: String, state_name: String = "")->void:
	if active_states.has(group_name):
		var old_state:=active_states[group_name]
		if old_state.name == state_name:
			return
		active_states.erase(group_name)
		old_state.exit()
	
	var group: StateGroup = get_node(group_name)
	assert(group, "StateGroup: %s doesn't exist in StateMachine: %s" % [group_name, self.name])
	var new_state: State = group.get_node(state_name) if state_name else group.default_state
	assert(group, "State: %s doesn't exist in StateGroup: %s" % [new_state.name, group.name])
	active_states[group_name] = new_state
	new_state.enter()
	state_changed.emit()
