extends Node

var score1 = 0

@onready var score_label = $ScoreLabel
@onready var win_label = $WinLabel
@onready var win_label2 = $WinLabel2
@onready var lose_label = $LoseLabel

func add_point():
	score1 += 1
	score_label.text = "You Got " + str(score1) + "/37 coins!"
	if score1 < 37:
		win_label.visible = false
		win_label2.visible = true
		lose_label.visible = false
	if score1 >= 37:
		win_label.visible = true
		win_label2.visible = false
		lose_label.visible = false



func _ready():
	win_label.visible = false
	win_label2.visible = false
	lose_label.visible = true

func _process(_delta):
	pass
