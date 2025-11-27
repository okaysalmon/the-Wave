extends Control

@export var Lost:bool = true
var packagesSaved:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Lost:
		$VBoxContainer/HBoxContainer/MarginContainer/MarginContainer/VBoxContainer/Label.text = $VBoxContainer/HBoxContainer/MarginContainer/MarginContainer/VBoxContainer/Label.text.format({"count":packagesSaved})
	get_tree().paused = true


func _on_try_again_button_button_up() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_quit_button_button_up() -> void:
	get_tree().quit()
	pass # Replace with function body.
