extends Sprite

export(int) var amount = 3
export(int) var texture_width = 30

func _ready():
	randomize()
	variate()
# Called when the node enters the scene tree for the first time.
func variate():
	var skips: int = randi() % amount
	region_rect.position.x = skips * texture_width


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
