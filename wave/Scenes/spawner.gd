extends Area3D

@export var Crates:Array[PackedScene]=[load("res://FloatItems/crate.tscn")]
@export var Tentical:PackedScene = load("res://Scenes/tentical/tentical_2.tscn")

var SpawTime_new_Crates:float = 30.0
var SpawTime_new_Tentical:float = 45.0

var spawnNumberCrates:int = 4
var spawnNumberTentical:int = 1

var currentTimeCrates :float = 10.0:
	set(NewValue):
		if NewValue<=0:
			currentTimeCrates = SpawTime_new_Crates
			spawnMultiFromMulti(Crates,spawnNumberCrates)
		else:
			currentTimeCrates = NewValue
			
var currentTimeTentical :float = 40.0:
	set(NewValue):
		if NewValue<=0:
			currentTimeTentical = SpawTime_new_Tentical
			spawnMulti(Tentical, spawnNumberTentical)
		else:
			currentTimeTentical = NewValue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	currentTimeCrates -= delta
	currentTimeTentical -= delta
	pass

func spawnMulti(ItemOrEnim:PackedScene, Amount:int):
	for i in Amount:
		spawn(ItemOrEnim)

func spawnMultiFromMulti(ItemOrEnim:Array[PackedScene], Amount:int):
	for i in Amount:
		spawn(ItemOrEnim.pick_random())

func spawn(ItemOrEnim:PackedScene):
	var SpawnedThing = ItemOrEnim.instantiate()
	var SpawnAreaShape = $CollisionShape3D.shape
	var SpawnArea = SpawnAreaShape.extents
	var random_offset = Vector3(
		randf_range(-SpawnArea.x, SpawnArea.x),
		randf_range(-SpawnArea.y, SpawnArea.y),
		randf_range(-SpawnArea.z, SpawnArea.z))
	var SpawnPos = global_transform.origin + random_offset
	SpawnedThing.position = SpawnPos
	$"..".add_child(SpawnedThing)
