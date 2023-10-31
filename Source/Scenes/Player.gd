extends CharacterBody2D


const SPEED = 3

const DIRECTION_UP = 1
const DIRECTION_LEFT = 2
const DIRECTION_DOWN = 3
const DIRECTION_RIGHT = 4

@onready var current_direction = DIRECTION_DOWN

func flip():
	$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h

func stay_idle() -> void:
	match current_direction:
			DIRECTION_UP:
				if $AnimatedSprite2D.flip_h:
					flip()
				if $AnimatedSprite2D.animation != "idle_backward":
					$AnimatedSprite2D.play("idle_backward")
			DIRECTION_LEFT:
				if not $AnimatedSprite2D.flip_h:
					flip()
				if $AnimatedSprite2D.animation != "idle_lateral":
					$AnimatedSprite2D.play("idle_lateral")
			DIRECTION_DOWN:
				if $AnimatedSprite2D.flip_h:
					flip()
				if $AnimatedSprite2D.animation != "idle_frontal":
					$AnimatedSprite2D.play("idle_frontal")
			DIRECTION_RIGHT:
				if $AnimatedSprite2D.animation != "idle_lateral":
					$AnimatedSprite2D.play("idle_lateral")
				
				if $AnimatedSprite2D.flip_h:
					flip()
			

func _ready():
	stay_idle()

func _process(_delta):
	if Input.is_action_pressed("move_up"):
		if $AnimatedSprite2D.animation != "move_backward":
			$AnimatedSprite2D.play("move_backward")
		
		if $AnimatedSprite2D.flip_h:
			flip()
			
		current_direction = DIRECTION_UP
		
		move_and_collide(Vector2(0, -SPEED))
	elif Input.is_action_pressed("move_left"):
		if $AnimatedSprite2D.animation != "move_lateral":
			$AnimatedSprite2D.play("move_lateral")
		
		if not $AnimatedSprite2D.flip_h:
			flip()
			
		current_direction = DIRECTION_LEFT
		
		move_and_collide(Vector2(-SPEED, 0))
	elif Input.is_action_pressed("move_down"):
		if $AnimatedSprite2D.animation != "move_frontal":
			$AnimatedSprite2D.play("move_frontal")
		
		if $AnimatedSprite2D.flip_h:
			flip()
			
		current_direction = DIRECTION_DOWN
		
		move_and_collide(Vector2(0, SPEED))
	elif Input.is_action_pressed("move_right"):
		if $AnimatedSprite2D.animation != "move_lateral":
			$AnimatedSprite2D.play("move_lateral")
		
		if $AnimatedSprite2D.flip_h:
			flip()
			
		current_direction = DIRECTION_RIGHT
		
		move_and_collide(Vector2(SPEED, 0))
	else:
		stay_idle()



func _on_combat_area_body_entered(body):
	print("Begin combat!")
