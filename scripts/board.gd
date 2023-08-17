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
	var check_captures = CheckCaptures.new(grid_size)
	check_captures.analyse_board(board)

func set_board():
	var one_d = get_children()
	board.resize(grid_size)
	for i in grid_size:
		board[i] = one_d.slice(i*grid_size, (i+1)*grid_size)
