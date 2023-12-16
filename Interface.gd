extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	%MenuButton.pressed.connect(func():
		%Menu.visible = true
	)
	%Close.pressed.connect(func():
		get_tree().quit()
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
