extends CharacterBody3D

@onready var navigationAgent := $NavigationAgent3D
@onready var gravity = 9.8

var Speed = 2
var lastLookDirection : Vector3
var turn_speed = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(!is_on_floor()):
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
	if(navigationAgent.is_target_reached()):
		return
		
	moveToPoint(delta, Speed)
	pass
var moving_to_tile = false
var current_target_tile = Vector3.ZERO

func moveToPoint(delta, Speed):
	if moving_to_tile:
		var direction = global_position.direction_to(current_target_tile)
		velocity = direction * Speed
		move_and_slide()
		
		if global_position.distance_to(current_target_tile) < 0.1:
			global_position = current_target_tile
			moving_to_tile = false
			velocity = Vector3.ZERO
		
		else:
			if !navigationAgent.is_target_reached():
				var next_point = get_nearest_grid_position(navigationAgent.get_next_path_position())
				current_target_tile = next_point
				moving_to_tile = true
	
	#var targetPos = navigationAgent.target_position
	#var direction = global_position.direction_to(targetPos)
	#faceDirection(targetPos, delta)
	#velocity = Vector3(direction.x * Speed, velocity.y, direction.z * Speed)
	#move_and_slide()
	
func faceDirection(targetPos: Vector3, delta : float) -> void:
	var direction = (targetPos - global_position).normalized()
	direction.y = 0
	
	if direction.length() > 0:
		var target_basis = Basis.looking_at(direction, Vector3.UP)
		transform.basis = transform.basis.slerp(target_basis, turn_speed * delta)  # Smooth rotation

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("LeftMouse"):
		var camera = get_tree().get_nodes_in_group("Camera")[0]
		var mousePos = get_viewport().get_mouse_position()
		var rayLength = 100
		var from = camera.project_ray_origin(mousePos)
		var to = from + camera.project_ray_normal(mousePos) * rayLength
		var space = get_world_3d().direct_space_state

		# First raycast to detect where the player clicked
		var rayQuery = PhysicsRayQueryParameters3D.new()
		rayQuery.from = from
		rayQuery.to = to
		rayQuery.collision_mask = 1  # Ensure this includes walkable areas

		var result = space.intersect_ray(rayQuery)
		if result.is_empty():
			return  # Ignore invalid clicks

		var target_position = result.position

		# Second raycast downward to find the actual ground
		var groundRayQuery = PhysicsRayQueryParameters3D.new()
		groundRayQuery.from = target_position + Vector3(0, 2, 0)  # Start above the point
		groundRayQuery.to = target_position + Vector3(0, -5, 0)  # Look downward for ground
		groundRayQuery.collision_mask = 1  # Match the walkable area layer

		var groundResult = space.intersect_ray(groundRayQuery)
		
		var snapped_position = get_nearest_grid_position(groundResult.position)
		navigationAgent.target_position = snapped_position + Vector3(0, 0.5, 0)  # Offset slightly
		
			
func get_nearest_grid_position(position: Vector3, grid_size: float = 1.0) -> Vector3:
	return Vector3(
		round(position.x / grid_size) * grid_size,
		position.y,
		round(position.z / grid_size) * grid_size
	)

var movement_queue = []

func set_grid_movement_path(target_pos: Vector3):
	movement_queue.clear()
	var current_pos = get_nearest_grid_position(global_position)
	var target_tile = get_nearest_grid_position(target_pos)
	
	while current_pos != target_tile:
		if current_pos.x < target_tile.x:
			current_pos.x += 1
		elif current_pos.x > target_tile.x:
			current_pos.x -= 1
		
		if current_pos.z < target_tile.z:
			current_pos.z += 1
		elif  current_pos.z > target_tile.z:
			current_pos.z -= 1
		
		movement_queue.append(current_pos)
	
	move_to_next_tile()
	
func move_to_next_tile():
	if movement_queue.is_empty():
		moving_to_tile = false
		return
		
		moving_to_tile = true
		current_target_tile = movement_queue.pop_front()
