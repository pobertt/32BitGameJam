extends Control

@onready var lap_text = $LapText


# Called when the node enters the scene tree for the first time.
func _ready():
	lap_text.text = str(GameManager.laps) + "/3"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.laps <= 3:
		lap_text.text = str(GameManager.laps) + "/3"
	else:
		lap_text.text = "3/3"
