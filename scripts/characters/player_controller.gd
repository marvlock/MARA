class_name PlayerController
extends CharacterBody3D

## First-person movement foundation. Interaction and flashlight behavior are deliberately
## absent; their camera children provide stable attachment points for later systems.
@export_category("Movement")
@export var walk_speed: float = 4.0
@export var sprint_speed: float = 6.0
@export var crouch_speed: float = 2.2
@export var ground_acceleration: float = 14.0
@export var ground_deceleration: float = 18.0
@export var air_acceleration: float = 4.0

@export_category("Look")
@export_range(0.0001, 0.01, 0.0001) var mouse_sensitivity: float = 0.002
@export_range(1.0, 89.0, 1.0) var look_limit_degrees: float = 85.0

@export_category("Crouch")
@export var standing_height: float = 1.8
@export var crouching_height: float = 1.2
@export var crouch_transition_speed: float = 10.0

@export_category("Head Bob")
@export var head_bob_enabled: bool = true
@export var head_bob_frequency: float = 1.8
@export var head_bob_amplitude: float = 0.035

@onready var head: Node3D = $Head
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var head_base_height: float
var bob_time: float = 0.0


func _ready() -> void:
	head_base_height = head.position.y
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clampf(head.rotation.x, deg_to_rad(-look_limit_degrees), deg_to_rad(look_limit_degrees))
	elif event.is_action_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_apply_movement(delta)
	_update_crouch(delta)
	move_and_slide()
	_update_head_bob(delta)


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = minf(velocity.y, 0.0)


func _apply_movement(delta: float) -> void:
	var input_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var local_direction := Vector3(input_vector.x, 0.0, input_vector.y)
	var direction := (global_transform.basis * local_direction).normalized()
	var target_speed := _get_target_speed()
	var target_velocity := direction * target_speed
	var acceleration := ground_acceleration if is_on_floor() else air_acceleration
	var deceleration := ground_deceleration if is_on_floor() else air_acceleration
	var rate := acceleration if input_vector.length_squared() > 0.0 else deceleration

	velocity.x = move_toward(velocity.x, target_velocity.x, rate * delta)
	velocity.z = move_toward(velocity.z, target_velocity.z, rate * delta)


func _get_target_speed() -> float:
	if Input.is_action_pressed("crouch"):
		return crouch_speed
	if Input.is_action_pressed("sprint"):
		return sprint_speed
	return walk_speed


func _update_crouch(delta: float) -> void:
	var is_crouching := Input.is_action_pressed("crouch")
	var target_height := crouching_height if is_crouching else standing_height
	var capsule := collision_shape.shape as CapsuleShape3D
	if capsule == null:
		return

	capsule.height = move_toward(capsule.height, target_height, crouch_transition_speed * delta)
	collision_shape.position.y = capsule.height * 0.5
	var target_head_height := head_base_height - (standing_height - crouching_height if is_crouching else 0.0)
	head.position.y = move_toward(head.position.y, target_head_height, crouch_transition_speed * delta)


func _update_head_bob(delta: float) -> void:
	if not head_bob_enabled or not is_on_floor():
		bob_time = 0.0
		return

	var horizontal_speed := Vector2(velocity.x, velocity.z).length()
	if horizontal_speed < 0.1:
		bob_time = 0.0
		return

	bob_time += delta * head_bob_frequency * horizontal_speed
	var crouch_offset := standing_height - crouching_height if Input.is_action_pressed("crouch") else 0.0
	head.position.y += sin(bob_time) * head_bob_amplitude * delta * 12.0
	head.position.y = lerpf(head.position.y, head_base_height - crouch_offset, delta * 8.0)
