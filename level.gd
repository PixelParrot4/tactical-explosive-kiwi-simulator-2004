#parts of script adapted from Untitled Game (unreleased yet)

#INSTRUCTIONS TO ADD NEW LEVEL
#1. Create new scene named level_[number] with the only node being a Level2D
#2. Add a Timer as child node to level
#If this isnt a playable level (like level_0.tscn), you're done!
#3. Connect Player, CameraAndUI, LevelMusic and tile map layer scenes
#4. Add some objects required to be destroyed by following instructions in destructable_2d.gd
#5. Set level's export variables with 'Inspector' tab in editor
#6. Add any additional Destructable2D's and Sprite2D's

extends Node2D
class_name Level2D

@onready var LevelTimer:Timer=$Timer
var Player:CharacterBody2D #not @onready since main menu has no player scene

@export var NUMBER_OF_OBJECTS_TO_DESTROY:int = 1
@export var RESPAWN_LIMIT:int = 3
@export var TIME_BEFORE_KIWI_DETONATES = 10#should be -5 the actual amount

var level_number:float
var important_objects_destroyed = 0
var kiwi_death_count = 0
var has_level_been_completed = false


#takes you to next level
func _ready() -> void:
	var current_scene_file = get_tree().current_scene.scene_file_path
	level_number = current_scene_file.to_int()
	print("######### Level " + str(level_number) +" #########")


#assigns signals to following functions
	if $CameraAndUI != null:
		$"CameraAndUI/UI/EndScreen/Next".pressed.connect(switch_to_next_level)
		$"CameraAndUI/UI/EndScreen/Retry".pressed.connect(reset_level)
		$"CameraAndUI/UI/EndScreen/Back".pressed.connect(switch_to_main_menu)

	#translated from code by secay on PS Discord server
	var ImportantObjects:Array[Node] = get_tree().get_nodes_in_group("ImportantObjects")
	for ImportantObject:Node in ImportantObjects:
		ImportantObject.important_object_destroyed.connect(on_important_object_destroyed)

	if $Player != null: #instead of @onready since main menu has no player
		Player = $Player

	GlobalScene.player_detonated.connect(on_kiwi_death)



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
	$CameraAndUI/UI/Death.visible = false
	if kiwi_death_count >= RESPAWN_LIMIT:
		level_complete_or_failed()
	elif has_level_been_completed == false:
		respawn_player()



func level_complete_or_failed():
	$"CameraAndUI/UI/EndScreen".visible = true
	$"CameraAndUI/UI/EndScreenUnderlay".visible = true
	$"CameraAndUI/UI/EndScreen/FinalTime".text = str($"CameraAndUI/UI".time_spent_in_level)+" seconds"
	$"CameraAndUI/UI/Objective".visible=false
	$"CameraAndUI/UI/TimeLeft".visible=false
	$"CameraAndUI/UI/StopwatchTimer".stop()
	if has_level_been_completed == true:
		$LevelComplete.play()
		$"CameraAndUI/UI/EndScreen/Next".visible = true #failsafe
	else:
		$LevelFailed.play()
		$"CameraAndUI/UI/EndScreen/Next".visible = false



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
