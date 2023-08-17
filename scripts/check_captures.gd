class_name CheckCaptures

const tile_scene = preload("res://scenes/tile.tscn")
const TileStatus = enums.TileStatus

var grid_size
var board

func _init(new_grid_size: int):
	grid_size = new_grid_size

func analyse_board(new_board: Array[Array]):
	board = new_board
	var checked_statuses = generate_tile_checked_statuses()
	var checked_tiles = []
	for y in grid_size:
		for x in grid_size:
			remove_necessary(x, y, checked_tiles, board)

func generate_tile_checked_statuses() -> Array:
	var checked_statuses = []
	checked_statuses.resize(grid_size)
	for i in checked_statuses.size():
		var row = []
		row.resize(grid_size)
		row.fill(false)
		checked_statuses[i] = row
	return checked_statuses
	

func remove_necessary(x, y, checked_tiles, board):
	if [x, y] in checked_tiles:
		return
	var this_tile = tile(x,y)
	if this_tile.status == TileStatus.EMPTY:
		checked_tiles.append([x,y])
		return
	var surrounding_tiles = [
		tile(x+1, y).status,
		tile(x, y+1).status,
		tile(x-1, y).status,
		tile(x, y-1).status
	]
	if not TileStatus.EMPTY in surrounding_tiles and not this_tile.status in surrounding_tiles:
		this_tile.make_empty()
		return

func tile(x: int, y: int) -> TextureButton:
	if x < 0 or x >= grid_size or y < 0 or y >= grid_size:
		var instance = tile_scene.instantiate()
		instance.status = TileStatus.WALL
		return instance
	return board[y][x]
