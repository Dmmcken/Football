extends Node2D



func _ready():
	pass

func _on_button_pressed():
	var current_scene = get_tree().current_scene
	current_scene.queue_free()
	var team_select_scene = load("res://TeamSelect.tscn")
	var team_select_instance = team_select_scene.instantiate()
	get_tree().root.add_child(team_select_instance)
	get_tree().current_scene = team_select_instance
