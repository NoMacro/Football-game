extends Control

signal start_pressed

const ACTION_START : StringName = &"start"

var has_been_pressed : bool = false

func _unhandled_input(event: InputEvent) -> void:
	if has_been_pressed:
		return
	
	if event.is_action_pressed(ACTION_START):
		has_been_pressed = true
		start_pressed.emit()
