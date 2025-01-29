extends Control

@onready var Player = $"../../Player"
@onready var SpeedLabel = $VBoxContainer/SpeedLabel
@onready var JumpLabel = $VBoxContainer/JumpLabel
@onready var GravityLabel = $VBoxContainer/GravityLabel
@onready var ExtraGravityLabel =$VBoxContainer/ExtraGravityLabel
@onready var FrictionLabel = $VBoxContainer/FrictionLabel
var time_spent_in_level=0

func _ready() -> void:
	_on_speed_h_slider_value_changed(Player.MAX_SPEED)
	_on_jump_h_slider_value_changed(Player.JUMP_VELOCITY *-1)
	_on_gravity_h_slider_value_changed(Player.GRAVITY)
	_on_exra_gravity_h_slider_value_changed(Player.EXTRA_FALL_GRAVITY)
	_on_exra_gravity_h_slider_value_changed(Player.FRICTION)


func _on_speed_h_slider_value_changed(value: float) -> void:
	Player.MAX_SPEED = value
	SpeedLabel.text = "Speed: " + str(value)


func _on_jump_h_slider_value_changed(value: float) -> void:
	Player.JUMP_VELOCITY = value *-1
	JumpLabel.text = "Jump Velocity: " + str(value)


func _on_gravity_h_slider_value_changed(value: float) -> void:
	Player.GRAVITY = value
	GravityLabel.text = "Gravity: " + str(value)


func _on_exra_gravity_h_slider_value_changed(value: float) -> void:
	Player.EXTRA_FALL_GRAVITY = value
	ExtraGravityLabel.text = "Extra Fall Gravity: " + str(value)


func _on_friction_h_slider_value_changed(value: float) -> void:
	Player.FRICTION = value
	FrictionLabel.text = "Friction: " + str(value)



#to be used only for debugging
#func _process(_delta: float):
	#if Player == null:
		#return
	#var time_left:int = $"../../Player/Fuse".time_left
	#$TimeLeft.text = str(time_left)


func _on_stopwatch_timer_timeout() -> void:
	time_spent_in_level+=0.1
#rounding to negate rounding imprecision (thx cookie1170 in PS discord server)
	time_spent_in_level=snappedf(time_spent_in_level, 0.1)
	$Stopwatch.text=str(time_spent_in_level)+" s"
