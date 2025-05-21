extends Node2D

var retiring_players = []

func _ready():
	populate_retire_list("RetireScroll/CenterContainer/RetireBox")

func populate_retire_list(container_path):
	var container = get_node(container_path)
	for child in container.get_children():
		child.queue_free()
	var retire_array = []
	for player in retiring_players:
		retire_array.append(player)
	sort_position(retire_array)
	for player in retire_array:
		var button_text = "%s %s %s OVR %d Age %d Potential %d" % [player["Position"], player["FirstName"], player["LastName"], player["Rating"], player["Age"], player["Potential"]]
		var player_button = Button.new()
		player_button.text = button_text
		player_button.name = player["PlayerID"]
		container.add_child(player_button)

func compare_by_rating(player1, player2):
	if player1["Rating"] >= player2["Rating"]:
		return true
	else:
		return false

func sort_position(position_group):
	position_group.sort_custom(compare_by_rating)

func _on_continue_pressed():
	get_tree().current_scene.queue_free()
