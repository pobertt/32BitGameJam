extends Control

var total_time : int = -3

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()

func _on_timer_timeout():
	total_time += 1
	if total_time >= 0:
		var m = int(total_time / 60.0)
		var s = total_time - m * 60
		$TimerText.text = "%02d:%02d" % [m, s]
