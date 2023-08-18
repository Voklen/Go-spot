extends TextureButton

const TileStatus = enums.TileStatus

var status = TileStatus.EMPTY

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	if status != TileStatus.EMPTY:
		return
	if get_parent().is_black_playing:
		self.texture_normal = load("res://assets/images/black.svg")
		status = TileStatus.BLACK
		move_played()
	else:
		self.texture_normal = load("res://assets/images/white.svg")
		status = TileStatus.WHITE
		move_played()

func move_played():
	var parent = get_parent()
	var index = get_index()
	var x = index % parent.grid_size
	var y = index / parent.grid_size
	parent.move_played(x, y)

func make_empty():
	status = TileStatus.EMPTY
	self.texture_normal = load("res://assets/images/empty.svg")
