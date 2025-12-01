extends Control

@export var Lost:bool = false
var packagesSaved:int = 0


func _on_try_again_button_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_quit_button_button_up() -> void:
	get_tree().quit()
	pass # Replace with function body.
