extends Node3D

@onready var boat:Node3D = $"../RigidBody3D"
@onready var SmashSpaces:Array = [$Armature/Skeleton3D/BoneAttachment3D7/SmashSpace, $Armature/Skeleton3D/BoneAttachment3D8/SmashSpace, $Armature/Skeleton3D/BoneAttachment3D9/SmashSpace, $Armature/Skeleton3D/BoneAttachment3D10/SmashSpace, $Armature/Skeleton3D/BoneAttachment3D11/SmashSpace, $Armature/Skeleton3D/BoneAttachment3D12/SmashSpace, $Armature/Skeleton3D/BoneAttachment3D13/SmashSpace, $Armature/Skeleton3D/BoneAttachment3D14/SmashSpace, $Armature/Skeleton3D/BoneAttachment3D15/SmashSpace]

var target:Node3D
var speed:float = 10

var state:STATES = STATES.Summond:
	set(newVal):
		state = newVal
		if state == STATES.Hurt:
			_was_hurt()
		elif state == STATES.Locking:
			select_target()
		elif state == STATES.Attacking:
			_attacking()

enum STATES{Summond,Locking,Attacking,Hurt}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Armature/pole/AnimationPlayer.play("Sway")
	var tween:Tween = create_tween()
	tween.tween_property(self,"position",Vector3(self.global_position.x,-4,self.global_position.y),5)
	await get_tree().create_timer(8).timeout
	state = STATES.Locking
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == STATES.Locking and target !=null and is_instance_valid(target):
		look_at(Vector3(target.global_position.x,self.global_position.y,target.global_position.z),Vector3.UP)
		move_to_target(delta)
	elif state == STATES.Locking:
		select_target()
	pass

func _was_hurt():
	$Armature/pole/AnimationPlayer.play("Pain")
	for spaces in  SmashSpaces:
		spaces.Active = false
	var tween:Tween = create_tween()
	tween.tween_property(self,"position",Vector3(self.global_position.x,-30,self.global_position.y),6.0)
	await $Armature/pole/AnimationPlayer.animation_finished
	queue_free()

func _attacking() ->void:
	for spaces in  SmashSpaces:
		spaces.Active = true
	$Armature/pole/AnimationPlayer.play("hit")
	await $Armature/pole/AnimationPlayer.animation_finished
	state = STATES.Locking
	

func turn_off_attack():
	for spaces in  SmashSpaces:
		spaces.Active = false


func select_target():
	target = get_tree().get_nodes_in_group("CrackenTarget").pick_random()
	
func move_to_target(delta:float):
	if target !=null and is_instance_valid(target):
		global_position = global_position.move_toward(Vector3(target.global_position.x,global_position.y,target.global_position.z), delta * speed)
		if global_position.distance_to(target.global_position) < 25:
			state = STATES.Attacking
