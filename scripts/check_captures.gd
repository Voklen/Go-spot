class_name CheckCaptures

const tile_scene = preload("res://scenes/tile.tscn")
const TileStatus = enums.TileStatus

var grid_size: int
var board: Array[Array] # Array[Array[Node]] but nested typed collections are not supported

func _init(new_grid_size: int) -> void:
	grid_size = new_grid_size

func analyse_board(new_board: Array[Array]) -> Array[Vector2i]:
	board = new_board
	var checked_statuses := generate_tile_checked_statuses()
	var to_remove: Array[Vector2i] = []
	for y in grid_size:
		for x in grid_size:
			if should_remove(x, y, checked_statuses):
				to_remove.append(Vector2i(x, y))
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
	

func should_remove(origin_x: int, origin_y: int, checked_statuses) -> bool:
	var collection: Array[Vector2i] = []
	var origin_status := tile(origin_x, origin_y)
	var to_check: Array[Vector2i] = [Vector2i(origin_x, origin_y)]
	for coordinate in to_check:
		var x := coordinate.x
		var y := coordinate.y
		var this_tile := tile(x,y)
		match this_tile:
			TileStatus.EMPTY:
				checked_statuses[x][y] = true
				return false
			TileStatus.WALL:
				continue
			origin_status:
				if coordinate in collection:
					continue
				collection.append(coordinate)
				checked_statuses[x][y] = true
				var surrounding_tiles = [
					Vector2i(x+1, y),
					Vector2i(x, y+1),
					Vector2i(x-1, y),
					Vector2i(x, y-1)
				]
				to_check.append_array(surrounding_tiles)
			_:
				continue
	return true

func tile(x: int, y: int) -> TileStatus:
	return board[x+1][y+1]
