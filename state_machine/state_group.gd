@tool
class_name StateGroup
extends Node

@export var default_state: State:
	set(v):
		default_state = v
		update_configuration_warnings()
	
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := []
	if !default_state:
		warnings.append("StateGroup doesn't have default State set")
	if get_children().size() == 0:
		warnings.append("StateGroup has no states")
	for state: Node in get_children():
		if state is not State:
			warnings.append("%s is not a State" % state.name)
	return warnings
