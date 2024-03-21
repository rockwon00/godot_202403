extends CanvasLayer

@export var arena_time_manager: Node
@onready var label = $MarginContainer/Label

func _process(delta):
	if arena_time_manager == null:
		return
	var time_elapsed = arena_time_manager.get_time_elapsed()
	label.text = format_seconds_to_string(time_elapsed)

func format_seconds_to_string(seconds:float):
	var minute = floor(seconds / 60)
	var remaining_seconds = seconds - (minute * 60)
	return str(minute) + ":" + ("%02d"%floor(remaining_seconds))
