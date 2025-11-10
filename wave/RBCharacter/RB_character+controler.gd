extends RigidBody3D

@export var camera:Node3D = defaltCame

@onready var defaltCame = $CamSwivle
var acceleration:float = 5.0
var accelerationMultiplier:float = 1.5
var jumpVelocity:float = 10.0
#var _pid = Pid3D.new(1.0,0.1,1.0)
const SPEED:float = 15.0
const MAXSPEED:float = 25
var stopSpeed:float = 0.5
var grounded:bool = false
var moveInput:Vector2
var velocity:Vector3
var prev_velocity:Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if camera == null:
		camera = defaltCame
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#print(linear_velocity)
	## need to ad a check in int_forc where if new velovity is more then a 90 deg dif or even 120, then set linerar velocity to 0,0,0
	prev_velocity = velocity
	grounded = _is_grounded()
	if grounded:
		moveInput = Input.get_vector("move_left","move_right","move_down","move_up")
		var dir = Vector3.ZERO
		dir += moveInput.x*camera.global_basis.x
		dir -= moveInput.y*camera.global_basis.z
		##prevent Y Push
		dir = Vector3(dir.x,0,dir.z)
		velocity = lerp(velocity,dir*SPEED,acceleration* accelerationMultiplier*delta)
		apply_central_force(velocity)
	

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if state.linear_velocity.length()>MAXSPEED and grounded:
		state.linear_velocity = state.linear_velocity.normalized()*MAXSPEED
	if moveInput.length() <0.2 and grounded:
		state.linear_velocity.x = lerp(state.linear_velocity.x, 0.0,stopSpeed)
		state.linear_velocity.z = lerp(state.linear_velocity.z, 0.0,stopSpeed)

func _is_grounded()->bool:
	%GroundRayCast.force_raycast_update()
	return %GroundRayCast.is_colliding()
