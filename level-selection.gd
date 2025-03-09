extends HSlider
@export var level_selected:int
@export var ui_hover_sfx:AudioStreamPlayer
@export var ui_select_sfx:AudioStreamPlayer

func _on_value_changed(value: int) -> void:
	level_selected=value
	ui_hover_sfx.play()

func _on_button_pressed() -> void:
	ui_select_sfx.play()
	if level_selected >5:#the level they are already in
		return
	var next_level_path = "res://level_" + str(level_selected) + ".tscn"
	get_tree().change_scene_to_file(next_level_path)
