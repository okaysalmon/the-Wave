extends Node

signal OutOfMana

@export var SaveTime:float = 180:
	set(newValue):
		SaveTime = newValue
		var minutes = SaveTime / 60
		var seconds = fmod(SaveTime, 60)
		var time_string = "%02d:%02d" % [minutes, seconds]
		timerTextLable.text = time_string

@export var MaxMana:float = 30:
	set(newVal):
		MaxMana = newVal
		if manaBar != null:
			manaBar.max_value = MaxMana

@onready var timerTextLable :Label = get_tree().get_first_node_in_group("timerText")
@onready var manaBar:ProgressBar = get_tree().get_first_node_in_group("manaBar")
@onready var CrateCountLable:Label = get_tree().get_first_node_in_group("crateCount")


var WinePopUpScene:PackedScene = load("res://UI/GameOverWin.tscn")
var Started :bool = false

var currentScore :int = 0:
	set(newValue):
		currentScore = newValue
		if CrateCountLable != null:
			CrateCountLable.text = str(currentScore)


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
	SaveTime = SaveTime
	#_random_Current_rep()
	await get_tree().create_timer(3).timeout
	Started = true
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
	if Started:
		SaveTime -= delta
		if SaveTime <= 0:
			var win_screen = WinePopUpScene.instantiate()
			win_screen.packagesSaved = currentScore
			get_parent().add_child(win_screen)
			
	if casting:
		var DrainMulti:float = 0
		if $"../PlacementHandler".Channeling:
			DrainMulti +=1.0
		if is_instance_valid($"../RigidBody3D/ShieldSphere") and $"../RigidBody3D/ShieldSphere".shieldUp:
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


func _on_point_zone_body_entered(body: Node3D) -> void:
	if body.is_in_group("Crate"):
		currentScore += 1
		body.inPointZone = true
	pass # Replace with function body.


func _on_point_zone_body_exited(body: Node3D) -> void:
	if body.is_in_group("Crate"):
		currentScore -= 1
		body.inPointZone = false
	pass # Replace with function body.
