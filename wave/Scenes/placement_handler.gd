extends Node3D

@export var manaCost:float = 2

var PlacementItemScene:PackedScene:
	set(NewVal):
		if NewVal!=null:
			PlacementItemScene = NewVal
			PlacementItem = PlacementItemScene.instantiate()
			add_child(PlacementItem)
			visible = true
		else:
			if get_child_count()>0:
				get_child(0).queue_free()
			visible = false
@onready var cam= get_tree().get_first_node_in_group("camera")

@onready var playerStats:Node = get_tree().get_first_node_in_group("PlayStats")

var PlacementItem:Node3D
var SelectCoolDown:bool = false:
	set(newValue):
		SelectCoolDown = newValue
		if SelectCoolDown:
			await get_tree().create_timer(0.1).timeout
			SelectCoolDown = false
var SelectedPlacementItem:Node3D:
	set(newVal):
		SelectCoolDown = true
		SelectedPlacementItem = newVal
var Channeling:bool = false:
	set(NewValue):
		if NewValue and playerStats._EnoughManaToCast(manaCost):
			playerStats.CastRate = manaCost
			playerStats.casting = true
			Channeling = NewValue
		else:
			Channeling = false
		if !Channeling:
			playerStats.casting = false
			PlacementItem = null
			PlacementItemScene = null
		if SelectedPlacementItem != null:
			SelectedPlacementItem.channeling = NewValue
		if !Channeling:
			SelectedPlacementItem = null

#mousedOver
#masedOverNormals
#masedOverCollisionPoint
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	_connectToPlacemntHolder()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if PlacementItem!= null:
		if Channeling:
			SelectedPlacementItem.moveToPlacement(global_position,delta)
			if Input.is_action_just_released("select_item"):
				Channeling = false
		else:
			if cam.mousedOverCollisionPoint != Vector3.ZERO and cam.mousedOverNormals.y >=0.0:
				self.position = cam.mousedOverCollisionPoint+(cam.mousedOverNormals * PlacementItem.placement_offset)
		if Input.is_action_just_pressed("select_item") and !SelectCoolDown:
			Channeling = true
	pass

func _connectToPlacemntHolder():
	playerStats.OutOfMana.connect(_outOfMana)
	

func _outOfMana():
	Channeling = false
