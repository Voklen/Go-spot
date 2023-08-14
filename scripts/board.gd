extends GridContainer

const TileStatus = enums.TileStatus
const tile_scene = preload("res://scenes/tile.tscn")

@export
var grid_size = 9

var board: Array[Array] # Array[Array[Node]] but nested typed collections are not supported
var is_black_playing = true

func _ready():
	self.columns = grid_size
	for i in grid_size**2:
		var instance = tile_scene.instantiate()
		add_child(instance)

func move_played():
	is_black_playing = !is_black_playing
	set_board()
	analyse_board(board)

func set_board():
	var one_d = get_children()
	board.resize(grid_size)
	for i in grid_size:
		board[i] = one_d.slice(i*grid_size, (i+1)*grid_size)

func analyse_board(board: Array[Array]):
	var checked_tiles = []
	for y in grid_size:
		for x in grid_size:
			if [x, y] in checked_tiles:
				continue
			var this_tile = tile(x,y)
			if this_tile.status == TileStatus.EMPTY:
				checked_tiles.append([x,y])
				continue
			var surrounding_tiles = [
				tile(x+1, y).status,
				tile(x, y+1).status,
				tile(x-1, y).status,
				tile(x, y-1).status
			]
			if not TileStatus.EMPTY in surrounding_tiles and not this_tile.status in surrounding_tiles:
				this_tile.make_empty()
				continue

func tile(x: int, y: int) -> TextureButton:
	if x < 0 or x >= grid_size or y < 0 or y >= grid_size:
		return tile_scene.instantiate()
	return board[y][x]
