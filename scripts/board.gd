extends GridContainer

const grid_size = 5

var tile = preload("res://scenes/tile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.columns = grid_size
	print(grid_size**2)
	for i in grid_size**2:
		var instance = tile.instantiate()
		add_child(instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
