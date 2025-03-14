extends Node2D

@export var path: PathFollow2D
@onready var sm: StateMachine = $StateMachine
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var idle_timer: Timer = $IdleTimer
@onready var invulnerability_timer: Timer = $InvulnerabilityTimer
@onready var flying_timer: Timer = $FlyingTimer

var click_count := 0

func _ready() -> void:
	idle_timer.timeout.connect(func()->void:sm.enter_state("Movement", "Flying")) 
	invulnerability_timer.timeout.connect(func()->void:sm.enter_state("Vulnerability", "Vulnerable"))
	flying_timer.timeout.connect(func()->void:sm.enter_state("Movement", "Idle"))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		click_count += 1
		sm.enter_state("Vulnerability", "Invulnerable")
		
	if click_count == 1:
		sm.enter_state("Health", "Hurt")
		
	if click_count == 2:
		sm.enter_state("Health", "Critical")
		
	if click_count > 2:
		sm.enter_state("Health", "Dead")

#MOVEMENT
func _on_flying_state_process(delta: float) -> void:
	path.progress += 300 * delta

func _on_idle_state_entered() -> void:
	idle_timer.start()
	
func _on_idle_state_exited() -> void:
	idle_timer.stop()

func _on_flying_state_entered() -> void:
	flying_timer.start()
	
func _on_flying_state_exited() -> void:
	flying_timer.stop()
	
#HEALTH
func _on_healthy_state_entered() -> void:
	sprite_2d.modulate = Color.GREEN

func _on_hurt_state_entered() -> void:
	sprite_2d.modulate = Color.ORANGE

func _on_critical_state_entered() -> void:
	sprite_2d.modulate = Color.RED

func _on_dead_state_entered() -> void:
	sprite_2d.modulate = Color.BLACK
	sm.enter_state("Movement", "Dead")
	sm.enter_state("Vulnerability", "Dead")
	
# VULNERABILITY
func _on_vulnerable_state_entered() -> void:
	set_process_input(true)
	
func _on_invulnerable_state_entered() -> void:
	set_process_input(false)
	invulnerability_timer.start()

func _on_invulnerable_state_process(delta: float) -> void:
	self.rotation += 500*delta

func _on_invulnerable_state_exited() -> void:
	rotation = 0
	invulnerability_timer.stop()
