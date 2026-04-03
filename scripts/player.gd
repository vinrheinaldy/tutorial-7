extends CharacterBody3D

@export var walk_speed: float = 10.0
@export var sprint_speed: float = 16.0
@export var crouch_speed: float = 4.0
var current_speed: float = walk_speed

@export var acceleration: float = 5.0
@export var gravity: float = 9.8
@export var jump_power: float = 5.0
@export var mouse_sensitivity: float = 0.3

var normal_head_height: float
@export var crouch_amount: float = 0.5
@export var crouch_transition_speed: float = 10.0

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var raycast: RayCast3D = $Head/Camera3D/RayCast3D

@onready var collision_shape: CollisionShape3D = $CollisionShape3D

var normal_hitbox_height: float
var normal_hitbox_y : float
@export var crouch_hitbox_height: float = 1.0

var inventory: Array = []
var camera_x_rotation: float = 0.0

@onready var item_counter: Label = $CanvasLayer/ItemCounter
# If ure reading this ObjLamp3 emg gabisa diambil lol

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	normal_head_height = head.position.y
	normal_hitbox_height = collision_shape.shape.height
	normal_hitbox_y = collision_shape.position.y

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))

		var x_delta = event.relative.y * mouse_sensitivity
		camera_x_rotation = clamp(camera_x_rotation + x_delta, -90.0, 90.0)
		camera.rotation_degrees.x = -camera_x_rotation
		
func _physics_process(delta):
	if Input.is_action_pressed("crouch"):
		current_speed = crouch_speed
	elif Input.is_action_pressed("sprint"):
		current_speed = sprint_speed
	else:
		current_speed = walk_speed

	var target_head_height = normal_head_height
	if Input.is_action_pressed("crouch"):
		target_head_height = normal_head_height - crouch_amount
	head.position.y = lerp(head.position.y, target_head_height, crouch_transition_speed * delta)
	var target_hitbox_height = normal_hitbox_height
	if Input.is_action_pressed("crouch"):
		target_hitbox_height = crouch_hitbox_height
		
	collision_shape.shape.height = lerp(collision_shape.shape.height, target_hitbox_height, crouch_transition_speed * delta)
	var height_difference = normal_hitbox_height - collision_shape.shape.height
	collision_shape.position.y = normal_hitbox_y - (height_difference / 2.0)
	
	var movement_vector = Vector3.ZERO

	if Input.is_action_pressed("movement_forward"):
		movement_vector -= head.basis.z
	if Input.is_action_pressed("movement_backward"):
		movement_vector += head.basis.z
	if Input.is_action_pressed("movement_left"):
		movement_vector -= head.basis.x
	if Input.is_action_pressed("movement_right"):
		movement_vector += head.basis.x

	movement_vector = movement_vector.normalized()

	velocity.x = lerp(velocity.x, movement_vector.x * current_speed, acceleration * delta)
	velocity.z = lerp(velocity.z, movement_vector.z * current_speed, acceleration * delta)

	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_power

	move_and_slide()

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		if raycast.is_colliding():
			var target = raycast.get_collider()
			if target.is_in_group("item"):
				inventory.append(target.name)
				target.queue_free()
				
				item_counter.text = "Item: " + str(inventory.size())
