#script adapted from Untitled Game (unreleased yet)
extends Node
var level_number

#takes you to next level
	#made using https://youtu.be/GZrALMvOwY8
func _ready() -> void:
	var current_scene_file = get_tree().current_scene.scene_file_path
	level_number = current_scene_file.to_int()
	print("######### Level " + str(level_number) +" #########")


#you have to manually assign signal to this func
func switch_to_next_level():
		var next_level_number = level_number + 1
		var next_level_path = "res://level_" + str(next_level_number) + ".tscn"
		get_tree().change_scene_to_file(next_level_path)
