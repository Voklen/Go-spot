extends Popup

func display_popup(text):
	$ Label.text = text
	popup()

func _on_popup_hide():
	get_parent().queue_free()
