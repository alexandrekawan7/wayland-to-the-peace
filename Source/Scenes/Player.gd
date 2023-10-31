extends CharacterBody2D


const SPEED = 1

const DIRECTION_UP = -1
const DIRECTION_LEFT = -1
const DIRECTION_DOWN = 1
const DIRECTION_RIGHT = 1

func _ready():
	$AnimatedSprite2D.play("idle")

func _process(delta):
	if Input.is_action_pressed("move_up"):
		if $AnimatedSprite2D.animation == "idle":
			$AnimatedSprite2D.stop()
			
		position.y -= SPEED
	elif Input.is_action_pressed("move_left"):
		if $AnimatedSprite2D.animation == "idle":
			$AnimatedSprite2D.stop()
			
		position.x -= SPEED
	elif Input.is_action_pressed("move_down"):
		if $AnimatedSprite2D.animation == "idle":
			$AnimatedSprite2D.stop()
			
		position.y += SPEED
	elif Input.is_action_pressed("move_right"):
		if $AnimatedSprite2D.animation != "move_right":
			$AnimatedSprite2D.play("move_right")
		
		position.x += SPEED
	else:
		$AnimatedSprite2D.play("idle")

