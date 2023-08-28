class_name Tile
extends TextureButton

const TileStatus = enums.TileStatus

var parent: Board
var status := TileStatus.EMPTY

func _ready():
	parent = get_parent()

#TODO cleanup this function
func _on_pressed() -> void:
	if status != TileStatus.EMPTY:
		return
	var this_tile = get_coordinates()
	var board := parent.generate_board()
	if parent.is_black_playing:
		board[this_tile.x + 1][this_tile.y + 1] = TileStatus.BLACK
	else:
		board[this_tile.x + 1][this_tile.y + 1] = TileStatus.WHITE
	var check_captures := CheckCaptures.new(parent.grid_size)
	var to_remove := check_captures.analyse_board(board)
	if this_tile in to_remove:
		return
	if parent.is_black_playing:
		self.texture_normal = load("res://assets/images/black.svg")
		status = TileStatus.BLACK
		parent.move_played(to_remove)
	else:
		self.texture_normal = load("res://assets/images/white.svg")
		status = TileStatus.WHITE
		parent.move_played(to_remove)

func get_coordinates() -> Vector2i:
	var index := get_index()
	var x := index % parent.grid_size
	var y := index / parent.grid_size
	return Vector2i(x, y)

func make_empty() -> void:
	status = TileStatus.EMPTY
	self.texture_normal = load("res://assets/images/empty.svg")
