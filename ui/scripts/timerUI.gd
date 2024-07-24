extends Control

@onready var timer_text = $TimerText

signal timer_completed

var timer : int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_tree().paused == false:
		timer_text.text = str(timer)
		if timer <= 0:
			timer_completed.emit()
			timer_text.text = "GO!"
		if timer == -2:
			self.hide()
		$Timer.paused = false
	else:
		$Timer.paused = true

func _on_timer_timeout():
	if timer >= -1:
		timer -= 1
		print(str(timer))
	else:
		$Timer.stop()
