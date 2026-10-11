class_name InteractionPrompt
extends CanvasLayer

@onready var label: Label = $Prompt/Panel/Label


func show_prompt(interaction_text: String) -> void:
	label.text = "E - %s" % interaction_text
	$Prompt.show()


func hide_prompt() -> void:
	$Prompt.hide()
