extends StaticBody2D
class_name Destructable2D

var in_blast_radius = false
@onready var Player = $"../Player"
@onready var Particles =$CPUParticles2D
@onready var TimerNode = $Timer
@export var GoalIsToDestroyThis = false
@onready var Area = $Area2D

signal important_object_destroyed



func _ready() -> void:
	Player.detonate.connect(on_player_detonation)
	Area.area_entered.connect(_on_area_2d_area_entered)
	Area.area_exited.connect(_on_area_2d_area_exited)



#when Player's Area2D enters
func _on_area_2d_area_entered(_area: Area2D) -> void:
	in_blast_radius = true

#when Player's Area2D exits
func _on_area_2d_area_exited(_area: Area2D) -> void:
	in_blast_radius = false


func on_player_detonation():
	if in_blast_radius == true:
		print("yes")
		if GoalIsToDestroyThis == false:
			$Sprite2D.visible = false#because the others use an AnimatedSprite
			TimerNode.wait_time = Particles.lifetime
		else:
			$AnimatedSprite2D.play("broken")

#apply to both
		TimerNode.start()
		Particles.emitting = true



func _on_timer_timeout() -> void:
	if GoalIsToDestroyThis == false:
		queue_free()
	else:
		important_object_destroyed.emit()
