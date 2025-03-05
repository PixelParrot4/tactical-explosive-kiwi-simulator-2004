extends Node

#volume sliders
#using https://youtu.be/aFkRmtGiZCw
var music_bus_index:int
var sfx_bus_index:int
@onready var MusicVolumeSlider:Slider=$MusicVolume
@onready var SFXVolumeSlider:Slider=$SFXVolume

func _ready() -> void:
	music_bus_index=AudioServer.get_bus_index("Music")
	MusicVolumeSlider.value_changed.connect(_on_music_value_changed)
	MusicVolumeSlider.value=db_to_linear(AudioServer.get_bus_volume_db(music_bus_index))

	sfx_bus_index=AudioServer.get_bus_index("Sound Effects")
	SFXVolumeSlider.value_changed.connect(_on_sfx_value_changed)
	SFXVolumeSlider.value=db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_index))


func _on_music_value_changed(value:float)-> void:
	AudioServer.set_bus_volume_db(
		music_bus_index,
		linear_to_db(value)
	)


func _on_sfx_value_changed(value:float)-> void:
	AudioServer.set_bus_volume_db(
		sfx_bus_index,
		linear_to_db(value)
	)


#buttons
func _on_mouse_entered_button() -> void:
	$"../UIHover".play()

func _on_play_button_down() -> void:
	$Play/AnimatedSprite2D.play("pressed")
	$"../UISelect".play()
func _on_play_button_up() -> void:
	$Play/AnimatedSprite2D.play("default")


func _on_lore_toggled(toggled_on: bool) -> void:
	$"../UISelect".play()
	if toggled_on==true:
		$Lore/AnimatedSprite2D.play("pressed")
		$LoreLabel.visible=true
	else:
		$Lore/AnimatedSprite2D.play("default")
		$LoreLabel.visible=false
