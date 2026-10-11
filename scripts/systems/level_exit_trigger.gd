class_name LevelExitTrigger
extends Area3D

## Reusable level-boundary trigger for short vertical-slice transitions.

signal exit_reached

@export var completion_flag: StringName
@export var heading: String = "SECTOR ACCESS AVAILABLE"
@export_multiline var message: String = "Route to the habitation sector is available."

@onready var heading_label: Label = $CompletionScreen/Center/Panel/Margin/Content/Heading
@onready var message_label: Label = $CompletionScreen/Center/Panel/Margin/Content/Message
@onready var completion_screen: CanvasLayer = $CompletionScreen

var has_been_reached := false


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	completion_screen.hide()


func _on_body_entered(body: Node3D) -> void:
	if has_been_reached or not (body is PlayerController):
		return

	has_been_reached = true
	if not completion_flag.is_empty():
		NarrativeState.set_flag(completion_flag)

	heading_label.text = heading
	message_label.text = message
	completion_screen.show()
	exit_reached.emit()
