extends Node2D

var roster_data = []
var selected_team = ""

func _ready():
	var roster_file = FileAccess.open("res://JSON Files/Team_Rosters.json", FileAccess.READ)
	var roster_json = JSON.new()
	roster_json.parse(roster_file.get_as_text())
	roster_file.close()
	roster_data = roster_json.get_data()
	populate_list("TeamOptions/Teams", true)

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
		on_team_selected(team_name)

func create_team_entry(team_name, team_averages):
	var hbox = HBoxContainer.new()
	var team_label = Label.new()
	team_label.text = team_name
	hbox.add_child(team_label)
	
	hbox.mouse_filter = Control.MOUSE_FILTER_STOP
	hbox.name = team_name

	return hbox
	
func on_team_selected(team_name):
	$Selected.text = team_name

var player_team = ""



func _on_team_select_pressed():
	if selected_team != "":
		GameData.set_selected_team_name(selected_team)
		var game_ui_scene = load("res://OC.tscn")
		var ui_scene_instance = game_ui_scene.instantiate()
		get_tree().current_scene.visible = false
		get_tree().root.add_child(ui_scene_instance)
		get_tree().current_scene = ui_scene_instance

var first_names = []
var last_names = []

func load_first_names():
	var file = FileAccess.open("res://JSON Files/FirstNames.json", FileAccess.READ)
	var first_names_data = JSON.new()
	first_names_data.parse(file.get_as_text())
	file.close()
	first_names = first_names_data.get_data()
	return first_names
	
func load_last_names():
	var file = FileAccess.open("res://JSON Files/LastNames.json", FileAccess.READ)
	var last_names_data = JSON.new()
	last_names_data.parse(file.get_as_text())
	file.close()
	last_names = last_names_data.get_data()
	return last_names

func generate_random_player(side, position):
	var player = {}
	player["FirstName"] = first_names[randi() % first_names.size()]
	player["LastName"] = last_names[randi() % last_names.size()]
	player["Side"] = side
	player["Position"] = position
	player["Rating"] = randi() % 40 + 60
	player["PlayerID"] = str(randi() % 100000000).pad_zeros(8)
	if player["Position"] in ["QB", "P", "K"]:
		player["Age"] = randi() % 18 + 20
	elif player["Position"] in ["RB", "R"]:
		player["Age"] = randi() % 12 + 20
	else:
		player["Age"] = randi() % 15 + 20
	return player

func generate_team_roster():
	var roster = []
	var positions = {
		"Offense": {"QB": 2, "RB": 3, "WR": 5, "TE": 2, "RT": 2, "LT": 2, "RG": 2, "LG": 2, "C": 1},
		"Defense": {"LE": 2, "RE": 2, "DT": 3, "OLB": 3, "MLB": 2, "CB": 5, "SS": 2, "FS": 2},
		"ST": {"K": 1, "P": 1, "R": 1}
	}
	for side in positions.keys():
		for position in positions[side].keys():
			for i in range(positions[side][position]):
				roster.append(generate_random_player(side, position))
	return roster
	
var team_names = [
	"New York Spartans", "Charlotte Beasts", "Philadelphia Suns", "DC Senators", "Columbus Hawks", "Milwaukee Owls", "Chicago Warriors", "Baltimore Bombers", "Oklahoma Tornadoes", "New Orleans Voodoo", "Omaha Ducks", "Memphis Pyramids", "Las Vegas Aces", "Oregon Sea Lions", "San Diego Spartans", "Los Angeles Stars", "Miami Pirates", "Boston Wildcats", "Tampa Wolverines", "Georgia Peaches", "Louisville Stallions", "Cleveland Blue Jays", "Indianapolis Cougars", "Detroit Motors", "Dallas Rebels", "Kansas City Badgers", "Houston Bulls", "Nashville Strings", "Seattle Vampires", "Sacramento Golds", "Albuquerque Scorpions", "Phoenix Roadrunners"
]

func generate_all_team_rosters():
	var all_team_rosters = {}
	for i in range(team_names.size()):
		var team_name = team_names[i]
		all_team_rosters[team_name] = generate_team_roster()
	return all_team_rosters


func _on_abq_pressed():
	selected_team = "Albuquerque Scorpions"

func _on_bal_pressed():
	selected_team = "Baltimore Bombers"

func _on_bos_pressed():
	selected_team = "Boston Wildcats"

func _on_cha_pressed():
	selected_team = "Charlotte Beasts"

func _on_chi_pressed():
	selected_team = "Chicago Warriors"

func _on_cle_pressed():
	selected_team = "Cleveland Blue Jays"

func _on_dal_pressed():
	selected_team = "Dallas Rebels"


func _on_dc_pressed():
	selected_team = "DC Senators"

func _on_det_pressed():
	selected_team = "Detroit Motors"

func _on_ga_pressed():
	selected_team = "Georgia Peaches"

func _on_hou_pressed():
	selected_team = "Houston Bulls"

func _on_ind_pressed():
	selected_team = "Indianapolis Cougars"

func _on_kc_pressed():
	selected_team = "Kansas City Badgers"

func _on_lv_pressed():
	selected_team = "Las Vegas Aces"

func _on_la_pressed():
	selected_team = "Los Angeles Stars"

func _on_lou_pressed():
	selected_team = "Louisville Stallions"

func _on_mem_pressed():
	selected_team = "Memphis Pyramids"

func _on_mia_pressed():
	selected_team = "Miami Pirates"

func _on_mil_pressed():
	selected_team = "Milwaukee Owls"

func _on_nas_pressed():
	selected_team = "Nashville Strings"

func _on_nor_pressed():
	selected_team = "New Orleans Voodoo"

func _on_ny_pressed():
	selected_team = "New York Spartans"

func _on_ok_pressed():
	selected_team = "Oklahoma City Tornadoes"

func _on_oma_pressed():
	selected_team = "Omaha Ducks"

func _on_or_pressed():
	selected_team = "Oregon Sea Lions"

func _on_phi_pressed():
	selected_team = "Philadelphia Suns"

func _on_pho_pressed():
	selected_team = "Phoenix Roadrunners"

func _on_sac_pressed():
	selected_team = "Sacramento Golds"

func _on_sd_pressed():
	selected_team = "San Diego Spartans"

func _on_sea_pressed():
	selected_team = "Seattle Vampires"

func _on_tam_pressed():
	selected_team = "Tampa Wolverines"


func _on_button_pressed():
	print(selected_team)


func _on_col_pressed():
	selected_team = "Columbus Hawks"
