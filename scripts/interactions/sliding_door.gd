class_name SlidingDoor
extends Node3D

## Reusable sliding door driven through the shared Interactable component.
## Story, power, and MARA systems can use open(), close(), lock(), and unlock()
## without needing level-specific door code.

signal state_changed(previous_state: DoorState, current_state: DoorState)

enum DoorState {
	DISABLED,
	LOCKED,
	CLOSED,
	OPENING,
	OPEN,
	CLOSING,
}

@export_category("Initial State")
@export var starts_locked: bool = false
@export var starts_open: bool = false

@export_category("Motion")
@export var open_offset: Vector3 = Vector3(2.2, 0.0, 0.0)
@export_range(0.05, 5.0, 0.05) var transition_duration: float = 0.75

@export_category("Presentation")
@export var locked_color := Color(0.82, 0.34, 0.2, 1.0)
@export var closed_color := Color(0.3, 0.7, 0.72, 1.0)
@export var open_color := Color(0.22, 0.8, 0.62, 1.0)

@onready var door_panel: AnimatableBody3D = $DoorPanel
@onready var interactable: Interactable = $Interactable
@onready var indicator_mesh: MeshInstance3D = $IndicatorMesh
@onready var indicator_light: OmniLight3D = $IndicatorLight

var state: DoorState = DoorState.CLOSED
var closed_position: Vector3
var active_tween: Tween


func _ready() -> void:
	closed_position = door_panel.position
	interactable.interacted.connect(_on_interacted)

	if starts_open:
		door_panel.position = _get_open_position()
		_set_state(DoorState.OPEN)
	elif starts_locked:
		_set_state(DoorState.LOCKED)
	else:
		_set_state(DoorState.CLOSED)


func open() -> void:
	if state != DoorState.CLOSED:
		return

	_set_state(DoorState.OPENING)
	_move_panel_to(_get_open_position(), _finish_open)


func close() -> void:
	if state != DoorState.OPEN:
		return

	_set_state(DoorState.CLOSING)
	_move_panel_to(closed_position, _finish_close)


func lock() -> void:
	if state == DoorState.DISABLED or state == DoorState.LOCKED:
		return

	_stop_motion()
	door_panel.position = closed_position
	_set_state(DoorState.LOCKED)


func unlock() -> void:
	if state != DoorState.LOCKED:
		return

	_set_state(DoorState.CLOSED)


func set_disabled() -> void:
	_stop_motion()
	_set_state(DoorState.DISABLED)


func _on_interacted(_player: Node) -> void:
	match state:
		DoorState.CLOSED:
			open()
		DoorState.OPEN:
			close()


func _move_panel_to(target_position: Vector3, completion: Callable) -> void:
	_stop_motion()
	active_tween = create_tween()
	active_tween.set_trans(Tween.TRANS_QUAD)
	active_tween.set_ease(Tween.EASE_IN_OUT)
	active_tween.tween_property(door_panel, "position", target_position, transition_duration)
	active_tween.tween_callback(completion)


func _stop_motion() -> void:
	if active_tween != null and active_tween.is_valid():
		active_tween.kill()
	active_tween = null


func _finish_open() -> void:
	_set_state(DoorState.OPEN)


func _finish_close() -> void:
	_set_state(DoorState.CLOSED)


func _get_open_position() -> Vector3:
	return closed_position + open_offset


func _set_state(next_state: DoorState) -> void:
	var previous_state := state
	state = next_state
	_update_interaction_text()
	_update_visual_state()
	if previous_state != state:
		state_changed.emit(previous_state, state)


func _update_interaction_text() -> void:
	match state:
		DoorState.LOCKED:
			interactable.interaction_text = "Locked"
		DoorState.DISABLED:
			interactable.interaction_text = "Unavailable"
		DoorState.OPEN:
			interactable.interaction_text = "Close Door"
		DoorState.CLOSED:
			interactable.interaction_text = "Open Door"
		_:
			interactable.interaction_text = "Door In Use"


func _update_visual_state() -> void:
	var color := closed_color
	if state == DoorState.LOCKED or state == DoorState.DISABLED:
		color = locked_color
	elif state == DoorState.OPEN:
		color = open_color

	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.emission_enabled = true
	material.emission = color
	material.emission_energy_multiplier = 1.4
	indicator_mesh.material_override = material
	indicator_light.light_color = color
	indicator_light.light_energy = 1.2
