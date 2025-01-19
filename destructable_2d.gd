extends StaticBody2D
class_name Destructable2D

var in_blast_radius = false
@onready var Player = $"../Player"

func _ready() -> void:
	Player.detonate.connect(on_player_detonation)


#when Player's Area2d enters
func _on_area_2d_area_entered(area: Area2D) -> void:
	in_blast_radius = true

#when Player's Area2d exits
func _on_area_2d_area_exited(area: Area2D) -> void:
	in_blast_radius = false


func on_player_detonation():
	if in_blast_radius == true:
		queue_free()
