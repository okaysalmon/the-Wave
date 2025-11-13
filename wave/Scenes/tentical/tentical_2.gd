extends Node3D

@onready var boat:Node3D = $"../RigidBody3D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Armature/pole/AnimationPlayer.play("Sway")
	var tween:Tween = create_tween()
	tween.tween_property(self,"position",Vector3(-10.0,-19.0,-4.0),3.0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(Vector3(boat.global_position.x,self.global_position.y,boat.global_position.z))
	pass
