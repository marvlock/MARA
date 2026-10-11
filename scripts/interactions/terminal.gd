class_name Terminal
extends StaticBody3D

## Reusable powered terminal. Content remains data-driven at the call site later;
## this first version establishes power gating and a minimal readable interface.

signal terminal_opened
signal terminal_closed

@export var starts_powered: bool = false
@export_multiline var boot_message: String = "ARK-7 DOCKING TERMINAL\n\nSYSTEM BOOT COMPLETE\nLOCAL POWER: STABLE\n\nAwaiting operator input."

@onready var interactable: Interactable = $Interactable
@onready var status_mesh: MeshInstance3D = $StatusMesh
@onready var status_light: OmniLight3D = $StatusLight
@onready var screen_label: Label3D = $ScreenLabel
@onready var terminal_screen: CanvasLayer = $TerminalScreen
@onready var terminal_text: Label = $TerminalScreen/Center/Panel/Margin/Text

var is_powered := false
var is_open := false


func _ready() -> void:
	interactable.interacted.connect(_on_interacted)
	terminal_screen.hide()
	set_powered(starts_powered)


func set_powered(value: bool) -> void:
	is_powered = value
	if not is_powered:
		set_terminal_open(false)
	_update_status()


func set_terminal_open(value: bool) -> void:
	if value and not is_powered:
		return
	if is_open == value:
		return

	is_open = value
	terminal_screen.visible = is_open
	_update_status()
	if is_open:
		terminal_opened.emit()
	else:
		terminal_closed.emit()


func _on_interacted(_player: Node) -> void:
	if not is_powered:
		return

	set_terminal_open(not is_open)


func _update_status() -> void:
	var color := Color(0.75, 0.3, 0.18, 1.0)
	if is_powered:
		color = Color(0.32, 0.82, 0.82, 1.0)

	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.emission_enabled = true
	material.emission = color
	material.emission_energy_multiplier = 1.3
	status_mesh.material_override = material
	status_light.light_color = color
	status_light.light_energy = 1.15 if is_powered else 0.25

	if not is_powered:
		interactable.interaction_text = "Terminal Offline"
		screen_label.text = "NO POWER"
	elif is_open:
		interactable.interaction_text = "Close Terminal"
		screen_label.text = "ACTIVE"
	else:
		interactable.interaction_text = "Access Terminal"
		screen_label.text = "READY"

	terminal_text.text = boot_message
