extends GridContainer

@export
var grid_size = 9

var is_black_playing = true

const tile = preload("res://scenes/tile.tscn")
func _ready():
	self.columns = grid_size
	for i in grid_size**2:
		var instance = tile.instantiate()
		add_child(instance)

func move_played():
	is_black_playing = !is_black_playing

