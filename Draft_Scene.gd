extends Node2D

var rookies = []
var first_names = []
var last_names = []
var draft_picks = Draft.drafts
var selected_player = ""
var picking_team = ""
var selected_team = GameData.selected_team_name
var current_pick = 1
var current_season = 0
var all_rosters_array = []
var all_rosters = Rosters.team_rosters
var roster_array = []
var scouting_slots = 0
var draft_selections = []

@onready var selecting_team = $SelectingTeam
@onready var round_label = $RoundLabel
@onready var pick_label = $PickLabel

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

func generate_random_rookie(side, position):
	var player = {}
	first_names = load_first_names()
	last_names = load_last_names()
	
	var first_names_array = first_names.keys()
	var last_names_array = last_names.keys()
	var random_index = randi() % first_names_array.size()
	var rng = randf()
	player["FirstName"] = first_names_array[random_index]
	player["LastName"] = last_names_array[randi() % last_names_array.size()]
	player["Side"] = side
	player["Position"] = position
	if rng < .6:
		player["Rating"] = randi() % 20 + 50
	elif rng < .8:
		player["Rating"] = randi() % 25 + 50
	elif rng < .93:
		player["Rating"] = randi() % 30 + 50
	else:
		player["Rating"] = randi() % 40 + 50
	player["PlayerID"] = str(randi() % 100000000).pad_zeros(8)
	player["Potential"] = generate_potential()
	player["Age"] = randi() % 4 + 20
	player["Scouted"] = 0
	player["Trade Value"] = 0
	player["Guaranteed Years"] = 2
	player["Injury"] = 0
	player["Injury Length"] = 0
	player["Rookie"] = 1
	return player

func generate_rookies():
	var rookie_roster = []
	var positions = {
		"Offense": {"QB": randi() %  15 + 15, "RB": randi() % 16 + 17, "WR": randi() % 18 + 22, "TE": randi() % 15 + 15, "RT": randi() % 15 + 15, "LT": randi() % 15 + 15, "RG": randi() % 18 + 15, "LG": randi() % 16 + 15, "C": randi() % 15 + 14},
		"Defense": {"LE": randi() % 16 + 15, "RE": randi() % 16 + 15, "DT": randi() % 18 + 17, "OLB": randi() % 15 + 17, "MLB": randi() % 18 + 15, "CB": randi() % 20 + 20, "SS": randi() % 18 + 15, "FS": randi() % 17 + 15},
		"ST": {"K": randi() % 8 + 12, "P": randi() % 8 + 12, "R": randi() % 8 + 12}
	}
	for side in positions.keys():
		for position in positions[side].keys():
			var position_group = []
			for i in range(positions[side][position]):
				position_group.append(generate_random_rookie(side, position))
			position_group.sort_custom(func(a, b):
				return a["Rating"] > b["Rating"])
			#sort_position(position_group)
			for i in range(position_group.size()):
				position_group[i]["DepthChart"] = 0
				rookie_roster.append(position_group[i])
	return rookie_roster

func _ready():
	await get_tree().create_timer(.01).timeout
	rookies = generate_rookies()
	all_rosters_array = convert_all_rosters_to_array()
	get_picking_team()
	populate_rookie_list("DraftScroll/DraftBox")
	get_scouting_slots()
	set_select_button_text()
	set_labels_text()

func compare_by_rating(player1, player2):
	if player1["Rating"] >= player2["Rating"]:
		return true
	else:
		return false

func sort_position(position_group):
	position_group.sort_custom(compare_by_rating)

func generate_salary(current_pick):
	var minimum = .75
	if current_pick == 1:
		return 6.9
	elif current_pick == 2:
		return 6.6
	elif current_pick == 3:
		return 6.4
	elif current_pick == 4:
		return 6.2
	elif current_pick == 5:
		return 5.8
	elif current_pick == 6:
		return 5.1
	elif current_pick == 7:
		return 4.5
	elif current_pick == 8:
		return 4
	elif current_pick == 9:
		return 3.9
	elif current_pick == 10:
		return 3.8
	elif current_pick <= 12:
		return 3.2
	elif current_pick <= 16:
		return 2.8
	elif current_pick <= 20:
		return 2.6
	elif current_pick <= 26:
		return 2.4
	elif current_pick <= 32:
		return 2.1
	elif current_pick <= 48:
		return 1.8
	elif current_pick <= 64:
		return 1.6
	elif current_pick <= 96:
		return 1.3
	elif current_pick <= 128:
		return 1.1
	elif current_pick <= 160:
		return .95
	elif current_pick <= 192:
		return .83
	else:
		return minimum

func potential_multiplier(potential):
	if potential == 1:
		return .75
	elif potential == 2:
		return .9
	elif potential == 3:
		return 1
	elif potential == 4:
		return 1.1
	elif potential == 5:
		return 1.2
	else:
		return 1

func generate_potential():
	var rng = randf()
	if rng >= .9:
		return 5
	elif rng >= .7:
		return 4
	elif rng >= .35:
		return 3
	elif rng >= .15:
		return 2
	else:
		return 1

func populate_rookie_list(container_path):
	var container = get_node(container_path)
	for child in container.get_children():
		child.queue_free()
	var position_label = Label.new()
	position_label.text = "Available Players"
	container.add_child(position_label)
	var rookie_array = []
	for player in rookies:
		rookie_array.append(player)
	rookie_array.sort_custom(func(a, b):
		return a["PlayerID"] > b["PlayerID"])
	rookie_array.sort_custom(func(a, b):
		return a["Rating"] > b["Rating"])
	for player in rookie_array:
		var scout_lower = get_scouted_lower(player)
		var scout_higher = get_scouted_higher(player)
		var pot_lower = get_pot_lower(player)
		var pot_higher = get_pot_higher(player)
		var button_text = ""
		if player["Scouted"] == 0:
			if pot_lower == pot_higher:
				button_text = "%s %s %s OVR %d-%d Age %d Potential %d" % [player["Position"], player["FirstName"], player["LastName"], scout_lower, scout_higher, player["Age"], player["Potential"]]
			else:
				button_text = "%s %s %s OVR %d-%d Age %d Potential %d-%d" % [player["Position"], player["FirstName"], player["LastName"], scout_lower, scout_higher, player["Age"], pot_lower, pot_higher]
		else:
			button_text = "%s %s %s OVR %d Age %d Potential %d" % [player["Position"], player["FirstName"], player["LastName"], player["Rating"], player["Age"], player["Potential"]]
		var player_button = Button.new()
		player_button.text = button_text
		player_button.name = player["PlayerID"]
		player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
		container.add_child(player_button)

func _on_PlayerButton_pressed(player_id):
	selected_player = player_id

func set_select_button_text():
	var select_button = $Select
	if picking_team != selected_team:
		select_button.text = "Next Pick"
	else:
		select_button.text = "Select Player"

func _on_select_pressed():
	if picking_team != selected_team:
		simulate_pick()
	else:
		select_player()
	set_select_button_text()
	set_labels_text()
	selected_player = ""

func simulate_pick():
	other_teams_draft()
	delete_pick()
	current_pick += 1
	if current_pick <= 224:
		get_picking_team()
		populate_rookie_list("DraftScroll/DraftBox")
	else:
		exit_draft()

func select_player():
	if selected_player == "":
		return
	var player_to_sign = {}
	for player in rookies:
		if player["PlayerID"] == selected_player:
			player_to_sign = player
			break
	
	var players_at_position = all_rosters_array.filter(func(p):
		return p["Team"] == selected_team and p["Position"] == player_to_sign["Position"])
	
	players_at_position.sort_custom(func(a, b):
		return a["DepthChart"] < b["DepthChart"])
	
	var depth_chart_assigned = false
	for i in range(players_at_position.size()):
		if player_to_sign["Rating"] > players_at_position[i]["Rating"]:
			player_to_sign["DepthChart"] = players_at_position[i]["DepthChart"]
			for j in range(i, players_at_position.size()):
				players_at_position[j]["DepthChart"] += 1
			depth_chart_assigned = true
			break
	
	if not depth_chart_assigned:
		player_to_sign["DepthChart"] = players_at_position.size() + 1
	var salary_request = generate_salary(current_pick)
	player_to_sign["Remaining Contract"] = 4
	player_to_sign["Salary"] = salary_request
	player_to_sign["Team"] = selected_team
	draft_selections.append(player_to_sign)
	rookies.erase(player_to_sign)
	delete_pick()
	current_pick += 1
	get_picking_team()
	populate_rookie_list("DraftScroll/DraftBox")
	

func get_picking_team():
	if draft_picks[current_season].has(current_pick):
		picking_team = draft_picks[current_season][current_pick]["current_team"]
	selecting_team.text = picking_team

func other_teams_draft():
	var team_name = picking_team
	var team_roster = Rosters.team_rosters[team_name]
	var positions_filled = get_positions_filled(team_roster)
	var eligible_signings = []
	for rookie in rookies:
		var position = rookie["Position"]
		var highest_rating = get_highest_rating_for_position(team_roster, position)
		
		var rating_criteria = 5
		if position not in positions_filled:
			rating_criteria = 0
		elif highest_rating == 0 or rookie["Rating"] > highest_rating + 10:
			rating_criteria = 10
		elif rookie["Rating"] > highest_rating + 10:
			rating_criteria = 10
		elif rookie["Rating"] > highest_rating + 7:
			rating_criteria = 7
		elif rookie["Rating"] > highest_rating + 5:
			rating_criteria = 5
		elif rookie["Rating"] > highest_rating + 3:
			rating_criteria = 3
		elif rookie["Rating"] > highest_rating:
			rating_criteria = 1
		
		if rookie["Rating"] > highest_rating + rating_criteria:
			eligible_signings.append(rookie)
	if eligible_signings.size() > 0:
		var player_to_sign = eligible_signings[randi() % eligible_signings.size()]
		sign_player_to_team(player_to_sign, team_name)

	else:
		rookies.sort_custom(func(a, b):
			return a["Rating"] > b["Rating"])
		if rookies.size() > 0:
			var player_to_sign = rookies[0]
			sign_player_to_team(player_to_sign, team_name)


func get_positions_filled(team_roster):
	var positions = {}
	for player in team_roster:
		positions[player["Position"]] = true
	return positions

func get_highest_rating_for_position(roster, position):
	var highest_rating = 0
	for player in roster:
		if player["Position"] == position and player["Rating"] > highest_rating:
			highest_rating = player["Rating"]
	return highest_rating

func sign_player_to_team(player, team_name):
	var salary_request = generate_salary(current_pick)
	var years = 4
	player["Salary"] = salary_request
	player["Remaining Contract"] = years
	
	var max_depth_chart = get_max_depth_chart(Rosters.team_rosters[team_name], player["Position"])
	player["DepthChart"] = max_depth_chart + 1
	
	player["Team"] = team_name
	draft_selections.append(player)
	rookies.erase(player)
	
func get_max_depth_chart(roster, position):
	var max_depth_chart = 0
	for player in roster:
		if player["Position"] == position and player["DepthChart"] > max_depth_chart:
			max_depth_chart = player["DepthChart"]
	return max_depth_chart

func convert_all_rosters_to_array():
	var all_rosters_array = []
	for team_name in all_rosters.keys():
		for player in all_rosters[team_name]:
			player["Team"] = team_name
			roster_array.append(player)
	return roster_array

func exit_draft():
	add_rookies_to_fa()
	write_new_rosters()
	get_tree().current_scene.queue_free()

func write_new_rosters():
	for player in draft_selections:
		var team_name = player["Team"]
		for team in Rosters.team_rosters.keys():
			if team == team_name:
				Rosters.team_rosters[team].append(player)
				draft_selections.erase(player)

func set_labels_text():
	if current_pick <= 32:
		round_label.text = "Round 1"
		pick_label.text = "Pick %d" % [current_pick]
	elif current_pick <= 64:
		round_label.text = "Round 2"
		pick_label.text = str(current_pick - 32)
	elif current_pick <= 96:
		round_label.text = "Round 3"
		pick_label.text = str(current_pick - 64)
	elif current_pick <= 128:
		round_label.text = "Round 4"
		pick_label.text = str(current_pick - 96)
	elif current_pick <= 160:
		round_label.text = "Round 5"
		pick_label.text = str(current_pick - 128)
	elif current_pick <= 192:
		round_label.text = "Round 6"
		pick_label.text = str(current_pick - 160)
	else:
		round_label.text = "Round 7"
		pick_label.text = str(current_pick - 192)
	var scout_button = $Scout
	scout_button.text = "Scout Player (%d)" % [scouting_slots]

func _on_simulate_pressed():
	while picking_team != selected_team and current_pick <= 224:
		simulate_pick()
		get_picking_team()
		set_select_button_text()
		set_labels_text()
		if picking_team == selected_team:
			populate_rookie_list("DraftScroll/DraftBox")
			set_select_button_text()
			break
	if current_pick > 224:
		exit_draft()

func add_rookies_to_fa():
	for player in rookies:
		var salary_request = .75
		var years = 1
		player["Salary"] = salary_request
		player["Remaining Contract"] = years
		player["DepthChart"] = 0
		player["Team"] = "Free Agent"
		player["Guaranteed Years"] = 0
		Rosters.team_rosters["Free Agent"].append(player)
		rookies.erase(player)


func _on_roster_pressed():
	var root = get_tree().root
	var roster_scene = load("res://DepthChart.tscn")
	var roster_instance = roster_scene.instantiate()
	root.add_child(roster_instance)
	var current_scene = get_tree().current_scene


func _on_trade_pressed():
	var root = get_tree().root
	var trade_scene = load("res://Trade.tscn")
	var trade_instance = trade_scene.instantiate()
	trade_instance.connect("trade_made", _on_trade_made)
	root.add_child(trade_instance)
	var current_scene = get_tree().current_scene

func delete_pick():
	var year_draft = Draft.drafts[current_season]
	if year_draft.has(current_pick):
		year_draft.erase(current_pick)
		Draft.drafts[current_season] = year_draft

func _on_trade_made():
	get_picking_team()
	set_select_button_text()
	set_labels_text()

func get_scouted_lower(player):
	var seed = int(str(player["PlayerID"])[-1])
	var scout_rank = ""
	var scout_focus = ""
	var true_rating = player["Rating"]
	var boosts = []
	for scout in Coaches.team_scouts:
		if scout["Team"] == selected_team:
			scout_rank = scout["Rank"]
			scout_focus = scout["Focus"]
			boosts.append(scout["Boost1"])
			boosts.append(scout["Boost2"])
			boosts.append(scout["Boost3"])
	if player["Position"] in boosts:
		if scout_focus == "Potential":
			if scout_rank == "Copper":
				if seed in [0, 1, 2]:
					return true_rating - 3
				elif seed in [3, 4, 5]:
					return true_rating - 2
				elif seed in [6, 7]:
					return true_rating - 1
				elif seed in [8, 9]:
					return true_rating - 1
			elif scout_rank == "Bronze":
				if seed in [0, 1, 2]:
					return true_rating - 1
				elif seed in [3, 4, 5]:
					return true_rating - 2
				elif seed in [6, 7]:
					return true_rating - 1
				elif seed in [8, 9]:
					return true_rating - 2
			elif scout_rank == "Silver":
				if seed in [0, 1, 2]:
					return true_rating 
				elif seed in [3, 4, 5]:
					return true_rating - 1
				elif seed in [6, 7]:
					return true_rating - 2
				elif seed in [8, 9]:
					return true_rating 
			elif scout_rank == "Gold":
				if seed in [0, 1, 2]:
					return true_rating
				elif seed in [3, 4, 5]:
					return true_rating
				elif seed in [6, 7]:
					return true_rating - 1
				elif seed in [8, 9]:
					return true_rating - 1
			elif scout_rank == "Platinum":
				if seed in [0, 1, 2]:
					return true_rating
				elif seed in [3, 4, 5]:
					return true_rating
				elif seed in [6, 7]:
					return true_rating
				elif seed in [8, 9]:
					return true_rating
			elif scout_rank == "Diamond":
				if seed in [0, 1, 2]:
					return true_rating
				elif seed in [3, 4, 5]:
					return true_rating
				elif seed in [6, 7]:
					return true_rating
				elif seed in [8, 9]:
					return true_rating
		else:
			if scout_rank == "Copper":
				if seed in [0, 1, 2]:
					return true_rating - 2
				elif seed in [3, 4, 5]:
					return true_rating - 1
				elif seed in [6, 7]:
					return true_rating - 2
				elif seed in [8, 9]:
					return true_rating - 1
			elif scout_rank == "Bronze":
				if seed in [0, 1, 2]:
					return true_rating - 1
				elif seed in [3, 4, 5]:
					return true_rating - 2
				elif seed in [6, 7]:
					return true_rating - 1
				elif seed in [8, 9]:
					return true_rating
			elif scout_rank == "Silver":
				if seed in [0, 1, 2]:
					return true_rating - 1
				elif seed in [3, 4, 5]:
					return true_rating
				elif seed in [6, 7]:
					return true_rating - 1
				elif seed in [8, 9]:
					return true_rating 
			elif scout_rank == "Gold":
				if seed in [0, 1, 2]:
					return true_rating
				elif seed in [3, 4, 5]:
					return true_rating
				elif seed in [6, 7]:
					return true_rating - 1
				elif seed in [8, 9]:
					return true_rating
			elif scout_rank == "Platinum":
				if seed in [0, 1, 2]:
					return true_rating
				elif seed in [3, 4, 5]:
					return true_rating
				elif seed in [6, 7]:
					return true_rating
				elif seed in [8, 9]:
					return true_rating
			elif scout_rank == "Diamond":
				if seed in [0, 1, 2]:
					return true_rating
				elif seed in [3, 4, 5]:
					return true_rating
				elif seed in [6, 7]:
					return true_rating
				elif seed in [8, 9]:
					return true_rating
	else:
		if scout_focus == "Potential":
			if scout_rank == "Copper":
				if seed in [0, 1, 2]:
					return true_rating - 5
				elif seed in [3, 4, 5]:
					return true_rating - 4
				elif seed in [6, 7]:
					return true_rating - 3
				elif seed in [8, 9]:
					return true_rating - 2
			elif scout_rank == "Bronze":
				if seed in [0, 1, 2]:
					return true_rating - 3
				elif seed in [3, 4, 5]:
					return true_rating - 2
				elif seed in [6, 7]:
					return true_rating - 2
				elif seed in [8, 9]:
					return true_rating - 3
			elif scout_rank == "Silver":
				if seed in [0, 1, 2]:
					return true_rating - 1
				elif seed in [3, 4, 5]:
					return true_rating - 2
				elif seed in [6, 7]:
					return true_rating - 3
				elif seed in [8, 9]:
					return true_rating 
			elif scout_rank == "Gold":
				if seed in [0, 1, 2]:
					return true_rating
				elif seed in [3, 4, 5]:
					return true_rating - 1
				elif seed in [6, 7]:
					return true_rating - 2
				elif seed in [8, 9]:
					return true_rating - 1
			elif scout_rank == "Platinum":
				if seed in [0, 1, 2]:
					return true_rating
				elif seed in [3, 4, 5]:
					return true_rating - 1
				elif seed in [6, 7]:
					return true_rating
				elif seed in [8, 9]:
					return true_rating - 1
			elif scout_rank == "Diamond":
				if seed in [0, 1, 2]:
					return true_rating
				elif seed in [3, 4, 5]:
					return true_rating
				elif seed in [6, 7]:
					return true_rating
				elif seed in [8, 9]:
					return true_rating
		else:
			if scout_rank == "Copper":
				if seed in [0, 1, 2]:
					return true_rating - 4
				elif seed in [3, 4, 5]:
					return true_rating - 3
				elif seed in [6, 7]:
					return true_rating - 2
				elif seed in [8, 9]:
					return true_rating - 1
			elif scout_rank == "Bronze":
				if seed in [0, 1, 2]:
					return true_rating - 2
				elif seed in [3, 4, 5]:
					return true_rating - 2
				elif seed in [6, 7]:
					return true_rating - 1
				elif seed in [8, 9]:
					return true_rating - 2
			elif scout_rank == "Silver":
				if seed in [0, 1, 2]:
					return true_rating - 1
				elif seed in [3, 4, 5]:
					return true_rating - 1
				elif seed in [6, 7]:
					return true_rating - 2
				elif seed in [8, 9]:
					return true_rating 
			elif scout_rank == "Gold":
				if seed in [0, 1, 2]:
					return true_rating
				elif seed in [3, 4, 5]:
					return true_rating - 1
				elif seed in [6, 7]:
					return true_rating - 1
				elif seed in [8, 9]:
					return true_rating
			elif scout_rank == "Platinum":
				if seed in [0, 1, 2]:
					return true_rating
				elif seed in [3, 4, 5]:
					return true_rating
				elif seed in [6, 7]:
					return true_rating
				elif seed in [8, 9]:
					return true_rating - 1
			elif scout_rank == "Diamond":
				if seed in [0, 1, 2]:
					return true_rating
				elif seed in [3, 4, 5]:
					return true_rating
				elif seed in [6, 7]:
					return true_rating
				elif seed in [8, 9]:
					return true_rating

func get_scouted_higher(player):
	var seed = int(str(player["PlayerID"])[-1])
	var scout_rank = ""
	var true_rating = player["Rating"]
	var scout_focus = ""
	var boosts = []
	for scout in Coaches.team_scouts:
		if scout["Team"] == selected_team:
			scout_rank = scout["Rank"]
			scout_focus = scout["Focus"]
			boosts.append(scout["Boost1"])
			boosts.append(scout["Boost2"])
			boosts.append(scout["Boost3"])
	if player["Position"] in boosts:
		if scout_focus == "Potential":
			if scout_rank == "Copper":
				if seed in [0, 1, 2]:
					return true_rating + 2
				elif seed in [3, 4, 5]:
					return true_rating + 2
				elif seed in [6, 7]:
					return true_rating + 3
				elif seed in [8, 9]:
					return true_rating + 2
			elif scout_rank == "Bronze":
				if seed in [0, 1, 2]:
					return true_rating + 2
				elif seed in [3, 4, 5]:
					return true_rating + 1
				elif seed in [6, 7]:
					return true_rating + 1
				elif seed in [8, 9]:
					return true_rating + 2
			elif scout_rank == "Silver":
				if seed in [0, 1, 2]:
					return true_rating + 1
				elif seed in [3, 4, 5]:
					return true_rating + 1
				elif seed in [6, 7]:
					return true_rating + 2
				elif seed in [8, 9]:
					return true_rating + 1
			elif scout_rank == "Gold":
				if seed in [0, 1, 2]:
					return true_rating
				elif seed in [3, 4, 5]:
					return true_rating + 1
				elif seed in [6, 7]:
					return true_rating
				elif seed in [8, 9]:
					return true_rating + 1
			elif scout_rank == "Platinum":
				if seed in [0, 1, 2]:
					return true_rating
				elif seed in [3, 4, 5]:
					return true_rating
				elif seed in [6, 7]:
					return true_rating + 1
				elif seed in [8, 9]:
					return true_rating
			elif scout_rank == "Diamond":
				if seed in [0, 1, 2]:
					return true_rating
				elif seed in [3, 4, 5]:
					return true_rating
				elif seed in [6, 7]:
					return true_rating
				elif seed in [8, 9]:
					return true_rating
		else:
			if scout_rank == "Copper":
				if seed in [0, 1, 2]:
					return true_rating + 2
				elif seed in [3, 4, 5]:
					return true_rating + 2
				elif seed in [6, 7]:
					return true_rating + 1
				elif seed in [8, 9]:
					return true_rating + 3
			elif scout_rank == "Bronze":
				if seed in [0, 1, 2]:
					return true_rating + 1
				elif seed in [3, 4, 5]:
					return true_rating + 2
				elif seed in [6, 7]:
					return true_rating + 2
				elif seed in [8, 9]:
					return true_rating
			elif scout_rank == "Silver":
				if seed in [0, 1, 2]:
					return true_rating + 1
				elif seed in [3, 4, 5]:
					return true_rating + 1
				elif seed in [6, 7]:
					return true_rating
				elif seed in [8, 9]:
					return true_rating + 1
			elif scout_rank == "Gold":
				if seed in [0, 1, 2]:
					return true_rating
				elif seed in [3, 4, 5]:
					return true_rating
				elif seed in [6, 7]:
					return true_rating
				elif seed in [8, 9]:
					return true_rating
			elif scout_rank == "Platinum":
				if seed in [0, 1, 2]:
					return true_rating
				elif seed in [3, 4, 5]:
					return true_rating
				elif seed in [6, 7]:
					return true_rating
				elif seed in [8, 9]:
					return true_rating
			elif scout_rank == "Diamond":
				if seed in [0, 1, 2]:
					return true_rating
				elif seed in [3, 4, 5]:
					return true_rating
				elif seed in [6, 7]:
					return true_rating
				elif seed in [8, 9]:
					return true_rating
	else:
		if scout_focus == "Potential":
			if scout_rank == "Copper":
				if seed in [0, 1, 2]:
					return true_rating + 2
				elif seed in [3, 4, 5]:
					return true_rating + 3
				elif seed in [6, 7]:
					return true_rating + 5
				elif seed in [8, 9]:
					return true_rating + 3
			elif scout_rank == "Bronze":
				if seed in [0, 1, 2]:
					return true_rating + 2
				elif seed in [3, 4, 5]:
					return true_rating + 3
				elif seed in [6, 7]:
					return true_rating + 2
				elif seed in [8, 9]:
					return true_rating + 1
			elif scout_rank == "Silver":
				if seed in [0, 1, 2]:
					return true_rating + 2
				elif seed in [3, 4, 5]:
					return true_rating + 1
				elif seed in [6, 7]:
					return true_rating + 2
				elif seed in [8, 9]:
					return true_rating + 2
			elif scout_rank == "Gold":
				if seed in [0, 1, 2]:
					return true_rating + 1
				elif seed in [3, 4, 5]:
					return true_rating + 1
				elif seed in [6, 7]:
					return true_rating
				elif seed in [8, 9]:
					return true_rating
			elif scout_rank == "Platinum":
				if seed in [0, 1, 2]:
					return true_rating + 1
				elif seed in [3, 4, 5]:
					return true_rating
				elif seed in [6, 7]:
					return true_rating + 1
				elif seed in [8, 9]:
					return true_rating
			elif scout_rank == "Diamond":
				if seed in [0, 1, 2]:
					return true_rating
				elif seed in [3, 4, 5]:
					return true_rating
				elif seed in [6, 7]:
					return true_rating
				elif seed in [8, 9]:
					return true_rating
		else:
			if scout_rank == "Copper":
				if seed in [0, 1, 2]:
					return true_rating + 2
				elif seed in [3, 4, 5]:
					return true_rating + 2
				elif seed in [6, 7]:
					return true_rating + 4
				elif seed in [8, 9]:
					return true_rating + 3
			elif scout_rank == "Bronze":
				if seed in [0, 1, 2]:
					return true_rating + 2
				elif seed in [3, 4, 5]:
					return true_rating + 2
				elif seed in [6, 7]:
					return true_rating + 2
				elif seed in [8, 9]:
					return true_rating + 1
			elif scout_rank == "Silver":
				if seed in [0, 1, 2]:
					return true_rating + 1
				elif seed in [3, 4, 5]:
					return true_rating + 1
				elif seed in [6, 7]:
					return true_rating + 2
				elif seed in [8, 9]:
					return true_rating + 1
			elif scout_rank == "Gold":
				if seed in [0, 1, 2]:
					return true_rating
				elif seed in [3, 4, 5]:
					return true_rating + 1
				elif seed in [6, 7]:
					return true_rating
				elif seed in [8, 9]:
					return true_rating
			elif scout_rank == "Platinum":
				if seed in [0, 1, 2]:
					return true_rating
				elif seed in [3, 4, 5]:
					return true_rating
				elif seed in [6, 7]:
					return true_rating
				elif seed in [8, 9]:
					return true_rating
			elif scout_rank == "Diamond":
				if seed in [0, 1, 2]:
					return true_rating
				elif seed in [3, 4, 5]:
					return true_rating
				elif seed in [6, 7]:
					return true_rating
				elif seed in [8, 9]:
					return true_rating

func get_pot_lower(player):
	var seed = int(str(player["PlayerID"])[-1])
	var scout_rank = ""
	var scout_focus = ""
	var true_pot = player["Potential"]
	var boosts = []
	for scout in Coaches.team_scouts:
		if scout["Team"] == selected_team:
			scout_rank = scout["Rank"]
			scout_focus = scout["Focus"]
			boosts.append(scout["Boost1"])
			boosts.append(scout["Boost2"])
			boosts.append(scout["Boost3"])
	if player["Position"] in boosts:
		if scout_focus == "Potential":
			if scout_rank == "Copper":
				if seed in [0, 1, 2]:
					if true_pot >= 3:
						return true_pot - 2
					else:
						return 1
				elif seed in [5, 6, 7]:
					if true_pot >= 2:
						return true_pot -1
					else:
						return 1
				else:
					return true_pot
			elif scout_rank == "Bronze":
				if seed in [0, 2]:
					if true_pot >= 3:
						return true_pot - 2
					else:
						return 1
				elif seed in [5, 6, 4]:
					if true_pot >= 2:
						return true_pot -1
					else:
						return 1
				else:
					return true_pot
			elif scout_rank == "Silver":
				if seed in [1]:
					if true_pot >= 3:
						return true_pot - 2
					else:
						return 1
				elif seed in [5, 2]:
					if true_pot >= 2:
						return true_pot -1
					else:
						return 1
				else:
					return true_pot
			elif scout_rank == "Gold":
				if seed in [6]:
					if true_pot >= 2:
						return true_pot -1
					else:
						return 1
				else:
					return true_pot
			elif scout_rank == "Platinum":
				return true_pot
			elif scout_rank == "Diamond":
				return true_pot
		else:
			if scout_rank == "Copper":
				if seed in [0, 1, 3, 4]:
					if true_pot >= 3:
						return true_pot - 2
					else:
						return 1
				elif seed in [5, 6, 7, 8]:
					if true_pot >= 2:
						return true_pot -1
					else:
						return 1
				else:
					return true_pot
			elif scout_rank == "Bronze":
				if seed in [1, 2, 3]:
					if true_pot >= 3:
						return true_pot - 2
					else:
						return 1
				elif seed in [6, 4, 7]:
					if true_pot >= 2:
						return true_pot -1
					else:
						return 1
				else:
					return true_pot
			elif scout_rank == "Silver":
				if seed in [0, 2]:
					if true_pot >= 3:
						return true_pot - 2
					else:
						return 1
				elif seed in [5, 6, 9]:
					if true_pot >= 2:
						return true_pot -1
					else:
						return 1
				else:
					return true_pot
			elif scout_rank == "Gold":
				if seed in [1]:
					if true_pot >= 3:
						return true_pot - 2
					else:
						return 1
				elif seed in [5, 8]:
					if true_pot >= 2:
						return true_pot -1
					else:
						return 1
				else:
					return true_pot
			elif scout_rank == "Platinum":
				if seed in [8]:
					if true_pot >= 2:
						return true_pot -1
					else:
						return 1
			elif scout_rank == "Diamond":
				return true_pot
	else:
		if scout_focus == "Potential":
			if scout_rank == "Copper":
				if seed in [0, 1, 2, 3]:
					if true_pot >= 3:
						return true_pot - 2
					else:
						return 1
				elif seed in [5, 6, 7]:
					if true_pot >= 2:
						return true_pot -1
					else:
						return 1
				else:
					return true_pot
			elif scout_rank == "Bronze":
				if seed in [0, 1, 2]:
					if true_pot >= 3:
						return true_pot - 2
					else:
						return 1
				elif seed in [5, 6, 4]:
					if true_pot >= 2:
						return true_pot -1
					else:
						return 1
				else:
					return true_pot
			elif scout_rank == "Silver":
				if seed in [0, 1]:
					if true_pot >= 3:
						return true_pot - 2
					else:
						return 1
				elif seed in [5, 6, 2]:
					if true_pot >= 2:
						return true_pot -1
					else:
						return 1
				else:
					return true_pot
			elif scout_rank == "Gold":
				if seed in [0]:
					if true_pot >= 3:
						return true_pot - 2
					else:
						return 1
				elif seed in [5, 6]:
					if true_pot >= 2:
						return true_pot -1
					else:
						return 1
				else:
					return true_pot
			elif scout_rank == "Platinum":
				return true_pot
			elif scout_rank == "Diamond":
				return true_pot
		else:
			if scout_rank == "Copper":
				if seed in [0, 1, 2, 3, 4]:
					if true_pot >= 3:
						return true_pot - 2
					else:
						return 1
				elif seed in [5, 6, 7, 8]:
					if true_pot >= 2:
						return true_pot -1
					else:
						return 1
				else:
					return true_pot
			elif scout_rank == "Bronze":
				if seed in [0, 1, 2, 3]:
					if true_pot >= 3:
						return true_pot - 2
					else:
						return 1
				elif seed in [5, 6, 4, 7]:
					if true_pot >= 2:
						return true_pot -1
					else:
						return 1
				else:
					return true_pot
			elif scout_rank == "Silver":
				if seed in [0, 1, 2]:
					if true_pot >= 3:
						return true_pot - 2
					else:
						return 1
				elif seed in [5, 6, 4, 9]:
					if true_pot >= 2:
						return true_pot -1
					else:
						return 1
				else:
					return true_pot
			elif scout_rank == "Gold":
				if seed in [0, 1]:
					if true_pot >= 3:
						return true_pot - 2
					else:
						return 1
				elif seed in [5, 6, 8]:
					if true_pot >= 2:
						return true_pot -1
					else:
						return 1
				else:
					return true_pot
			elif scout_rank == "Platinum":
				if seed in [8, 2]:
					if true_pot >= 2:
						return true_pot -1
					else:
						return 1
			elif scout_rank == "Diamond":
				return true_pot

func get_pot_higher(player):
	var seed = int(str(player["PlayerID"])[-1])
	var scout_rank = ""
	var scout_focus = ""
	var true_pot = player["Potential"]
	var boosts = []
	for scout in Coaches.team_scouts:
		if scout["Team"] == selected_team:
			scout_rank = scout["Rank"]
			scout_focus = scout["Focus"]
			boosts.append(scout["Boost1"])
			boosts.append(scout["Boost1"])
			boosts.append(scout["Boost1"])
	if player["Position"] in boosts:
		if scout_focus == "Potential":
			if scout_rank == "Copper":
				if seed in [6, 9, 5]:
					if true_pot <= 3:
						return true_pot + 2
					else:
						return 5
				elif seed in [2, 8, 3]:
					if true_pot <= 4:
						return true_pot + 1
					else:
						return 5
				else:
					return true_pot
			elif scout_rank == "Bronze":
				if seed in [4, 7]:
					if true_pot <= 3:
						return true_pot + 2
					else:
						return 5
				elif seed in [0, 9, 3]:
					if true_pot <= 4:
						return true_pot + 1
					else:
						return 5
				else:
					return true_pot
			elif scout_rank == "Silver":
				if seed in [9]:
					if true_pot <= 3:
						return true_pot + 2
					else:
						return 5
				elif seed in [0, 3]:
					if true_pot <= 4:
						return true_pot + 1
					else:
						return 5
				else:
					return true_pot
			elif scout_rank == "Gold":
				if seed in [0]:
					if true_pot <= 4:
						return true_pot + 1
					else:
						return 5
				else:
					return true_pot
			elif scout_rank == "Platinum":
				return true_pot
			elif scout_rank == "Diamond":
				return true_pot
		else:
			if scout_rank == "Copper":
				if seed in [6, 9, 5, 0]:
					if true_pot <= 3:
						return true_pot + 2
					else:
						return 5
				elif seed in [2, 8, 3, 4]:
					if true_pot <= 4:
						return true_pot + 1
					else:
						return 5
				else:
					return true_pot
			elif scout_rank == "Bronze":
				if seed in [4, 7, 1]:
					if true_pot <= 3:
						return true_pot + 2
					else:
						return 5
				elif seed in [0, 9, 3]:
					if true_pot <= 4:
						return true_pot + 1
					else:
						return 5
				else:
					return true_pot
			elif scout_rank == "Silver":
				if seed in [6, 9]:
					if true_pot <= 3:
						return true_pot + 2
					else:
						return 5
				elif seed in [0, 3, 1]:
					if true_pot <= 4:
						return true_pot + 1
					else:
						return 5
				else:
					return true_pot
			elif scout_rank == "Gold":
				if seed in [7]:
					if true_pot <= 3:
						return true_pot + 2
					else:
						return 5
				elif seed in [5, 9]:
					if true_pot <= 4:
						return true_pot + 1
					else:
						return 5
				else:
					return true_pot
			elif scout_rank == "Platinum":
				if seed in [5]:
					if true_pot <= 4:
						return true_pot + 1
					else:
						return 5
				else:
					return true_pot
			elif scout_rank == "Diamond":
				return true_pot
	else:
		if scout_focus == "Potential":
			if scout_rank == "Copper":
				if seed in [6, 9, 1, 5]:
					if true_pot <= 3:
						return true_pot + 2
					else:
						return 5
				elif seed in [2, 8, 3]:
					if true_pot <= 4:
						return true_pot + 1
					else:
						return 5
				else:
					return true_pot
			elif scout_rank == "Bronze":
				if seed in [4, 7, 1]:
					if true_pot <= 3:
						return true_pot + 2
					else:
						return 5
				elif seed in [0, 9, 3]:
					if true_pot <= 4:
						return true_pot + 1
					else:
						return 5
				else:
					return true_pot
			elif scout_rank == "Silver":
				if seed in [6, 9]:
					if true_pot <= 3:
						return true_pot + 2
					else:
						return 5
				elif seed in [0, 3, 8]:
					if true_pot <= 4:
						return true_pot + 1
					else:
						return 5
				else:
					return true_pot
			elif scout_rank == "Gold":
				if seed in [7]:
					if true_pot <= 3:
						return true_pot + 2
					else:
						return 5
				elif seed in [0, 5]:
					if true_pot <= 4:
						return true_pot + 1
					else:
						return 5
				else:
					return true_pot
			elif scout_rank == "Platinum":
				return true_pot
			elif scout_rank == "Diamond":
				return true_pot
		else:
			if scout_rank == "Copper":
				if seed in [6, 9, 1, 5, 0]:
					if true_pot <= 3:
						return true_pot + 2
					else:
						return 5
				elif seed in [2, 8, 3, 4]:
					if true_pot <= 4:
						return true_pot + 1
					else:
						return 5
				else:
					return true_pot
			elif scout_rank == "Bronze":
				if seed in [4, 7, 1, 2]:
					if true_pot <= 3:
						return true_pot + 2
					else:
						return 5
				elif seed in [0, 9, 3, 5]:
					if true_pot <= 4:
						return true_pot + 1
					else:
						return 5
				else:
					return true_pot
			elif scout_rank == "Silver":
				if seed in [6, 9, 5]:
					if true_pot <= 3:
						return true_pot + 2
					else:
						return 5
				elif seed in [0, 3, 8, 1]:
					if true_pot <= 4:
						return true_pot + 1
					else:
						return 5
				else:
					return true_pot
			elif scout_rank == "Gold":
				if seed in [7, 4]:
					if true_pot <= 3:
						return true_pot + 2
					else:
						return 5
				elif seed in [0, 5, 9]:
					if true_pot <= 4:
						return true_pot + 1
					else:
						return 5
				else:
					return true_pot
			elif scout_rank == "Platinum":
				if seed in [3, 5]:
					if true_pot <= 4:
						return true_pot + 1
					else:
						return 5
				else:
					return true_pot
			elif scout_rank == "Diamond":
				return true_pot

func _on_scout_pressed():
	if selected_player == "":
		return
	if scouting_slots <= 0:
		return
	else:
		for player in rookies:
			if player["PlayerID"] == selected_player:
				player["Scouted"] = 1
		scouting_slots -= 1
		populate_rookie_list("DraftScroll/DraftBox")
		set_labels_text()

func get_scouting_slots():
	for scout in Coaches.team_scouts:
		if scout["Team"] == selected_team:
			scouting_slots = scout["Slots"]
