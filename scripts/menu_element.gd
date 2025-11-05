extends PanelContainer

func _on_texture_button_mouse_entered() -> void:
	var styleBox = get_theme_stylebox("panel")
	styleBox.bg_color =  Color.from_rgba8(0x3f, 0x3f, 0x3f)
	add_theme_stylebox_override("panel", styleBox)

func _on_texture_button_mouse_exited() -> void:
	var styleBox = get_theme_stylebox("panel")
	styleBox.bg_color =  Color.from_rgba8(0x2e, 0x2e, 0x2e)
	add_theme_stylebox_override("panel", styleBox)
