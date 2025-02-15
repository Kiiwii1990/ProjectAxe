extends Node3D

var player
var camera_zoom = 0.0

@export var sensitivity := 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = player.global_position
	#Zoom
	if Input.is_action_just_pressed("mouseWheelUp"):
		camera_zoom -= 0.5
		
	if Input.is_action_just_pressed("mouseWheelDown"):
		camera_zoom += 0.5
	$SpringArm3D.position.z += camera_zoom
	$SpringArm3D.position.z = clamp($SpringArm3D.position.z,5,25)
	camera_zoom = lerpf(camera_zoom,0.0,0.2)
	#Movement of the camera, to set up later!
	#if Input.is_action_just_pressed("b_camera_drag"):
		#
		#camera_drag = get_viewport().get_mouse_position()
		#
	#if Input.is_action_pressed("b_camera_drag"):
		#
		#camera_movement.x += (get_viewport().get_mouse_position().x-camera_drag.x) * sensibility
		#camera_movement.z += (get_viewport().get_mouse_position().y-camera_drag.y) * sensibility
		
	
	

func _input(event: InputEvent) -> void:
	var tempRot
	if(Input.is_action_pressed("RightMouse")):
		if event is InputEventMouseMotion:
			tempRot = rotation.x - event.relative.y / 1000 * sensitivity
			rotation.y -= event.relative.x / 1000 * sensitivity
			tempRot = clamp(tempRot, -1, 0.25)
			rotation.x = tempRot
	
