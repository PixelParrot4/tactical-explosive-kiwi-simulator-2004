extends Control

@onready var Level:Level2D = $"../.."
@onready var Retry=$EndScreen/HBoxContainer/Retry/AnimatedSprite2D
@onready var Next=$EndScreen/HBoxContainer/Next/AnimatedSprite2D
@onready var Back=$EndScreen/HBoxContainer/Back/AnimatedSprite2D
@onready var SelectSFX=$UISelect
@onready var StarSystem=$AnimationPlayer
@onready var StarSystemTimer=$StarSystemTimer
var time_spent_in_level:float=0.0
var efficiency_star_visible=false
var time_trial_star_visible=false

func _on_stopwatch_timer_timeout() -> void:
	time_spent_in_level+=0.1
#rounding to negate rounding imprecision (thx cookie1170 in PS discord server)
	time_spent_in_level=snappedf(time_spent_in_level, 0.1)
	$Stopwatch.text=str(time_spent_in_level)+" s"



func _on_mouse_entered_button() -> void:
	$UIHover.play()

func _on_retry_button_down() -> void:
	Retry.play("pressed")
	SelectSFX.play()
func _on_retry_button_up() -> void:
	Retry.play("default")
func _on_next_button_down() -> void:
	Next.play("pressed")
	SelectSFX.play()
func _on_next_button_up() -> void:
	Next.play("default")
func _on_back_button_down() -> void:
	Back.play("pressed")
	SelectSFX.play()
func _on_back_button_up() -> void:
	Back.play("default")
	SelectSFX.play()



#STAR SYSTEM
func _ready():
	Level.main_objective_completed.connect(_on_main_objective_completed)

func _on_main_objective_completed():
	StarSystem.play("level_complete")
	$EndScreen/Stars/MainObjectiveStar.visible=true
	$EndScreen/Stars/MainObjectiveStar.play("default")
	print("main objective success")
	StarSystemTimer.start()


func _on_star_system_timer_timeout() -> void:
	if Level.kiwi_death_count <= Level.respawn_limit_to_get_star and efficiency_star_visible!=true:
		$EndScreen/Stars/EfficiencyStar.visible=true
		StarSystem.play("efficiency_success")
		$EndScreen/Stars/EfficiencyStar.play("default")
		print("efficiency success")
		efficiency_star_visible=true
	if time_spent_in_level <= Level.time_limit_to_get_star and StarSystem.is_playing()==false and time_trial_star_visible!=true:
		$EndScreen/Stars/TimeTrialStar.visible=true
		StarSystem.play("time_trial_success")
		$EndScreen/Stars/TimeTrialStar.play("default")
		print("time trial success")
		time_trial_star_visible=true
