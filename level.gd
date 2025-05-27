#parts of script adapted from Untitled Game (unreleased yet)

#INSTRUCTIONS TO ADD NEW LEVEL
#1. Create new scene named level_[number] with the only node being a Level2D
#If this isnt a playable level (like level_0.tscn), you're done!
#2. Connect Player, CameraAndUI, LevelMusic and tile map layer scenes
#3. Add AudioStreamPlayer nodes named 'LevelComplete' and 'LevelFailed' and assign
	#the appropriate sound file and the 'Sound Effects' audio bus to them in Inspector
#4. Add some computers scenes
#5. Set level's export variables with 'Inspector' tab in editor
#6. Add any additional Destructable2D's and Sprite2D's

extends Node2D
class_name Level2D

var Player:CharacterBody2D #not @onready since main menu has no player scene

@export var NUMBER_OF_OBJECTS_TO_DESTROY:int = 1
@export var RESPAWN_LIMIT:int = 3
@export var TIME_BEFORE_KIWI_DETONATES = 5#must be over Player.WARNING_BEFORE_DETONATION
@export var time_limit_to_get_star:int
@export var respawn_limit_to_get_star:int=2

var level_number:int
var important_objects_destroyed = 0
var kiwi_death_count = 0
var has_level_been_completed = false
#without it, levelwin sfx plays twice if last available kiwi completes the level
var level_completed_check_done_already = false
var PlayerSpawnPoint:Marker2D
var levels_unlocked = GlobalScene.highest_level_completed+1#used to determine which level-switching buttons to enable (1/3)

signal main_objective_completed #recieved by ui.gd





func _ready() -> void:
#used to take you to next level
	var current_scene_file = get_tree().current_scene.scene_file_path
	level_number = current_scene_file.to_int()
	print("######### Level " + str(level_number) +" #########")


#assigns signals to following functions
	if $CameraAndUI != null:
		$"CameraAndUI/UI/EndScreen/HBoxContainer/Next".pressed.connect(switch_to_next_level)
		$"CameraAndUI/UI/EndScreen/HBoxContainer/Retry".pressed.connect(reset_level)
		$"CameraAndUI/UI/EndScreen/HBoxContainer/Back".pressed.connect(switch_to_main_menu)


	#translated from code by secay on PS Discord server
	var ImportantObjects:Array[Node] = get_tree().get_nodes_in_group("ImportantObjects")
	for ImportantObject:Node in ImportantObjects:
		ImportantObject.important_object_destroyed.connect(on_important_object_destroyed)

	GlobalScene.delayed_player_detonated.connect(on_kiwi_death)

	if $Player != null: #instead of @onready since main menu has no player
		Player = $Player

#so that kiwi always spawns where the OG did
		PlayerSpawnPoint=Marker2D.new()#thanks to cloudninja in discord
		add_child(PlayerSpawnPoint)
		PlayerSpawnPoint.global_position=Player.global_position

#used to determine which level-switching buttons to enable (2/3)
	if level_number==0:
		if levels_unlocked >= 2:
			$"Control/LevelSelector/Level Selecting Button".visible=true
			$"Control/LevelSelector/Level Selecting Button2".visible=true
			if levels_unlocked >= 3:
				$"Control/LevelSelector/Level Selecting Button3".visible=true
				if levels_unlocked >= 4:
					$"Control/LevelSelector/Level Selecting Button4".visible=true
					if levels_unlocked >=5:
						$"Control/LevelSelector/Level Selecting Button5".visible=true
#if only level one unlocked, skip level-selecting process
		if levels_unlocked==1:
			var PlayButton=$Control/Play
			PlayButton.toggle_mode=false
			PlayButton.pressed.connect(switch_to_next_level)



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
#without it, levelwin sfx plays twice if last available kiwi completes the level
	if level_completed_check_done_already == true:
		return
	level_completed_check_done_already = true


	var Star2 = $CameraAndUI/UI/Star2
	var Star3 = $CameraAndUI/UI/Star3
	
	$"CameraAndUI/UI/EndScreen".visible = true
	$"CameraAndUI/UI/EndScreenUnderlay".visible = true
	$"CameraAndUI/UI/ColorRect".visible = true
	$"CameraAndUI/UI/EndScreen/FinalTime".text = str($"CameraAndUI/UI".time_spent_in_level)+" seconds"
	$"CameraAndUI/UI/Objective".visible=false
	$"CameraAndUI/UI/TimeLeft".visible=false
	$"CameraAndUI/UI/StopwatchTimer".stop()
	$CameraAndUI/UI/Stopwatch.visible = false
	$CameraAndUI/UI/Star1.visible=true
	Star2.visible=true
	
	var number = RESPAWN_LIMIT-respawn_limit_to_get_star
	if number != 1:
		if number < 0:
			number = 0
		Star2.text="save "+str(number)+" kiwis" 
	else:
		Star2.text="save "+str(number)+" kiwi"
	Star3.visible=true
	Star3.text+=str(time_limit_to_get_star)+" secs"


	if has_level_been_completed == true:
		$LevelComplete.play()
		$"CameraAndUI/UI/EndScreen/HBoxContainer/Next".visible = true #failsafe
		main_objective_completed.emit()
		#used to determine which level-switching buttons to enable (3/3)
		if GlobalScene.highest_level_completed<level_number:
			GlobalScene.highest_level_completed=level_number
	
	else:
		$LevelFailed.play()
		$"CameraAndUI/UI/EndScreen/HBoxContainer/Next".visible = false



#thanks cookie1170 in PS discord server for helping identifying the problems regarding a bug in here
#using only queue_free() somehow messes with the referencing
#not using it somehow makes viewport freeze after func is run twice
func respawn_player():
	Player.queue_free()
	remove_child(Player)#suggested by ameliaaa on PS server
	var player_scene = preload("res://player.tscn")
	var player_scene_instance = player_scene.instantiate()
	self.add_child(player_scene_instance)
#running func x2 without this results in error "Cannot call method queue_free on a previously freed instance."
	Player = player_scene_instance





#following 3 func connected to end screen buttons
func switch_to_next_level():
	var next_level_number:int = level_number + 1
	var next_level_path = "res://level_" + str(next_level_number) + ".tscn"
	get_tree().change_scene_to_file(next_level_path)

func reset_level() -> void:
	get_tree().reload_current_scene()

func switch_to_main_menu():
	get_tree().change_scene_to_file("res://level_0.tscn")
