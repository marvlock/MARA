class_name TerminalNarrativeTrigger
extends Node

## Records a narrative discovery when an associated reusable terminal is opened.

@export var terminal_path: NodePath = NodePath("..")
@export var discovery_flag: StringName

var terminal: Terminal


func _ready() -> void:
	terminal = get_node_or_null(terminal_path) as Terminal
	if terminal == null:
		push_error("TerminalNarrativeTrigger requires a Terminal at terminal_path.")
		return

	terminal.terminal_opened.connect(_on_terminal_opened)


func _on_terminal_opened() -> void:
	if discovery_flag.is_empty() or NarrativeState.has_flag(discovery_flag):
		return

	NarrativeState.set_flag(discovery_flag)
