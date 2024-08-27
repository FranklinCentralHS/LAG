extends Area2D




func _on_body_entered(body:Node2D):
	print("coin collected")
	queue_free()