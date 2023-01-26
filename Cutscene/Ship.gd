extends Sprite


var gravity = Vector2(40,150)
var velocity = Vector2()
var up = false
var down = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	if down:
		velocity += gravity * delta
		set_position(get_position() + velocity * delta)
