extends CharacterBody3D

@onready var navigationAgent := $NavigationAgent3D
@onready var gravity = 9.8
var Speed = 2
#var turn_speed = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(!is_on_floor()):
		velocity.y += gravity * delta
	if(navigationAgent.is_target_reached()):
		return
		
	moveToPoint(delta, Speed)
	pass

func moveToPoint(delta, Speed):
	var targetPos = navigationAgent.target_position
	var direction = global_position.direction_to(targetPos)
	faceDirection(targetPos)
	velocity = direction * Speed
	move_and_slide()
	
func faceDirection(direction):
	look_at(Vector3(direction.x, global_position.y, direction.z), Vector3.UP)
	
	
#	The Below is to try and make turning slower
#func faceDirection(targetPos: Vector3, delta : float) -> void:
	#var new_transform = transform.looking_at(targetPos, Vector3.UP)
	#transform = transform.interpolate_with(new_transform, turn_speed * delta)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("LeftMouse"):
		var camera = get_tree().get_nodes_in_group("Camera")[0]
		var mousePos = get_viewport().get_mouse_position()
		var rayLength = 100
		var from = camera.project_ray_origin(mousePos)
		var to = from + camera.project_ray_normal(mousePos) * rayLength
		var space = get_world_3d().direct_space_state
		var rayQuery = PhysicsRayQueryParameters3D.new()
		rayQuery.from = from
		rayQuery.to = to
		var result = space.intersect_ray(rayQuery)
		print(result)
		if result.size() <1:
			return
		navigationAgent.target_position = result.position
