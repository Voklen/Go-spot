class_name Tile
extends TextureButton

const TileStatus = enums.TileStatus

@onready var parent: Board = get_parent()
@onready var coordinates: Vector2i = get_coordinates()
var status := TileStatus.EMPTY

func _on_pressed() -> void:
	if status != TileStatus.EMPTY:
		return
	var analysis := board_analysis_for_move()
	if is_valid_move(analysis):
		set_status_and_texture()
		parent.move_played(analysis.to_remove)

func board_analysis_for_move() -> BoardAnalysis:
	var board := parent.generate_board()
	if parent.is_black_playing:
		board[coordinates.x][coordinates.y] = TileStatus.BLACK
	else:
		board[coordinates.x][coordinates.y] = TileStatus.WHITE
	var check_captures := CheckCaptures.new(parent.grid_size)
	return check_captures.analyse_board(board, coordinates)

## Checks if a stone will be removed as soon as it is placed
func is_valid_move(analysis: BoardAnalysis) -> bool:
	if analysis.to_remove.is_empty():
		if analysis.current_move_area.is_empty():
			# This stone is not removing any stones and is not being removed
			return true
		else:
			# This stone is being removed but is not removing any other stones
			return false
	# This stone is removing other stones so it either has liberties or will gain them
	# when it is placed
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
