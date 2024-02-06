extends CharacterBody2D


const SPEED = 3

const DIRECTION_UP = 1
const DIRECTION_LEFT = 2
const DIRECTION_DOWN = 3
const DIRECTION_RIGHT = 4

const BORDER_DISTANCE_VERTICAL = 300
const BORDER_DISTANCE_HORIZONTAL = 500

@onready var current_direction = DIRECTION_DOWN

@onready var level: StaticBody2D = get_parent().get_node("Level")

@onready var camera: Camera2D = get_parent().get_node("Camera")

@onready var menu: Control = $Menu

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
	if Input.is_action_just_pressed("pause"):
			Global.is_paused = !Global.is_paused
	
	menu.visible = Global.is_paused
	
	if not Global.is_paused:
		if not Global.is_in_combat:
			camera.position = self.position
			
			if $AnimatedSprite2D.is_playing() and $AnimatedSprite2D.animation in ["attack_frontal", "attack_lateral", "attack_backward"]:
				return
			
			if Input.is_action_pressed("move_up"):
				if $AnimatedSprite2D.animation != "move_backward":
					$AnimatedSprite2D.play("move_backward")
				
				if $AnimatedSprite2D.flip_h:
					flip()
					
				if not Input.is_action_pressed("keep_direction"):
					current_direction = DIRECTION_UP
				else:
					current_direction = DIRECTION_DOWN
				
				move_and_collide(Vector2(0, -SPEED))
			elif Input.is_action_pressed("move_left"):
				if $AnimatedSprite2D.animation != "move_lateral":
					$AnimatedSprite2D.play("move_lateral")
				
				if not $AnimatedSprite2D.flip_h:
					flip()
					
				if not Input.is_action_pressed("keep_direction"):
					current_direction = DIRECTION_LEFT
				else:
					current_direction = DIRECTION_RIGHT
				
				move_and_collide(Vector2(-SPEED, 0))
			elif Input.is_action_pressed("move_down"):
				if $AnimatedSprite2D.animation != "move_frontal":
					$AnimatedSprite2D.play("move_frontal")
				
				if $AnimatedSprite2D.flip_h:
					flip()
				
				if not Input.is_action_pressed("keep_direction"):
					current_direction = DIRECTION_DOWN
				else:
					current_direction = DIRECTION_UP
				
				move_and_collide(Vector2(0, SPEED))
			elif Input.is_action_pressed("move_right"):
				if $AnimatedSprite2D.animation != "move_lateral":
					$AnimatedSprite2D.play("move_lateral")
				
				if $AnimatedSprite2D.flip_h:
					flip()
					
				if not Input.is_action_pressed("keep_direction"):
					current_direction = DIRECTION_RIGHT
				else:
					current_direction = DIRECTION_LEFT
				
				move_and_collide(Vector2(SPEED, 0))
			elif Input.is_action_pressed("attack"):
				match current_direction:
					DIRECTION_DOWN:
						if $AnimatedSprite2D.animation != "attack_frontal":
							$AnimatedSprite2D.play("attack_frontal")
					DIRECTION_RIGHT:
						if $AnimatedSprite2D.animation != "attack_lateral":
							$AnimatedSprite2D.play("attack_lateral")
						
						if $AnimatedSprite2D.flip_h:
							flip()
					DIRECTION_LEFT:
						if $AnimatedSprite2D.animation != "attack_lateral":
							$AnimatedSprite2D.play("attack_lateral")
						
						if not $AnimatedSprite2D.flip_h:
							flip()
					DIRECTION_UP:
						if $AnimatedSprite2D.animation != "attack_backward":
							$AnimatedSprite2D.play("attack_backward")
			else:
				stay_idle()
		else:
			var enemy_pos: Vector2 = get_parent().get_node("Enemy").position
			
			camera.position = Vector2(enemy_pos.x - 75, enemy_pos.y)
			
			if $AnimatedSprite2D.animation != "idle_lateral":
				$AnimatedSprite2D.play("idle_lateral")

func _on_combat_area_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body == self:
		Global.is_in_combat = true
		
		var enemy_pos: Vector2 = get_parent().get_node("Enemy").position
		
		position = Vector2(enemy_pos.x - 150, enemy_pos.y)
		
		camera.zoom = Vector2(1.5, 1.5)
