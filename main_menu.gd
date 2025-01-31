extends Node

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
