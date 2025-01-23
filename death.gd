extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is player:
		$Timer.start()
		$"../Camera2D/UI/Death".visible = true
