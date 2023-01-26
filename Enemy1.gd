extends KinematicBody2D

export var speed = 150
export var jump_speed = 500
export var gravity = 500
var velocity = Vector2.ZERO
var active = false
var land = Vector2.ZERO
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var anim = $AnimationPlayer

func _ready():
	anim.play("roll")

func _physics_process(delta):
		rotation = (position.direction_to(land).angle() - PI/2)
		velocity.x = speed
		velocity.y += gravity * delta
		var snap = transform.y * 128
		velocity = move_and_slide_with_snap(velocity.rotated(rotation),
						snap, -transform.y, true, 4, PI/3)
		velocity = velocity.rotated(-rotation)

		if is_on_floor():
			rotation = get_floor_normal().angle() + PI/2

func update_gravity_location(planet):
	land = planet
	
