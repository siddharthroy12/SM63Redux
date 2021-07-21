extends KinematicBody2D
onready var lm_counter = $"/root/Main/Player".life_meter_counter
onready var lm_gui = $"/root/Main/Player/Camera2D/GUI/Life_meter_counter"
onready var player = $"/root/Main/Player/AnimatedSprite"
const GRAVITY = 10
var speed = 200
const FLOOR = Vector2(0, -1)

var velocity = Vector2()

export var direction = 1

	
func _ready():
	velocity.x = 0
	
func _physics_process(_delta):
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)
	#print(direction)
	if is_on_wall():
		direction *= -1
	
func _on_CollisionArea_body_entered(body):
	if body.hitbox.global_position.y + body.hitbox.shape.extents.y < global_position.y && body.vel.y > 0:
		print("collided from top")
		$"/root/Main/Player".vel.y = -5
		if body.global_position.x < global_position.x:
			velocity.x = speed
		else:
			velocity.x = -speed
	elif body.global_position.x < global_position.x:
		print("collided from left")
		#if it's less than, then x-wise it's left and y-wise it's up.
		velocity.x = speed
	elif body.global_position.x > global_position.x:
		print("collided from right")
		velocity.x = -speed

		