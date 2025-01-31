extends Control

@onready var Player = $"../../Player"
@onready var Retry=$EndScreen/HBoxContainer/Retry/AnimatedSprite2D
@onready var Next=$EndScreen/HBoxContainer/Next/AnimatedSprite2D
@onready var Back=$EndScreen/HBoxContainer/Back/AnimatedSprite2D
var time_spent_in_level:float=0.0

func _on_stopwatch_timer_timeout() -> void:
	time_spent_in_level+=0.1
#rounding to negate rounding imprecision (thx cookie1170 in PS discord server)
	time_spent_in_level=snappedf(time_spent_in_level, 0.1)
	$Stopwatch.text=str(time_spent_in_level)+" s"



func _on_retry_button_down() -> void:
	Retry.play("pressed")
func _on_retry_button_up() -> void:
	Retry.play("default")
func _on_next_button_down() -> void:
	Next.play("pressed")
func _on_next_button_up() -> void:
	Next.play("default")
func _on_back_button_down() -> void:
	Back.play("pressed")
func _on_back_button_up() -> void:
	Back.play("default")
