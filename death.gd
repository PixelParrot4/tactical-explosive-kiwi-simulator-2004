extends Area2D
@export var death_message:String="d u m b a s s"

func _on_body_entered(body: Node2D) -> void:
	if body is player:
		$Timer.start()
		$"../CameraAndUI/UI/Death".text=str(death_message)
		$"../CameraAndUI/UI/Death".visible = true

func _on_timer_timeout() -> void:
#makes kiwi explode, isnt done directly bcs otherwise itd blow up twice
	if $"../Player".times_timer_timedout < 2:
		$"../Player".times_timer_timedout = 2
		$"../Player/Fuse".stop()
		$"../Player".explode()
