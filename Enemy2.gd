class_name Enemy2
extends KinematicBody2D

onready var ray_check = $RayCast2D
onready var attack_ray_check = $RayCast2D2
onready var attack_check = $AttackCheck
onready var attack_timer = $AttackTimer

export var speed = 100
export var attack_speed = 200
export var friction = 20
var land = Vector2.ZERO
var velocity = Vector2.ZERO
var see_player = false
var back_to_idle = true
var direction

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var nums = [1,-1] #list to choose from
	direction =  nums[randi() % nums.size()]
	if (direction == 1):
		attack_check.scale.x = -1


func update_gravity_location(planet):
	land = planet


func _on_AttackCheck_body_entered(body):
	if body.is_in_group("player"):
		see_player = true


func _on_AttackCheck_body_exited(body):
	if body.is_in_group("player"):
		see_player = false


func _on_AttackTimer_timeout():
	back_to_idle = true
