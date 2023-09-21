extends Button

signal end_game

func _on_pressed():
	if Globals.player_just_passed:
		end_game.emit()
	Globals.is_black_playing = !Globals.is_black_playing
	Globals.player_just_passed = true
