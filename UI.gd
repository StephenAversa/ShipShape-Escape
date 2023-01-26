extends Control


onready var thermometer = $Sprite/TextureProgress
onready var world_label = $WorldLabel



func _process(delta):
	thermometer.value = Globals.temp
	world_label.text = "World " + str(Globals.level)

