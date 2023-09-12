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

func move_played(to_remove: Array[Vector2i]) -> void:
	is_black_playing = !is_black_playing
	for coordinate in to_remove:
		tile_node(coordinate).make_empty()

func generate_board() -> Array[Array]:
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
	board.resize(grid_size)
	
	for x in grid_size:
		board[x].resize(grid_size)
		for y in grid_size:
			board[x][y] = tile_node(Vector2i(x, y)).status
	return board

func tile_node(vec: Vector2i) -> Tile:
	return get_child(vec.x + vec.y*grid_size)
