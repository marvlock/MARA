class_name InteractionSystem
extends Node

## Detects Interactable components with a camera-mounted raycast and routes the
## configured input action to the selected component.

@export var raycast_path: NodePath
@export var prompt_path: NodePath

var current_interactable: Interactable

@onready var raycast: RayCast3D = get_node_or_null(raycast_path) as RayCast3D
@onready var prompt: InteractionPrompt = get_node_or_null(prompt_path) as InteractionPrompt


func _ready() -> void:
	if raycast == null:
		push_error("InteractionSystem requires a RayCast3D assigned through raycast_path.")
		set_physics_process(false)
		return

	if prompt == null:
		push_error("InteractionSystem requires an InteractionPrompt assigned through prompt_path.")
		return

	prompt.hide_prompt()


func _physics_process(_delta: float) -> void:
	if raycast == null or prompt == null:
		return

	raycast.force_raycast_update()
	_set_current_interactable(_find_interactable(raycast.get_collider()))


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and current_interactable != null:
		current_interactable.interact(get_parent())
		get_viewport().set_input_as_handled()


func _set_current_interactable(next_interactable: Interactable) -> void:
	if current_interactable == next_interactable:
		return

	current_interactable = next_interactable
	if current_interactable == null:
		prompt.hide_prompt()
		return

	prompt.show_prompt(current_interactable.get_interaction_text())


func _find_interactable(collider: Object) -> Interactable:
	var node := collider as Node
	while node != null:
		if node is Interactable:
			return node as Interactable

		var component := node.get_node_or_null("Interactable") as Interactable
		if component != null:
			return component

		node = node.get_parent()

	return null
