extends Button
@onready var button = $button
@onready var number_display = $number_display
@onready var UIHover:AudioStreamPlayer=$"/root/MainMenu/UIHover"
@export var level:int#level you are taken to once button pressed

#display frame whose number corresponds with var level
func _ready() -> void:
	number_display.frame=level

#animation code
func _on_button_down() -> void:
	button.play("pressed")
	number_display.position=Vector2(38,38)
	$"/root/MainMenu/UISelect".play()#sfx code (1/2)
func _on_button_up() -> void:
	button.play("unpressed")
	number_display.position=Vector2(38,30)

#sfx code (2/2)
func _on_mouse_entered() -> void:
	UIHover.play()
#level switching code borrowed from level.gd
func _on_pressed() -> void:
	var level_path = "res://level_" + str(level) + ".tscn"
	get_tree().change_scene_to_file(level_path)
