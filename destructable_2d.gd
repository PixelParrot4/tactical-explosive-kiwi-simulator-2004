extends StaticBody2D
class_name Destructable2D

#INSTRUCTIONS TO SET UP THIS NODE
#1. Add Destructable2D node to level (ik it's spelt wrong)
#2. Make sure player.tscn is in same level
#3. Add Timer child node
#4. Add Sprite2D or AnimatedSprite2D with their textures
#5. Add collision and Area2D with collision
#6. Add CPUParticles2D and set it up (one shot = true)
#7. When applicable, set GoalIsToDestroyThis = true and put it in ImportantObjects group


var in_blast_radius = false
@onready var Player = $"../Player"
@onready var Particles =$CPUParticles2D
@onready var TimerNode = $Timer
@export var GoalIsToDestroyThis = false
@onready var Area = $Area2D

signal important_object_destroyed



func _ready() -> void:
	Area.area_entered.connect(_on_area_2d_area_entered)
	Area.area_exited.connect(_on_area_2d_area_exited)
	TimerNode.timeout.connect(_on_timer_timeout)
	connect_signal_from_player()


#BUG
#without next 3 lines respawned players wont be able to blow up this node
	$"..".new_player_scene_spawned_by_now.connect(connect_signal_from_player)
func connect_signal_from_player():
	Player.detonate.connect(on_player_detonation)





#when Player's Area2D enters
func _on_area_2d_area_entered(_area: Area2D) -> void:
	in_blast_radius = true

#when Player's Area2D exits
func _on_area_2d_area_exited(_area: Area2D) -> void:
	in_blast_radius = false


func on_player_detonation():
	if in_blast_radius == true:
		print("Destructible2D is in blast radius")
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
		print("imp obj destroyed")
		important_object_destroyed.emit()
