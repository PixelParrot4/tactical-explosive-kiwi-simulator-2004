extends CharacterBody2D
class_name player

@onready var AnimatedSprite = $AnimatedSprite2D
@onready var Sparks1=$Sparks1
@onready var Sparks2=$Sparks2
@onready var Fuse =$Fuse
@onready var Level =$".."
@onready var FootstepTimer=$FootstepTimer
@onready var FootstepSFX=$Footsteps
@onready var SkidParticles=$SkidParticle
@onready var SparkSFX=$Sparks

var MAX_SPEED = 900
var JUMP_VELOCITY = -775
var EXTRA_FALL_GRAVITY = 37
var GRAVITY = 1000
var FRICTION = 70
var WARNING_BEFORE_DETONATION = 5
var times_timer_timedout = 0
var skidding = false #isnt currently used
var active = true #disables movement when is false
var direction#used for movement and to check for movement
var was_on_floor:bool

signal detonate




################### movement and animations ###################



func _physics_process(delta):
#disables all movement
	if active == false:
		return



#gravity and jump (adapted from Wiho does Puzzle-Platfroming (unreleased))
	velocity.y += 10 #downward accelaration due to gravity
	move_and_slide() #handles player movement i think
	if not is_on_floor():
		velocity.y += GRAVITY * delta #downward accelaration due to gravity

#invading footstep sfx code (1/3)
		was_on_floor = false
		FootstepTimer.stop()


	#jump
	if is_on_floor():
		if Input.is_action_just_pressed("up"):
			velocity.y = JUMP_VELOCITY
			$Jump.pitch_scale = randf_range(0.8,1.2)
			$Jump.play()

#invading footstep sfx code (2/3)
		if was_on_floor == false: #to prevent repetition
			FootstepTimer.start()
			FootstepSFX.play()
			was_on_floor = true

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
	direction = Input.get_axis("left", "right")
	if direction:
		#NOTE TO SELF: move_toward(from, to, delta)
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, 25)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)



#animations
	if is_on_floor():
		if velocity.x == 0:
			AnimatedSprite.play("idle")
		elif direction:
			AnimatedSprite.play("walk")


	#skid particles (omg this code block sucks)
		if direction > 0 and velocity.x < 0 or direction < 0 and velocity.x > 0:
			$Skid.playing = true
			SkidParticles.emitting = true
			if direction < 0 and velocity.x > 0:
				SkidParticles.direction = Vector2(1,0)
			else:
				SkidParticles.direction = Vector2(-1,0)
		else:
			$Skid.playing = false
			SkidParticles.emitting = false
	else:
		$Skid.playing = false
		SkidParticles.emitting = false



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


#so that particles' initial velocity is relative to player's
#BUG doesnt work as intended as of now
	#Sparks1.initial_velocity_max = 100 - velocity.x
	#Sparks1.initial_velocity_min = velocity.x *-1
	#Sparks2.initial_velocity_max = 100 - velocity.x
	#Sparks2.initial_velocity_min = velocity.x *-1



	var reducing_time_before_detonation = true
	if Input.is_action_pressed("speed-up-fuse") and times_timer_timedout == 0:
		Sparks2.visible = true
		if SparkSFX.playing == false:
			SparkSFX.playing = true
		#without following line, Timer never times-out/behaves unexpectedly
		if Fuse.time_left > 1:
			Fuse.start(Fuse.time_left - 0.2)

#responsible for putting out sparks
	elif reducing_time_before_detonation == true:
		reducing_time_before_detonation = false
		if times_timer_timedout < 1:
			Sparks2.visible = false
			SparkSFX.playing = false




################### stuff not in func _process ###################



func _on_fuse_timeout() -> void:
	times_timer_timedout += 1

	if times_timer_timedout == 1:
		Sparks2.visible = true
		if SparkSFX.playing == false:
			SparkSFX.playing = true
		Fuse.start(WARNING_BEFORE_DETONATION)

	elif times_timer_timedout == 2:
		explode()

#after a short delay, player controls next kiwi
#it may not be entirely deleted so that sign of explosion is visible
	elif times_timer_timedout == 3:
		detonate.emit()



func explode():
	Sparks1.visible = false
	Sparks2.visible = false
	SparkSFX.playing = false
	$Explosion.emitting = true
	AnimatedSprite.visible = false
	active = false #disables movement
	#Level.kiwi_death_count += 1
	$CollisionShape2D.disabled = true
	FootstepTimer.stop()
	Fuse.start(1.5)#delay b4 respawning
	$ExplosionSFX.pitch_scale = randf_range(0.8,1.2)
	$ExplosionSFX.play()


	if is_on_floor():
		var sign_of_explosion = preload("res://sign_of_explosion.tscn")
		var sign_of_explosion_instance = sign_of_explosion.instantiate()
		Level.add_child(sign_of_explosion_instance)



#footstep sfx code (3/3)
func _on_footstep_timer_timeout() -> void:
	if active==false:
		return

	FootstepTimer.start()
	if direction and is_on_floor():
		FootstepSFX.play()
		FootstepSFX.pitch_scale = randf_range(0.8, 1.2)
