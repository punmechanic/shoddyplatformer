extends Control

func _ready() -> void:
	%MenuButton.pressed.connect(func(): %Menu.visible = true)
	%Close.pressed.connect(func(): get_tree().quit())

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		%Menu.visible = not %Menu.visible
