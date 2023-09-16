extends Button

var simultaneous_scene = preload("res://scenes/playing_screen.tscn").instantiate()

func _on_pressed():
	get_tree().root.add_child(simultaneous_scene)
