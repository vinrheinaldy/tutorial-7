extends StaticBody3D

@export var rotation_speed: float = 2.0 
@export var hover_speed: float = 3.0
@export var hover_amplitude: float = 0.2

# ini kode dari AI soalnya icba ngurus mtknya sowwy!!

var start_y: float = 0.0
var time_passed: float = 0.0

func _ready():
	start_y = position.y

func _process(delta):
	rotate_y(rotation_speed * delta)
	
	time_passed += delta
	
	position.y = start_y + (sin(time_passed * hover_speed) * hover_amplitude)
