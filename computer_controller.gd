extends CharacterBody2D

var cur_button = ""


func _on_exit_menu_mouse_entered() -> void:
	cur_button = "exit"
	print("exit")
	pass # Replace with function body.
	
func _process(delta):
	return


		
func _input(event):
	if (event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT):
		if cur_button == "exit":
			get_tree().change_scene_to_file("res://scene1.tscn")

func _on_exit_menu_mouse_exited() -> void:
	cur_button = ""
	pass # Replace with function body.
