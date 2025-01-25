extends Node2D
func _process(_delta: float) -> void:
	var PlayerPos = $"../Player".global_position
	global_position.x = move_toward(global_position.x, PlayerPos.x, 14.5)
	global_position.y = move_toward(global_position.y, PlayerPos.y, 23)
