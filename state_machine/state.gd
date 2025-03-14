@tool
class_name State
extends Node

signal state_entered()
signal state_process(delta:float)
signal state_physics_process(delta:float)
signal state_exited()

@export var enable_process:=false
@export var enable_physics_process:=false

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func enter()->void:
	if enable_process:
		set_process(true)
	if enable_physics_process:
		set_physics_process(true)
	state_entered.emit()
	
func exit()->void:
	set_process(false)
	set_physics_process(false)
	state_exited.emit()

func _process(delta: float) -> void:
	state_process.emit(delta)
	
func _physics_process(delta: float) -> void:
	state_physics_process.emit(delta)
