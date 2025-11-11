extends Camera3D

@onready var rayCast:RayCast3D = $RayCast3D

var mousePos : Vector2
var mousedOver : Node3D
var mousedOverNormals :Vector3
var mousedOverCollisionPoint:Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mousePos = get_viewport().get_mouse_position()
	rayCast.target_position = project_local_ray_normal(mousePos) * 2000
	rayCast.force_raycast_update()
	if rayCast.is_colliding():
		mousedOver = rayCast.get_collider().get_parent()
		mousedOverNormals = rayCast.get_collision_normal()
		mousedOverCollisionPoint = rayCast.get_collision_point()
	else:
		mousedOver = null
		mousedOverNormals = Vector3.ZERO
		mousedOverCollisionPoint = Vector3.ZERO
	pass

func _get_mouse_racast_collision()->Node3D:
	mousePos = get_viewport().get_mouse_position()
	rayCast.target_position = project_local_ray_normal(mousePos) * 2000
	rayCast.force_raycast_update()
	return rayCast.get_collider().get_parent()
	
	
