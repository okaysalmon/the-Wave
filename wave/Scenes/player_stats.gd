extends Node

signal OutOfMana

@export var MaxMana:float = 30:
	set(newVal):
		MaxMana = newVal
		if manaBar != null:
			manaBar.max_value = MaxMana

@onready var manaBar:ProgressBar = get_tree().get_first_node_in_group("manaBar")

var currentMana:float = MaxMana:
	set(newValue):
		if newValue >MaxMana:
			newValue = MaxMana
		currentMana = newValue
		if manaBar != null:
			#print()
			manaBar.value = newValue
			manaBar.max_value = MaxMana

var casting:bool = false:
	set(newVale):
		if newVale and _EnoughManaToCast(CastRate):
			#print("thre was enough to cast")
			casting = true
			finshedCastingCD = null
		else:
			casting = false
		if casting:
			regenMana = false
		else:
			var CD:SceneTreeTimer = get_tree().create_timer(3)
			finshedCastingCD = CD
			await CD.timeout
			#print("i waited i realy did")
			if finshedCastingCD == CD:
				regenMana = true

var finshedCastingCD:SceneTreeTimer

var regenMana: bool = true
var RegenRate: float =10
var CastRate: float  = 2
var currentChangeTime:float = 10

var water_current:Vector2 = Vector2(-10,-5)#Vector2(randf_range(-5.0,5.0),randf_range(-5.0,5.0))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#_random_Current_rep()
	pass # Replace with function body.

func _random_Current():
	var randomVec:Vector2 = Vector2(randf_range(10.0,50.0),randf_range(10.0,50.0))
	if randi_range(1,10)>5:
		randomVec = randomVec*-1
	return randomVec

func _random_Current_rep():
	water_current = _random_Current()
	await get_tree().create_timer(currentChangeTime).timeout
	_random_Current_rep()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if casting:
		var DrainMulti:float = 0
		if $"../PlacementHandler".Channeling:
			DrainMulti +=1.0
		if $"../RigidBody3D/ShieldSphere".shieldUp:
			DrainMulti +=1.0
		
		currentMana -= (CastRate*delta)
		if !_EnoughManaToCast(CastRate*delta*DrainMulti):
			casting = false
	elif regenMana:
		currentMana += (RegenRate*delta)
	pass

func _EnoughManaToCast(CastCost:float)->bool:
	if currentMana < CastRate:
		emit_signal("OutOfMana")
	return currentMana > CastRate
