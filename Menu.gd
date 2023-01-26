extends Control

onready var button = $Node2D/VBoxContainer/Start
onready var level_planet = $Planet2

var selected = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	SoundManager.play_sound(SoundManager.MENU)
	button.grab_focus()

func _on_Start_pressed():
	SoundManager.stop()
	SceneTransition.change_scene("res://Cutscene/Ship_Cutscene.tscn")
	


func _on_Quit_pressed():
	get_tree().quit()


func _on_About_pressed():
	SoundManager.stop()
	SceneTransition.change_scene("res://Menu_Info.tscn")


func _on_Info_pressed():
	SoundManager.stop()
	SceneTransition.change_scene("res://Menu_About.tscn")


func _process(delta):
	if (level_planet != null):
		get_tree().call_group("gravity","update_gravity_location",level_planet.global_position)
