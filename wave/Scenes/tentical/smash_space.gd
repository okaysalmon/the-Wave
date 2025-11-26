extends Area3D
@export var Active:bool = true
@export var power:float = 50000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if Active:
		var bodies = get_overlapping_bodies()
		for node in bodies:
			if node is RigidBody3D:
				var force_vector:Vector3 = (node.global_position-self.global_position).normalized()
				node.apply_central_force(force_vector * power* delta)

func _on_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		#print("im called")
		var force_vector:Vector3 = (body.global_position-self.global_position).normalized()
		body.apply_central_force(force_vector * power)
	pass # Replace with function body.
