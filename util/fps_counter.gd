extends Label

func _process(_delta: float) -> void:
	set_text("FPS: " + str(Engine.get_frames_per_second()))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() and event.is_action("toggle_fps_counter"):
		visible = !visible
