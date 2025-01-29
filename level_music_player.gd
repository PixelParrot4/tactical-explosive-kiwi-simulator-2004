extends AudioStreamPlayer

@onready var EndScreen = $"../CameraAndUI/UI/EndScreen"

func _process(_delta: float):
	if EndScreen.visible == true:
		playing = false
