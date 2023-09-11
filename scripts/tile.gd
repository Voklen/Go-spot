class_name Tile
extends TextureButton

const TileStatus = enums.TileStatus

@onready var parent: Board = get_parent()
@onready var coordinates: Vector2i = get_coordinates()
var status := TileStatus.EMPTY

func _on_pressed() -> void:
	if status != TileStatus.EMPTY:
		return
	var to_remove = get_to_remove()
	if is_valid_move(to_remove):
		set_status_and_texture()
		parent.move_played(to_remove)

func get_to_remove() -> Array[Vector2i]:
	var board := parent.generate_board()
	if parent.is_black_playing:
		board[coordinates.x + 1][coordinates.y + 1] = TileStatus.BLACK
	else:
		board[coordinates.x + 1][coordinates.y + 1] = TileStatus.WHITE
	var check_captures := CheckCaptures.new(parent.grid_size)
	return check_captures.analyse_board(board)

func is_valid_move(to_remove: Array[Vector2i]) -> bool:
	if coordinates in to_remove:
		return false
	return true

func set_status_and_texture() -> void:
	if parent.is_black_playing:
		self.texture_normal = load("res://assets/images/black.svg")
		status = TileStatus.BLACK
	else:
		self.texture_normal = load("res://assets/images/white.svg")
		status = TileStatus.WHITE

func make_empty() -> void:
	status = TileStatus.EMPTY
	self.texture_normal = load("res://assets/images/empty.svg")

func get_coordinates() -> Vector2i:
	var index := get_index()
	var x := index % parent.grid_size
	var y := index / parent.grid_size
	return Vector2i(x, y)
