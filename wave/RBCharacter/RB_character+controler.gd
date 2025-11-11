extends FloatingRigidBody3d

@export var camera:Node3D = defaltCame

@onready var defaltCame = $CamSwivle
var acceleration:float = 15.0
var accelerationMultiplier:float = 1.5
var jumpVelocity:float = 40.0
#var _pid = Pid3D.new(1.0,0.1,1.0)
const SPEED:float = 15.0
const MAXSPEED:float = 25
var stopSpeed:float = 0.1
var grounded:bool = false
var moveInput:Vector2
var velocity:Vector3
var prev_velocity:Vector3
var landCoolDownOnJumpTime:float = 0.2
var landCoolDownOnJump:bool =false:
	set(newVal):
		if newVal:
			landCoolDownOnJump = true
			await get_tree().create_timer(landCoolDownOnJumpTime).timeout
			landCoolDownOnJump = false
		else:
			landCoolDownOnJump=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if camera == null:
		camera = defaltCame
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_physics_float(delta)
	#print(linear_velocity)
	## need to ad a check in int_forc where if new velovity is more then a 90 deg dif or even 120, then set linerar velocity to 0,0,0
	prev_velocity = velocity
	grounded = _is_grounded()
	if grounded:
		moveInput = Input.get_vector("move_left","move_right","move_down","move_up")
		var dir = Vector3.ZERO
		dir += moveInput.x*camera.global_basis.x
		dir -= moveInput.y*camera.global_basis.z
		##prevent Y infuance form camera
		dir = Vector3(dir.x,0,dir.z)
		var goundNormals:Vector3 = %GroundRayCast.get_collision_normal()
		dir = dir.slide(goundNormals.normalized())
		#print("pre " +str(velocity))
		velocity = lerp(velocity,dir*SPEED*mass,acceleration* accelerationMultiplier*delta)
		#print(velocity)
		apply_central_force(velocity)
		#print(goundNormals)
		if !landCoolDownOnJump and Input.is_action_just_pressed("move_jump"):
			landCoolDownOnJump = true
			grounded = false
			apply_central_force(Vector3.UP*mass*gravity*gravity_scale*jumpVelocity)
		if goundNormals.y <=0.95:
			#print("im multiplying and loosing control")
			apply_central_force(-goundNormals*gravity)
			var gravRist = Vector3(0,goundNormals.y*mass*gravity/2,0)
			apply_central_force(gravRist)
	if submerged:
		if !landCoolDownOnJump and Input.is_action_just_pressed("move_jump"):
			landCoolDownOnJump = true
			grounded = false
			apply_central_force(Vector3.UP*mass*gravity*gravity_scale*jumpVelocity*1.2)
		moveInput = Input.get_vector("move_left","move_right","move_down","move_up")
		var dir = Vector3.ZERO
		dir += moveInput.x*camera.global_basis.x
		dir -= moveInput.y*camera.global_basis.z
		##prevent Y infuance form camera
		dir = Vector3(dir.x,0,dir.z)
		var goundNormals:Vector3 = %GroundRayCast.get_collision_normal()
		dir = dir.slide(goundNormals.normalized())
		#print("pre " +str(velocity))
		velocity = lerp(velocity,dir*SPEED*mass,acceleration* accelerationMultiplier*delta)
		#print(velocity)
		apply_central_force(velocity)
		
		
#need to creat a slide state, if in slide then this logic is changed to prevend sudden stop
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	_integrate_float(state)
	if state.linear_velocity.length()>MAXSPEED and grounded:
		state.linear_velocity = state.linear_velocity.normalized()*MAXSPEED
	if moveInput.length() <0.2 and grounded:
		state.linear_velocity = lerp(state.linear_velocity,Vector3.ZERO,(1/60)/stopSpeed)
		#state.linear_velocity.x = lerp(state.linear_velocity.x, 0.0,stopSpeed)
		#state.linear_velocity.z = lerp(state.linear_velocity.z, 0.0,stopSpeed)
		if %GroundRayCast.get_collision_normal().y <=0.95 and state.linear_velocity.y > 0.5:
			state.linear_velocity.y = 0
		

func _is_grounded()->bool:
	if !landCoolDownOnJump:
		%GroundRayCast.force_raycast_update()
		return %GroundRayCast.is_colliding()
	else:
		return false
