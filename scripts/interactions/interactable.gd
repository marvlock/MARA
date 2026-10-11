class_name Interactable
extends Node

## Reusable component for any object that can be targeted by InteractionSystem.
## Add this as a child of the object's collision node, then connect `interacted`
## from the owning scene to provide its behavior.

signal interacted(player: Node)

@export var interaction_text: String = "Interact"


func get_interaction_text() -> String:
	return interaction_text


func interact(player: Node) -> void:
	interacted.emit(player)
