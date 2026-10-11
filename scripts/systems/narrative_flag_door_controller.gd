class_name NarrativeFlagDoorController
extends Node

## Unlocks and optionally opens a reusable SlidingDoor after a narrative discovery.

@export var door_path: NodePath = NodePath("..")
@export var required_flag: StringName
@export var open_when_unlocked: bool = true

var door: SlidingDoor


func _ready() -> void:
	door = get_node_or_null(door_path) as SlidingDoor
	if door == null:
		push_error("NarrativeFlagDoorController requires a SlidingDoor at door_path.")
		return

	NarrativeState.flag_changed.connect(_on_flag_changed)
	call_deferred("_evaluate_flag")


func _on_flag_changed(flag: StringName, enabled: bool) -> void:
	if flag == required_flag and enabled:
		_unlock_route()


func _evaluate_flag() -> void:
	if NarrativeState.has_flag(required_flag):
		_unlock_route()


func _unlock_route() -> void:
	door.unlock()
	if open_when_unlocked:
		door.open()
