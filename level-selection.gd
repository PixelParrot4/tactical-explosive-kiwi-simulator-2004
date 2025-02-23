extends HSlider
var level_selected:int=6
func _on_value_changed(value: int) -> void:
	level_selected=value
func _on_button_pressed() -> void:
	if level_selected >5:#the level they are already in
		return
	var next_level_path = "res://level_" + str(level_selected) + ".tscn"
	get_tree().change_scene_to_file(next_level_path)
