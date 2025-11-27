extends Node3D

var lostPopUp:PackedScene = load("res://UI/GameOverLose.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(5).timeout
	var GameOverScreen = lostPopUp.instantiate()
	get_tree().get_root().get_node("Main").add_child(GameOverScreen)

	
	
