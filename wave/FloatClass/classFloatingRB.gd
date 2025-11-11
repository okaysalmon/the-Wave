extends RigidBody3D
class_name FloatingRigidBody3d

#_____________________Floats_______________________#
@export var float_force :float = 1.0
@export var water_drag :float = 0.05
@export var water_angular_drag := 0.05
@export var float_offset:float = 0.0
@export var floatiesnode:Node3D

@onready var floaties:Array = floatiesnode.get_children()
@onready var gravity :float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var Water:Node3D = get_tree().get_first_node_in_group("water")

const water_height :float= 0.0
var submerged :bool =false
#_____________________end Floats_______________________#

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_physics_float(delta)
	pass

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	_integrate_float(state)


func _physics_float(delta:float) -> void:
	if Water!=null:
		submerged = false
		for f in floaties:
			var depth = - global_position.y + float_offset + $"../OutsetOcean".get_wave_height_at(f.global_position.x,global_position.z)
			if depth >0:
				submerged = true
				apply_force(Vector3.UP* float_force * gravity * depth, f.global_position - global_position)
			#print(depth)

func _integrate_float(state: PhysicsDirectBodyState3D)-> void:
	if Water!=null:
		if submerged:
			state.linear_velocity *= 1 - water_drag
			state.angular_velocity *= 1- water_angular_drag
