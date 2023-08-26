class_name Tile
extends TextureButton

const TileStatus = enums.TileStatus

var parent: Board
var status := TileStatus.EMPTY

func _ready():
	parent = get_parent()

func _on_pressed() -> void:
	if status != TileStatus.EMPTY:
		return
	if parent.is_black_playing:
		self.texture_normal = load("res://assets/images/black.svg")
		status = TileStatus.BLACK
		move_played()
	else:
		self.texture_normal = load("res://assets/images/white.svg")
		status = TileStatus.WHITE
		move_played()

func move_played() -> void:
	var index := get_index()
	var x := index % parent.grid_size
	var y := index / parent.grid_size
	parent.move_played(x, y)

func make_empty() -> void:
	status = TileStatus.EMPTY
	self.texture_normal = load("res://assets/images/empty.svg")
