extends CharacterBody2D

const ACCELERATION = 500
const MAX_SPEED = 100 #VELOCIDAD MÁXIMO DEL JUGADOR
const FRICTION = 500 #

var velocidad = Vector2.ZERO

@onready var player = $"."
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animationState = animation_tree.get("parameters/playback")
@onready var audio_stream_player = $AudioStreamPlayer
@onready var timer = $Timer

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	
	var input_vector = Vector2.ZERO

	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		
		animation_tree.set("parameters/IDLE/blend_position", input_vector)
		animation_tree.set("parameters/Correr/blend_position", input_vector)
		animationState.travel("Correr")
		
		velocidad = velocidad.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	else:
		if $Timer.time_left <= 1.2:
			audio_stream_player.pitch_scale = randf_range(1.0, 1.0)
			audio_stream_player.play()
			$Timer.start(0)
	
		animationState.travel("IDLE")
		velocidad = velocidad.move_toward(Vector2.ZERO, FRICTION * delta)
	

	
	
	move_and_collide(velocidad * delta)
