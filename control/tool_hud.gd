extends Control

const ACTIVE_COLOR: Color = Color(1.0, 1.0, 0.0)
const INACTIVE_COLOR: Color = Color(1.0, 1.0, 1.0)

@onready var name_label: Label = $name_label
@onready var description_label: Label = $description_label

@export var active: bool = false:
	set(value):
		active = value
		name_label.modulate = ACTIVE_COLOR if active else INACTIVE_COLOR
		description_label.visible = active

func set_tool_name(value):
	name_label.text = value

func set_tool_description(value):
	description_label.text = value
