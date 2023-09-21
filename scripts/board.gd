class_name Board
extends GridContainer

signal game_over_popup(text)

const TileStatus = enums.TileStatus
const tile_scene = preload("res://scenes/tile.tscn")
@onready var check_captures := CheckCaptures.new(grid_size)

@export
var grid_size := 9

func _ready() -> void:
	self.columns = grid_size
	for i in grid_size**2:
		var instance := tile_scene.instantiate()
		add_child(instance)

func move_played(to_remove: Array[Vector2i]) -> void:
	Globals.is_black_playing = !Globals.is_black_playing
	Globals.player_just_passed = false
	for coordinate in to_remove:
		tile_node(coordinate).make_empty()
		check_captures.reset_move(coordinate)

func tile_node(vec: Vector2i) -> Tile:
	return get_child(vec.x + vec.y*grid_size)

func end_game():
	var black_ponts = check_captures.calculate_black_points()
	if black_ponts > 0:
		game_over_popup.emit("Black wins")
	elif black_ponts < 0:
		game_over_popup.emit("White wins")
	else:
		game_over_popup.emit("It's a draw")
