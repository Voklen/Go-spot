extends Node
class_name CheckCaptures

const tile_scene = preload("res://scenes/tile.tscn")
const TileStatus = enums.TileStatus

var grid_size: int
var board: Array[Array]

func _init(new_grid_size: int) -> void:
	grid_size = new_grid_size
	board = generate_board()

## Returns an Array[Array[TileStatus]] but nested typed collections are not yet supported
func generate_board() -> Array[Array]:
	var empty_board: Array[Array] = []
	empty_board.resize(grid_size)
	
	for x in grid_size:
		empty_board[x].resize(grid_size)
		for y in grid_size:
			empty_board[x][y] = TileStatus.EMPTY
	return empty_board

func analyse_move(current_move: Vector2i) -> BoardAnalysis:
	make_move(current_move)
	var result := analyse_board(current_move)
	reset_move(current_move)
	return result

func make_move(move: Vector2i) -> void:
	if Globals.is_black_playing:
		board[move.x][move.y] = TileStatus.BLACK
	else:
		board[move.x][move.y] = TileStatus.WHITE

func reset_move(move: Vector2i) -> void:
	board[move.x][move.y] = TileStatus.EMPTY

func analyse_board(current_move: Vector2i) -> BoardAnalysis:
	var checked_statuses := generate_tile_checked_statuses()
	var to_remove: Array[Vector2i] = []
	var current_move_area: Array[Vector2i] = []
	for y in grid_size:
		for x in grid_size:
			var should_remove = get_area_to_remove(Vector2i(x, y), checked_statuses)
			if current_move in should_remove:
				current_move_area = should_remove
			else:
				to_remove.append_array(should_remove)
	return BoardAnalysis.new(to_remove, current_move_area)

func generate_tile_checked_statuses() -> Array[Array]:
	var checked_statuses: Array[Array] = []
	checked_statuses.resize(grid_size)
	for i in checked_statuses.size():
		var row: Array[bool] = []
		row.resize(grid_size)
		row.fill(false)
		checked_statuses[i] = row
	return checked_statuses

func get_area_to_remove(origin: Vector2i, checked_statuses: Array[Array]) -> Array[Vector2i]:
	if checked_statuses[origin.x][origin.y]:
		return []
	var collection: Array[Vector2i] = []
	var origin_status := tile(origin.x, origin.y)
	var to_check: Array[Vector2i] = [origin]
	for coordinate in to_check:
		var x := coordinate.x
		var y := coordinate.y
		var this_tile := tile(x,y)
		match this_tile:
			TileStatus.EMPTY: # If this territory has a liberty, stop checking and do not remove anything
				checked_statuses[x][y] = true
				return []
			TileStatus.WALL: # If this territory is against a wall, continue on checking
				continue
			origin_status: # Add any stones that are the same colour as the original one to the territory
				if coordinate in collection:
					continue
				collection.append(coordinate)
				checked_statuses[x][y] = true
				to_check.append_array(surrounding_tiles(x, y))
			_: # If this territory is against another colour, continue on checking
				continue
	# If the function has not returned at this point, that means there are no empty tiles around
	# this territory so the entire thing can be removed
	return collection

## Positive points mean black is winning, negitive mean white is winning, 0 means it's a draw
func calculate_black_points() -> int:
	var checked_statuses := generate_tile_checked_statuses()
	var black_points = 0
	for y in grid_size:
		for x in grid_size:
			black_points += points_to_black(Vector2i(x, y), checked_statuses)
	return black_points

func points_to_black(origin: Vector2i, checked_statuses: Array[Array]) -> int:
	if checked_statuses[origin.x][origin.y]:
		return 0
	var collection: Array[Vector2i] = []
	var territory_owner := TileStatus.EMPTY
	var to_check: Array[Vector2i] = [origin]
	for coordinate in to_check:
		var x := coordinate.x
		var y := coordinate.y
		var this_tile := tile(x,y)
		match this_tile:
			TileStatus.EMPTY: # Add any more empty squares to the collection
				if coordinate in collection:
					continue
				collection.append(coordinate)
				checked_statuses[x][y] = true
				to_check.append_array(surrounding_tiles(x, y))
				continue
			TileStatus.WALL: # If this territory is against a wall, continue on checking
				continue
			territory_owner: # If this empty collection is against all of the same colour, keep on checking
				checked_statuses[x][y] = true
				continue
			_: # If this territory is against another colour, continue on checking
				if territory_owner == TileStatus.EMPTY:
					territory_owner = this_tile
				else:
					return 0 # This means there are multiple territories touching this area, so nooene gets points
	# If the function has not returned at this point, that means there is only one colour
	# surrounding these empty squares, so they should get the points
	match territory_owner: 
		TileStatus.BLACK:
			return len(collection)
		TileStatus.WHITE:
			return -len(collection)
		TileStatus.EMPTY:
			# No stones are on the board
			return 0
	# This shouldn't be possible
	print("Got territory_owner as wall")
	return 0

func surrounding_tiles(x, y) -> Array[Vector2i]:
	return [
		Vector2i(x+1, y),
		Vector2i(x, y+1),
		Vector2i(x-1, y),
		Vector2i(x, y-1)
	]

func tile(x: int, y: int) -> TileStatus:
	if 0 > x or x >= grid_size or y < 0 or y >= grid_size:
		return TileStatus.WALL
	return board[x][y]
