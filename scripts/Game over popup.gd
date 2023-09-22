extends ColorRect

func display_popup(text):
	var label: Label = $ Tile/Contents/Winner
	label.text = text
	show()

func back_to_main_menu():
	Globals.is_black_playing = true
	Globals.player_just_passed = false
	get_parent().queue_free()
