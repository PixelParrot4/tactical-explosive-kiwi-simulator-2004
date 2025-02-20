extends Node2D
class_name Destructable2D

#INSTRUCTIONS TO SET UP THIS NODE
#1. Add Destructable2D node to level (ik it's spelt wrong)
#2. Make sure player.tscn is in same level
#3. Add Timer child node
#4. Add Sprite2D or AnimatedSprite2D with their textures
#5. Add collision and Area2D with collision
#6. Add CPUParticles2D and set it up (one shot = true)
#7. If applicable, set GoalIsToDestroyThis = true and put it in ImportantObjects group


var in_blast_radius = false
@onready var Particles =$CPUParticles2D
@onready var TimerNode = $Timer
@export var GoalIsToDestroyThis = false
@onready var Area = $Area2D
var collision
var blown_up=false#to fix bug where computer can be blown up multiple times

signal important_object_destroyed



func _ready() -> void:
	Area.area_entered.connect(_on_area_2d_area_entered)
	Area.area_exited.connect(_on_area_2d_area_exited)
	TimerNode.timeout.connect(_on_timer_timeout)
	GlobalScene.player_detonated.connect(on_player_detonation)

	if $CollisionShape2D != null:
		collision=$CollisionShape2D
	elif $"../CollisionShape2D" != null:
		collision=$"../CollisionShape2D"


#when Player's Area2D enters
func _on_area_2d_area_entered(_area: Area2D) -> void:
#BUG: player check works but somehow stops self from blowing up
	#if area.get_parent() == $"../Player":
	in_blast_radius = true

#when Player's Area2D exits
func _on_area_2d_area_exited(_area: Area2D) -> void:
	#if area.get_parent() == $"../Player":
	in_blast_radius = false


func on_player_detonation():
	if in_blast_radius == true and blown_up==false:
		blown_up=true
		Particles.emitting = true
		if $AudioStreamPlayer2D != null:
			$AudioStreamPlayer2D.play()
		if GoalIsToDestroyThis == false:
			$Sprite2D.visible = false#because the others use an AnimatedSprite
			TimerNode.start(Particles.lifetime)
			if collision != null:
				collision.disabled=true
		else:
			$AnimatedSprite2D.play("broken")
			important_object_destroyed.emit()



func _on_timer_timeout() -> void:
	if GoalIsToDestroyThis == false:
		if get_parent() is CharacterBody2D:
			get_parent().queue_free()
		else:
			queue_free()
