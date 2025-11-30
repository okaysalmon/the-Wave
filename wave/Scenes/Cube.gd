extends FloatingRigidBody3d

@export var brokenShipScene:PackedScene = load("res://blender/BrokenrAFTpARTS/broken_boat.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_physics_float(delta)
	pass

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	_integrate_float(state)


func _on_body_entered(body: Node) -> void:
	#print("this was Called")
	if body.is_in_group("CrackenTent"):
		var MainNode = body.get_parent().get_parent().get_parent().get_parent()
		if MainNode.state == MainNode.STATES.Attacking:
			var Broken = brokenShipScene.instantiate()
			Broken.position = self.global_position
			get_parent().add_child(Broken)
			self.queue_free()
			
			
	pass # Replace with function body.
