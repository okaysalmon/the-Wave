extends FloatingRigidBody3d

@export var placementScene:PackedScene
@export var moveUpClampSpeed:float = 5
@export var moveUpForce:float = 1
@export var floatDownDist:float = 2

@onready var placementHandlerNode = get_tree().get_first_node_in_group("PlacementHandler")
@onready var playerStats:Node = get_tree().get_first_node_in_group("PlayStats")

var channeling:bool = false:
	set(newValue):
		channeling = newValue
		if channeling: 
			GoingUp = true
		else:
			GoingUp = false
			moveingToPlacement = false
			highlight = false

var GoingUp:bool = false:
	set(newValue):
		GoingUp = newValue
		if GoingUp:
			var GUtime = get_tree().create_timer(1)
			goingUpTimer = GUtime
			await GUtime.timeout
			if GoingUp and channeling and goingUpTimer == GUtime:
				moveingToPlacement = true
				GoingUp = false

var goingUpTimer:SceneTreeTimer
var moveingToPlacement:bool = false
var movingToPos:Vector3
var maxMoveToSpeed:float = 5
var currentImmune:bool = true

var highlight:bool = false:
	set(newVal):
		highlight = newVal
		if placementHandlerNode.PlacementItem ==null or placementHandlerNode == null:
			$MeshInstance3D/MeshInstance3D.visible = highlight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(10).timeout
	currentImmune = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select_item") and highlight:
		#print("I did something")
		placementHandlerNode.SelectedPlacementItem = self
		placementHandlerNode.PlacementItemScene = placementScene
	pass

func _physics_process(delta: float) -> void:
	_physics_float(delta)
	pass

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	_integrate_float(state)
	apply_current(state)
	if GoingUp and linear_velocity.y >moveUpClampSpeed:
		linear_velocity.y = moveUpClampSpeed
	if moveingToPlacement:
		var ditToX = (movingToPos.x - global_position.x)/2
		var distToZ = (movingToPos.z - global_position.z)/2
		var FloatY = gravity*gravity_scale
		if Vector2(ditToX,distToZ).length() < floatDownDist:
			FloatY = Vector2(ditToX,distToZ).length()/floatDownDist * FloatY
		apply_central_force(Vector3(ditToX,FloatY,distToZ)*mass)
		if linear_velocity.length() > maxMoveToSpeed:
			linear_velocity = linear_velocity.normalized()*maxMoveToSpeed
		
			
			


func apply_current(state: PhysicsDirectBodyState3D):
	if submerged and !channeling and !currentImmune:
		var current:Vector3 = Vector3(playerStats.water_current.x,0,playerStats.water_current.y)
		apply_central_force(current)

func _on_mouse_entered() -> void:
	if placementHandlerNode.PlacementItem ==null or placementHandlerNode == null:
		highlight=true
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	highlight=false
	pass # Replace with function body.

func moveToPlacement(placementsGlobalPosition:Vector3,delta):
	if GoingUp:
		apply_central_force(Vector3.UP*moveUpForce*mass*gravity*gravity_scale)
	#elif moveingToPlacement:
	#	var moveDir = (placementsGlobalPosition-global_position).normalized()
	#	movingToPos = placementsGlobalPosition
	#	apply_central_force((moveDir*moveUpForce)+(Vector3(0,gravity*gravity_scale*mass,0)))
		
