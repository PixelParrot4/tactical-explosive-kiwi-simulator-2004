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
	#translated from code by secay on PS Discord server
	var ImportantObjects:Array[Node] = get_tree().get_nodes_in_group("ImportantObjects")
	for ImportantObject:Node in ImportantObjects:
		ImportantObject.important_object_destroyed.connect(on_important_object_destroyed)


	if $Player != null:
		$"Player/Camera2D/UI/EndScreen/Next".pressed.connect(switch_to_next_level)
		$"Player/Camera2D/UI/EndScreen/Retry".pressed.connect(reset_level)
		$"Player/Camera2D/UI/EndScreen/Back".pressed.connect(switch_to_main_menu)
	if $"Player2/Camera2D" != null:
		$"Player2/Camera2D/UI/EndScreen/Next".pressed.connect(switch_to_next_level)
		$"Player2/Camera2D/UI/EndScreen/Retry".pressed.connect(reset_level)
		$"Player2/Camera2D/UI/EndScreen/Back".pressed.connect(switch_to_main_menu)
	if $Player3 != null:
		$"Player3/Camera2D/UI/EndScreen/Next".pressed.connect(switch_to_next_level)
		$"Player3/Camera2D/UI/EndScreen/Retry".pressed.connect(reset_level)
		$"Player3/Camera2D/UI/EndScreen/Back".pressed.connect(switch_to_main_menu)


#level-related keybinds
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("reset level"):
		reset_level()
	if Input.is_action_just_released("skip level (dev only)"):
		switch_to_next_level()




func on_important_object_destroyed():
	important_objects_destroyed += 1
	print("Objective: "+str(important_objects_destroyed)+"/"+str(NUMBER_OF_OBJECTS_TO_DESTROY))
	if important_objects_destroyed >= NUMBER_OF_OBJECTS_TO_DESTROY:
		$"Player/Camera2D/UI/EndScreen".visible = true


#following 3 func connected to end screen buttons
func switch_to_next_level():
	var next_level_number = level_number + 1
	var next_level_path = "res://level_" + str(next_level_number) + ".tscn"
	get_tree().change_scene_to_file(next_level_path)

func reset_level() -> void:
	get_tree().reload_current_scene()

func switch_to_main_menu():
	get_tree().change_scene_to_file("res://level_0.tscn")
