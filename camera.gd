extends Node2D
var x_position_smoothening = 14.5
var y_position_smoothening = 23

func _process(_delta: float) -> void:
	var PlayerPos = $"../Player".global_position
	global_position.x = move_toward(global_position.x, PlayerPos.x, x_position_smoothening)
	global_position.y = move_toward(global_position.y, PlayerPos.y, y_position_smoothening)

#travel towards player faster when kiwi respawns
#can be improved by replacing first line with if player is farther from camera than [] 
	if $"../Player".velocity==Vector2(0,0):
		x_position_smoothening=40
		y_position_smoothening=40
	else:
		x_position_smoothening = 14.5
		y_position_smoothening = 23
