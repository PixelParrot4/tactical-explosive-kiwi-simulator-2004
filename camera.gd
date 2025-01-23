extends Camera2D

@onready var Player = $"../Player"

func _process(_delta: float) -> void:
	if Player != null:
		global_position = Player.global_position
