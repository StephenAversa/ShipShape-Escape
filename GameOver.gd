extends Control


onready var worlds = $Label2
var can_continue = false


# Called when the node enters the scene tree for the first time.
func _ready():
	worlds.text = "Worlds  Traveled  " + str(Globals.level) +"\n Times  Stunned  " + str(Globals.stuns)+"\n Enemies  Bounced  " + str(Globals.bounces)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (can_continue):
		get_input()

func get_input():
	if Input.is_action_just_pressed("jump"):
		SoundManager.stop()
		SceneTransition.change_scene("res://Menu.tscn")


func _on_Timer_timeout():
	can_continue = true
