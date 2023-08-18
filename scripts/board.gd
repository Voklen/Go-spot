class_name Board
extends GridContainer

const TileStatus = enums.TileStatus
const tile_scene = preload("res://scenes/tile.tscn")

@export
var grid_size := 9

var is_black_playing := true

func _ready() -> void:
	self.columns = grid_size
	for i in grid_size**2:
		var instance := tile_scene.instantiate()
		add_child(instance)

func move_played(x: int, y: int) -> void:
	is_black_playing = !is_black_playing
	var board := set_board()
	var check_captures := CheckCaptures.new(grid_size)
	var to_remove := check_captures.analyse_board(board)
	for coordinate in to_remove:
		var remove_x: int = coordinate[0]
		var remove_y: int = coordinate[1]
		if remove_x == x and remove_y == y:
			continue
		tile_node(remove_x, remove_y).make_empty()

func set_board() -> Array[Array]:
	# This will set up a 2D array that looks like this:
	# #####
	# #XO-#
	# #X-O#
	# #-XO#
	# #####
	# X = black
	# O = white
	# # = wall
	# - = empty
	var board: Array[Array] = []
	board.resize(grid_size + 2)
	for row in [0, -1]:
		board[row] = []
		board[row].resize(grid_size + 2)
		board[row].fill(TileStatus.WALL)
	
	for x in grid_size:
		board[x+1].resize(grid_size + 2)
		board[x+1][0] = TileStatus.WALL
		board[x+1][-1] = TileStatus.WALL
		for y in grid_size:
			board[x+1][y+1] = tile_node(x, y).status
	return board

func tile_node(x: int, y: int) -> Tile:
	return get_child(x + y*grid_size)
