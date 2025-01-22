extends CharacterBody2D
class_name player

@onready var AnimatedSprite = $AnimatedSprite2D
@onready var Sparks1=$Sparks1
@onready var Sparks2=$Sparks2
@onready var Fuse =$Fuse
@onready var Level =$".."


var MAX_SPEED = 900
var JUMP_VELOCITY = -775
var EXTRA_FALL_GRAVITY = 37
var GRAVITY = 1000
var FRICTION = 70
var WARNING_BEFORE_DETONATION = 5
var times_timer_timedout = 0
var skidding = false #isnt currently used

#following ones will be used to switch between kiwis
@export var how_many_kiwi_deaths_before_active:int = 0 #set to negative if never active
var active = false

signal detonate



################### movement and animations ###################



#gravity and jump (adapted from Wiho does Puzzle-Platfroming (unreleased))
func _physics_process(delta):
	velocity.y += 10 #downward accelaration due to gravity
	move_and_slide() #handles player movement i think
	if not is_on_floor():
		velocity.y += GRAVITY * delta #downward accelaration due to gravity



	#jump
	if is_on_floor():
		if Input.is_action_just_pressed("up") and active == true:
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


#disables all movement except gravity
	#exception will be required for a small animation I'm planning
	if active == false:
		return


#walk (adapted from Wiho does Puzzle-Platfroming (unreleased))
	var direction = Input.get_axis("left", "right")
	if direction:
		#NOTE TO SELF: move_toward(from, to, delta)
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, 40)


#invading footstep SFX code (template from Potion Blaster)
		#if timer_footstep.time_left <= 0:
			#footstep_audio.pitch_scale = randf_range(0.8, 1.2)
			#footstep_audio.play()
			#timer_footstep.start(0.5)


	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)



#animations
	if is_on_floor():
		if velocity.x == 0:
			AnimatedSprite.play("idle")
		elif direction:
			AnimatedSprite.play("walk")

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
	if direction > 0 and velocity.x < 0 or direction < 0 and velocity.x > 0:
		skidding = true
		#print("Skid")
	else:
		skidding = false


#so that particles' initial velocity is relative to player's
#BUG doesnt work as intended as of now
	#Sparks1.initial_velocity_max = 100 - velocity.x
	#Sparks1.initial_velocity_min = velocity.x *-1
	#Sparks2.initial_velocity_max = 100 - velocity.x
	#Sparks2.initial_velocity_min = velocity.x *-1



	var reducing_time_before_detonation = true
	if Input.is_action_pressed("speed-up-fuse") and times_timer_timedout == 0:
		Sparks2.visible = true
		#without following line, Timer never times-out/behaves unexpectedly
		if Fuse.time_left > 1:
			Fuse.start(Fuse.time_left - 0.2)

#responsible for putting out sparks
	elif reducing_time_before_detonation == true:
		reducing_time_before_detonation = false
		if times_timer_timedout < 1:
			Sparks2.visible = false




################### stuff not in func _process ###################



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
	$Camera2D.position_smoothing_speed = -10 #stops it from moving
	detonate.emit()
	active = false #disables movement
	Level.kiwi_death_count += 1
	get_tree().call_group("PlayableCharacters", "should_this_kiwi_be_active")
	$CollisionShape2D.disabled = true

	$Camera2D.queue_free()



func _ready():
	add_to_group("PlayableCharacters")
	should_this_kiwi_be_active()

func should_this_kiwi_be_active():
	if Level.kiwi_death_count!=how_many_kiwi_deaths_before_active:
		return

	active = true

#gives newly-active kiwi Camera2D and GUI
	var ui_scene = preload("res://ui.tscn")
	var ui_instance = ui_scene.instantiate()
	add_child(ui_instance)
