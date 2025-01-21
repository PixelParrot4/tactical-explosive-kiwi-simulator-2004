#script adapted from Untitled Game (unreleased yet)
extends Node
var level_number:float
@export var NUMBER_OF_OBJECTS_TO_DESTROY:int = 1
var important_objects_destroyed = 0
var kiwi_death_count = 0 #will be used to switch between kiwis


#takes you to next level
	#made using https://youtu.be/GZrALMvOwY8
func _ready() -> void:
	var current_scene_file = get_tree().current_scene.scene_file_path
	level_number = current_scene_file.to_int()
	print("######### Level " + str(level_number) +" #########")


#assigns signal to following function
	if $ImportantObject != null:
		$ImportantObject.important_object_destroyed.connect(on_important_object_destroyed)
	if $ImportantObject2 != null:#if more than one ImportantObject present
		$ImportantObject.important_object_destroyed.connect(on_important_object_destroyed)


func on_important_object_destroyed():
	important_objects_destroyed += 1
	if important_objects_destroyed >= NUMBER_OF_OBJECTS_TO_DESTROY:
		pass #make end screen visible


func switch_to_next_level():
	var next_level_number = level_number + 1
	var next_level_path = "res://level_" + str(next_level_number) + ".tscn"
	get_tree().change_scene_to_file(next_level_path)
