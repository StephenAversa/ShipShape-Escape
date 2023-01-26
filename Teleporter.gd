extends Node2D

onready var spawn = false
onready var anim = $AnimationPlayer
onready var particles = $Particles2D

signal player_spawn(position)
signal next_level()

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("in")
	pass # Replace with function body.

func _process(delta):
	if Globals.broken:
		particles.emitting = true
	else:
		particles.emitting = false

func out():
	anim.play("out")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "in":
		emit_signal("player_spawn",global_position)
	if anim_name == "out":
		emit_signal("next_level")
		
