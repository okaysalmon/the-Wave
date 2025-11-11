extends FloatingRigidBody3d



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_physics_float(delta)
	pass

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	_integrate_float(state)
