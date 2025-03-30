extends CharacterBody2D

#to be able to change scene's texture without localising it
@export var texture:Texture2D
func _ready() -> void:
	if texture:
		$Destructable2D/Sprite2D.texture=texture

#gravity and jump (adapted from player script)
var GRAVITY = 1000
func _physics_process(delta: float):
	velocity.y += 10 #downward accelaration due to gravity
	move_and_slide() #handles player movement i think
	if not is_on_floor():
		velocity.y += GRAVITY * delta #downward accelaration due to gravity

	#terminal velocity
	velocity.y = min(velocity.y, 1500)

#teleports Destructible2D
	$Destructable2D.global_position = global_position
