extends CharacterBody2D

@onready var AnimatedSprite = $AnimatedSprite2D
@onready var Sparks1=$Sparks1
@onready var Sparks2=$Sparks2
@onready var Fuse =$Fuse

var MAX_SPEED = 1000
var JUMP_VELOCITY = -775
var EXTRA_FALL_GRAVITY = 37
var GRAVITY = 1000
var FRICTION = 0
var WARNING_BEFORE_DETONATION = 5
var times_timer_timedout = 0
var skidding = false #isnt currently used

signal detonate


#gravity and jump (adapted from Wiho does Puzzle-Platfroming (unreleased))
func _physics_process(delta):
	velocity.y += 10 #downward accelaration due to gravity
	move_and_slide() #handles player movement i think
	if not is_on_floor():
		velocity.y += GRAVITY * delta #downward accelaration due to gravity



	#jump
	if is_on_floor():
		if Input.is_action_just_pressed("up"):
			velocity.y = JUMP_VELOCITY
	else:
		#variable jump height
#		if Input.is_action_just_released("ui_up") and velocity.y < -60:
#			velocity.y = -60
	
	#fast falling
		if velocity.y > 0:
			velocity.y += EXTRA_FALL_GRAVITY
	#terminal velocity
	velocity.y = min(velocity.y, 1500)



#walk (adapted from Wiho does Puzzle-Platfroming (unreleased))
	var direction = Input.get_axis("left", "right")
	
	if direction:
		#NOTE TO SELF: move_toward(from, to, delta)
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, 40)
	#elif skidding == false:
	else:
		velocity.x = move_toward(velocity.x, 0, MAX_SPEED)



#animations
	if is_on_floor():
		if velocity.x == 0:
			AnimatedSprite.play("idle")
		elif direction:
			AnimatedSprite.play("walk")


		if Input.is_action_pressed("left") and Input.is_action_pressed("right"):
			velocity.x = move_toward(velocity.x, 0, FRICTION)
			skidding = true
		else:
			skidding = false


	#horizontal flipping
	if direction < 0:
		AnimatedSprite.flip_h = true
		Sparks1.position = Vector2(34,10)
		Sparks2.position = Vector2(34,10)
		Sparks2.direction.x = 1
	elif direction > 0:
		AnimatedSprite.flip_h = false
		Sparks1.position = Vector2(-34,10)
		Sparks2.position = Vector2(-34,10)
		Sparks2.direction.x = -1



	#skid detection
	#if direction > 0 and velocity.x < 0 or direction < 0 and velocity.x < 0:
		##velocity.x = move_toward(velocity.x, 0, FRICTION)
		#skidding = true
	#else:
		#skidding = false


	Sparks1.initial_velocity_max += velocity.x
	Sparks1.initial_velocity_min += velocity.x
	Sparks2.initial_velocity_max += velocity.x
	Sparks2.initial_velocity_min += velocity.x



	var reducing_time_before_detonation = true
	if Input.is_action_pressed("speed-up-fuse"):
		Sparks2.visible = true
#BUG doesnt work
		#if Fuse.wait_time >= 10:
			#Fuse.wait_time -= 10
	elif reducing_time_before_detonation == true:
		reducing_time_before_detonation = false
		if times_timer_timedout < 1:
			Sparks2.visible = false


#####################################################



func _on_fuse_timeout() -> void:
	times_timer_timedout += 1

	if times_timer_timedout == 1:
		Fuse.wait_time = WARNING_BEFORE_DETONATION
		Sparks2.visible = true
		Fuse.start()

	elif times_timer_timedout > 1:
		explode()



func explode():
	Sparks1.visible = false
	Sparks2.visible = false
	$Explosion.emitting = true
	AnimatedSprite.visible = false
	$Camera2D.position_smoothing_speed = 0 #stops it from moving
	detonate.emit()
