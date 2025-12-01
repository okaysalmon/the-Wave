extends RayCast3D
class_name FootPositioner

@export var Right:bool = true
@export var Target: Node3D
@export var Master: Node3D
@export var JumpSpot: Node3D
@export var RestSpot: Node3D
@export var SWIMSpot: Node3D
@export var GroundOffset:float = 0
var curretHeight:float = 0
var StepingUp:bool = false
var stepSpeed:float = 0.2
var FloatAtHeight:float = 1
#var jumping:bool = false
var CurrentState:State = State.STANDING

enum State{
	STANDING,
	WALKING,
	JUMPING,
	SWIMING
}

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if CurrentState == State.JUMPING:
		Target.global_position = JumpSpot.global_position
		if Right:
			global_position = Master.RightFootRCpos.global_position
		else:
			global_position = Master.LeftFootRCpos.global_position
		return
	elif CurrentState == State.STANDING:
		Target.global_position = global_position.lerp(RestSpot.global_position,stepSpeed)
	elif CurrentState == State.SWIMING:
		Target.global_position = SWIMSpot.global_position
	if StepingUp:
		if Right:
			
			global_position = global_position.lerp(Master.RightFootRCpos.global_position,stepSpeed)
		else:
			global_position = global_position.lerp(Master.LeftFootRCpos.global_position,stepSpeed)

	if is_colliding():
		Target.global_position = get_collision_point()+Vector3(0,curretHeight+GroundOffset,0)
		self.global_position = Vector3(global_position.x,get_collision_point().y+FloatAtHeight,global_position.z)
	pass

func _step():
	StepingUp = true
	CurrentState = State.WALKING
	await get_tree().create_timer(0.5).timeout
	StepingUp = false
	Master.stepping = false
	pass
