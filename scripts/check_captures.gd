class_name CheckCaptures

const tile_scene = preload("res://scenes/tile.tscn")
const TileStatus = enums.TileStatus

var grid_size: int
var board: Array[Array] # Array[Array[Node]] but nested typed collections are not supported

func _init(new_grid_size: int) -> void:
	grid_size = new_grid_size

func analyse_board(new_board: Array[Array]) -> Array[Array]:
	board = new_board
	var checked_statuses := generate_tile_checked_statuses()
	var checked_tiles = []
	var to_remove = []
	for y in grid_size:
		for x in grid_size:
			if should_remove(x, y, checked_tiles, board, checked_statuses):
				to_remove.append([x,y])
	return to_remove

func generate_tile_checked_statuses() -> Array[Array]:
	var checked_statuses: Array[Array] = []
	checked_statuses.resize(grid_size)
	for i in checked_statuses.size():
		var row: Array[bool] = []
		row.resize(grid_size)
		row.fill(false)
		checked_statuses[i] = row
	return checked_statuses
	

func should_remove(x, y, checked_tiles, board, checked_statuses) -> bool:
	if checked_statuses[x][y]:
		return false
	var this_tile = tile(x,y)
	if this_tile == TileStatus.EMPTY:
		checked_tiles.append([x,y])
		return false
	var surrounding_tiles = [
		tile(x+1, y),
		tile(x, y+1),
		tile(x-1, y),
		tile(x, y-1)
	]
	if not TileStatus.EMPTY in surrounding_tiles and not this_tile in surrounding_tiles:
		return true
	return false

func tile(x: int, y: int) -> TileStatus:
	return board[x+1][y+1]
