extends Node


func _on_play_button_down() -> void:
	$Play/AnimatedSprite2D.play("pressed")
func _on_play_button_up() -> void:
	$Play/AnimatedSprite2D.play("default")
func _on_lore_button_down() -> void:
	$Lore/AnimatedSprite2D.play("pressed")
	$LoreLabel.visible_ratio=move_toward(0,1,0.5)
func _on_lore_button_up() -> void:
	$Lore/AnimatedSprite2D.play("default")
	$LoreLabel.visible_ratio=move_toward(1,0,0.5)
