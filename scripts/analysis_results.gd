class_name BoardAnalysis

var to_remove: Array[Vector2i]
var current_move_area: Array[Vector2i]

func _init(init_to_remove: Array[Vector2i], init_current_move_area: Array[Vector2i]):
	to_remove = init_to_remove
	current_move_area = init_current_move_area
