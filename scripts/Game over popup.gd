extends Popup

func display_popup(text):
	var label: Label = $ Contents/Winner
	label.text = text
	popup()

func _on_popup_hide():
	back_to_main_menu()

func _on_ok_pressed():
	back_to_main_menu()

func back_to_main_menu():
	Globals.is_black_playing = true
	Globals.player_just_passed = false
	get_parent().queue_free()
