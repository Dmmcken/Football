extends Node2D

var roster_data = []
var game_simulator = GameSimulator.new()
var game_play = GamePlay.new()

func _ready():
	add_child(game_simulator)
	add_child(game_play)
	var roster_file = FileAccess.open("res://JSON Files/Rosters.json", FileAccess.READ)
	var roster_json = JSON.new()
	roster_json.parse(roster_file.get_as_text())
	roster_file.close()
	roster_data = roster_json.get_data()
	populate_list("homescroll/homevbox", true)
	populate_list("awayscroll/awayvbox", false)

func calculate_team_averages(team_roster):
	var total_offense = 0
	var total_defense = 0
	var total_special_teams = 0
	var count_offense = 0
	var count_defense = 0
	var count_special_teams = 0
	
	for player_key in team_roster.keys():
		var player = team_roster[player_key]
		var rating = player.get("Rating", 0)
		
		match player.get("Side", ""):
			"Offense":
				total_offense += rating
				count_offense += 1
			"Defense":
				total_defense += rating
				count_defense += 1
			"ST":
				total_special_teams += rating
				count_special_teams += 1
	var avg_offense = total_offense / max(count_offense, 1)
	var avg_defense = total_defense / max(count_defense, 1)
	var avg_special_teams = total_special_teams / max(count_special_teams, 1)
	var team_ovr = (avg_offense + avg_defense + avg_special_teams) /3
	return {
			"Offense_Ovr": avg_offense,
			"Defense_Ovr": avg_defense,
			"Special_Teams_Ovr": avg_special_teams,
			"Team_Ovr": team_ovr
		}

func populate_list(container_path, is_left_list):
	var vbox = get_node(container_path)

	for team_key in roster_data.keys():
		var team_roster = roster_data[team_key]
		var team_averages = calculate_team_averages(team_roster)
		var team_name = team_key.replace("Roster", "")
		var team_entry = create_team_entry(team_name, team_averages)
		team_entry.gui_input.connect(_on_TeamEntry_gui_input.bind(team_name, is_left_list))
		vbox.add_child(team_entry)
		
func _on_TeamEntry_gui_input(event, team_name, is_left_list):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		on_team_selected(team_name, is_left_list)

func create_team_entry(team_name, team_averages):
	var hbox = HBoxContainer.new()
	var team_label = Label.new()
	team_label.text = "%s - Offense: %d, Defense: %d, Special Teams: %d, Overall: %d" % [team_name, team_averages["Offense_Ovr"], team_averages["Defense_Ovr"], team_averages["Special_Teams_Ovr"], team_averages["Team_Ovr"]]
	hbox.add_child(team_label)
	
	hbox.mouse_filter = Control.MOUSE_FILTER_STOP
	hbox.name = team_name

	return hbox
	
func on_team_selected(team_name, is_left_list):
	if is_left_list:
		$SelectedTeamLeft.text = team_name
	else:
		$SelectedTeamRight.text = team_name

func _on_play_button_pressed():
	var game_ui_scene = load("res://gameplay.tscn")
	var ui_scene_instance = game_ui_scene.instantiate()
	get_tree().current_scene.visible = false
	get_tree().root.add_child(ui_scene_instance)
	get_tree().current_scene = ui_scene_instance
	var team_left_name = $SelectedTeamLeft.text
	var team_right_name = $SelectedTeamRight.text
	if team_left_name.strip_edges() != "" and team_right_name.strip_edges() != "":
		var team_left_key = team_left_name
		var team_right_key = team_right_name
		var team_left_roster = roster_data.get(team_left_key, {})
		var team_right_roster = roster_data.get(team_right_key, {})
		game_simulator.simulate_game(team_left_roster, team_right_roster, team_left_name, team_right_name, ui_scene_instance)
	else:
		print("Please select two teams")

func _on_play_game_button_pressed():
	var game_ui_scene = load("res://gameplay.tscn")
	var ui_scene_instance = game_ui_scene.instantiate()
	get_tree().current_scene.visible = false
	get_tree().root.add_child(ui_scene_instance)
	get_tree().current_scene = ui_scene_instance
	ui_scene_instance.connect("run_button_pressed", game_play._on_run_pressed)
	ui_scene_instance.connect("short_pass_button_pressed", game_play._on_short_pass_pressed)
	ui_scene_instance.connect("medium_pass_button_pressed", game_play._on_medium_pass_pressed)
	ui_scene_instance.connect("long_pass_button_pressed", game_play._on_long_pass_pressed)
	ui_scene_instance.connect("field_goal_button_pressed", game_play._on_field_goal_pressed)
	ui_scene_instance.connect("punt_button_pressed", game_play._on_punt_pressed)
	var team_left_name = $SelectedTeamLeft.text
	var team_right_name = $SelectedTeamRight.text
	if team_left_name.strip_edges() != "" and team_right_name.strip_edges() != "":
		var team_left_key = team_left_name
		var team_right_key = team_right_name
		var team_left_roster = roster_data.get(team_left_key, {})
		var team_right_roster = roster_data.get(team_right_key, {})
		game_play.simulate_game(team_left_roster, team_right_roster, team_left_name, team_right_name, ui_scene_instance)
	else:
		print("Please select two teams")
