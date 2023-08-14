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
	var parent = get_parent();
	if parent.is_black_playing:
		self.texture_normal = load("res://assets/images/black.svg")
		status = TileStatus.BLACK
		parent.move_played()
	else:
		self.texture_normal = load("res://assets/images/white.svg")
		status = TileStatus.WHITE
		parent.move_played()

func make_empty():
	status = TileStatus.EMPTY
	self.texture_normal = load("res://assets/images/empty.svg")
