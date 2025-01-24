#script adapted from Untitled Game (unreleased yet)
extends Node
var level_number:float
@export var NUMBER_OF_OBJECTS_TO_DESTROY:int = 1
var important_objects_destroyed = 0
var kiwi_death_count = 0
@export var RESPAWN_LIMIT:int = 2
var has_level_been_completed = false
var Player:CharacterBody2D #not @onready since main menu has no player scene


#takes you to next level
func _ready() -> void:
	var current_scene_file = get_tree().current_scene.scene_file_path
	level_number = current_scene_file.to_int()
	print("######### Level " + str(level_number) +" #########")


#assigns signals to following functions
	if $Camera2D != null:
		$"Camera2D/UI/EndScreen/Next".pressed.connect(switch_to_next_level)
		$"Camera2D/UI/EndScreen/Retry".pressed.connect(reset_level)
		$"Camera2D/UI/EndScreen/Back".pressed.connect(switch_to_main_menu)

	#translated from code by secay on PS Discord server
	var ImportantObjects:Array[Node] = get_tree().get_nodes_in_group("ImportantObjects")
	for ImportantObject:Node in ImportantObjects:
		ImportantObject.important_object_destroyed.connect(on_important_object_destroyed)

	if $Player != null:
		Player = $Player
		$Player.detonate.connect(on_kiwi_death)




#level-related keybinds
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("reset level"):
		reset_level()
	if Input.is_action_just_released("skip level (dev only)"):
		switch_to_next_level()




func on_important_object_destroyed():
	important_objects_destroyed += 1
	print("Objective: "+str(important_objects_destroyed)+"/"+str(NUMBER_OF_OBJECTS_TO_DESTROY))
	if important_objects_destroyed >= NUMBER_OF_OBJECTS_TO_DESTROY: #if level completed
		has_level_been_completed = true
		level_complete_or_failed()



func on_kiwi_death():
	kiwi_death_count += 1
	$Camera2D/UI/Death.visible = false
	if kiwi_death_count >= RESPAWN_LIMIT: #BUG
		level_complete_or_failed()
	else:
		respawn_player()



func level_complete_or_failed():
	$"Camera2D/UI/EndScreen".visible = true
	$"Camera2D/UI/EndScreenUnderlay".visible = true



func respawn_player():
	remove_child(Player)#suggested by ameliaaa on PS server
	var player_scene = preload("res://player.tscn")
	var player_scene_instance = player_scene.instantiate()
	add_child(player_scene_instance)


#following 3 func connected to end screen buttons
func switch_to_next_level():
	var next_level_number = level_number + 1
	var next_level_path = "res://level_" + str(next_level_number) + ".tscn"
	get_tree().change_scene_to_file(next_level_path)

func reset_level() -> void:
	get_tree().reload_current_scene()

func switch_to_main_menu():
	get_tree().change_scene_to_file("res://level_0.tscn")
