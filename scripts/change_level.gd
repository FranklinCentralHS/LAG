extends Node

var score2 = 0

func add_point():
	score2 += 1
	pass

func _ready():
	print(get_tree().current_scene.name)

func _process(_delta):
	if Input.is_action_just_pressed("change_level") and get_tree().current_scene.name == "GameLevel1":
		if score2 >= 37:
			get_tree().change_scene_to_file("res://scenes/game_level_2.tscn")


