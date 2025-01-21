extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is player:
		$Timer.start()
		$"../Player/Camera2D/UI/Death".visible = true


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("reset level"):
		reset_level()


func reset_level() -> void:
	get_tree().reload_current_scene()
