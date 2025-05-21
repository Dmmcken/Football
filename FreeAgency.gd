extends Node2D

var selected_team = GameData.selected_team_name

var all_rosters = Rosters.team_rosters
var all_rosters_array = []
var selected_player = ""
var roster_array = []
var salary_request = 0
var years = 0
var round = 1

@onready var years_label = $Years
@onready var guaranteed_label = $GuaranteedYears
@onready var salary_label = $Salary
@onready var deal_label = $Deal

var contract_years = 0
var contract_guaranteed_years = 0
var contract_salary = 0
var resign_interest = 0
var resign_points = 100
var salary_change = 0
var offensive_coach_boost = 0
var defensive_coach_boost = 0

func _ready():
	all_rosters_array = convert_all_rosters_to_array()
	populate_fa_list("FAScroll/FreeAgents")
	populate_position_dropdown()
	$OptionButton.connect("item_selected", Callable(self, "_on_PositionFilter_changed"))
	check_offensive_coach()
	check_defensive_coach()

func populate_position_dropdown():
	var dropdown = $OptionButton
	dropdown.add_item("All")
	var positions = ["QB", "RB", "WR", "TE", "LT", "LG", "C", "RG", "RT", "LE", "RE", "DT", "OLB", "MLB", "CB", "SS", "FS", "K", "P", "R"]
	for position in positions:
		dropdown.add_item(position)
	dropdown.selected = 0

func _on_PositionFilter_changed(selected_index):
	var dropdown = $OptionButton
	var selected_position = dropdown.get_item_text(selected_index)
	populate_fa_list_filtered("FAScroll/FreeAgents", selected_position)

func populate_fa_list_filtered(container_path, filter_position):
	var container = get_node(container_path)
	for child in container.get_children():
		child.queue_free()
	var position_label = Label.new()
	position_label.text = filter_position + " Free Agents"
	container.add_child(position_label)
	
	if filter_position == "All":
		roster_array.sort_custom(func(a, b):
			return a["Rating"] > b["Rating"])
		for player in roster_array:
			var scout_lower = get_scouted_lower(player)
			var scout_higher = get_scouted_higher(player)
			var pot_lower = get_pot_lower(player)
			var pot_higher = get_pot_higher(player)
			var button_text = ""
			if pot_lower == pot_higher:
				button_text = "%s %s %s OVR %d-%d Age %d Potential %d" % [player["Position"], player["FirstName"], player["LastName"], scout_lower, scout_higher, player["Age"], player["Potential"]]
			else:
				button_text = "%s %s %s OVR %d-%d Age %d Potential %d-%d" % [player["Position"], player["FirstName"], player["LastName"], scout_lower, scout_higher, player["Age"], pot_lower, pot_higher]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			container.add_child(player_button)
	else:
		var filtered_array = []
		for player in roster_array:
			if player["Position"] == filter_position:
				filtered_array.append(player)
		filtered_array.sort_custom(func(a, b):
			return a["Rating"] > b["Rating"])
		for player in roster_array:
			if player["Position"] == filter_position:
				var scout_lower = get_scouted_lower(player)
				var scout_higher = get_scouted_higher(player)
				var pot_lower = get_pot_lower(player)
				var pot_higher = get_pot_higher(player)
				var button_text = ""
				if pot_lower == pot_higher:
					button_text = "%s %s %s OVR %d-%d Age %d Potential %d" % [player["Position"], player["FirstName"], player["LastName"], scout_lower, scout_higher, player["Age"], player["Potential"]]
				else:
					button_text = "%s %s %s OVR %d-%d Age %d Potential %d-%d" % [player["Position"], player["FirstName"], player["LastName"], scout_lower, scout_higher, player["Age"], pot_lower, pot_higher]
				var player_button = Button.new()
				player_button.text = button_text
				player_button.name = player["PlayerID"]
				player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
				container.add_child(player_button)

func populate_fa_list(container_path):
	var container = get_node(container_path)
	for child in container.get_children():
		child.queue_free()
	var position_label = Label.new()
	position_label.text = "Free Agents"
	container.add_child(position_label)
	var fa_array = []
	for player in all_rosters_array:
		if player["Team"] == "Free Agent":
			fa_array.append(player)
	fa_array.sort_custom(func(a, b):
		return a["Rating"] > b["Rating"])
	for player in fa_array:
		var scout_lower = get_scouted_lower(player)
		var scout_higher = get_scouted_higher(player)
		var pot_lower = get_pot_lower(player)
		var pot_higher = get_pot_higher(player)
		var button_text = ""
		if pot_lower == pot_higher:
			button_text = "%s %s %s OVR %d-%d Age %d Potential %d" % [player["Position"], player["FirstName"], player["LastName"], scout_lower, scout_higher, player["Age"], player["Potential"]]
		else:
			button_text = "%s %s %s OVR %d-%d Age %d Potential %d-%d" % [player["Position"], player["FirstName"], player["LastName"], scout_lower, scout_higher, player["Age"], pot_lower, pot_higher]
		var player_button = Button.new()
		player_button.text = button_text
		player_button.name = player["PlayerID"]
		player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
		container.add_child(player_button)

func convert_all_rosters_to_array():
	var all_rosters_array = []
	for team_name in all_rosters.keys():
		for player in all_rosters[team_name]:
			player["Team"] = team_name
			roster_array.append(player)
	return roster_array

func _on_PlayerButton_pressed(player_id):
	selected_player = player_id
	resign_points = 100
	salary_change = 0
	populate_contract_details(selected_player)

func _on_sign_pressed():
	if selected_player == "":
		return
	var player_to_sign = {}
	for player in roster_array:
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
	
	player_to_sign["Team"] = selected_team
	player_to_sign["Salary"] = contract_salary
	player_to_sign["Remaining Contract"] = contract_years
	player_to_sign["Guaranteed Years"] = contract_guaranteed_years
	
	other_teams_sign()
	round += 1
	clear_labels()
	populate_fa_list("FAScroll/FreeAgents")

func other_teams_sign():
	var free_agents = []
	for player in all_rosters_array:
		if player["Team"] == "Free Agent":
			free_agents.append(player)
			
	for team_name in Rosters.team_rosters.keys():
		if team_name == selected_team or team_name == "Free Agent":
			continue
		var team_roster = Rosters.team_rosters[team_name]
		var positions_filled = get_positions_filled(team_roster)
		var eligible_signings = []
		for free_agent in free_agents:
			var position = free_agent["Position"]
			var highest_rating = get_highest_rating_for_position(team_roster, position)
			
			var rating_criteria = 5
			if position not in positions_filled:
				rating_criteria = 0
			elif highest_rating == 0 or free_agent["Rating"] > highest_rating + 10:
				rating_criteria = 10
			elif round <= 1 and free_agent["Rating"] > highest_rating + 10:
				rating_criteria = 10
			elif round <= 2 and free_agent["Rating"] > highest_rating + 7:
				rating_criteria = 7
			
			if free_agent["Rating"] > highest_rating + rating_criteria:
				eligible_signings.append(free_agent)
		if eligible_signings.size() > 0:
			var player_to_sign = eligible_signings[randi() % eligible_signings.size()]
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
	var salary_request = generate_salary(player["Position"], player["Rating"], player["Potential"])
	var years = randi() % 4 + 2
	player["Salary"] = salary_request
	player["Remaining Contract"] = years
	
	var max_depth_chart = get_max_depth_chart(Rosters.team_rosters[team_name], player["Position"])
	player["DepthChart"] = max_depth_chart + 1
	
	player["Team"] = team_name
	
func get_max_depth_chart(roster, position):
	var max_depth_chart = 0
	for player in roster:
		if player["Position"] == position and player["DepthChart"] > max_depth_chart:
			max_depth_chart = player["DepthChart"]
	return max_depth_chart

func _on_back_pressed():
	write_new_rosters()
	get_tree().current_scene.queue_free()

func populate_contract_details(selected_player):
	if selected_player == "":
		return
	var player2 = {}
	for player in roster_array:
		if player["PlayerID"] == selected_player:
			player2 = player
			break
	salary_request = generate_salary(player2["Position"], player2["Rating"], player2["Potential"])
	contract_salary = generate_salary(player2["Position"], player2["Rating"], player2["Potential"])
	salary_request = contract_salary
	var rng = int(player2["PlayerID"])
	rng *= 0.00000001
	if player2["Rating"] <= 65:
		rng -= .3
	elif player2["Rating"] <= 70:
		rng -= .2
	elif player2["Rating"] <= 75:
		rng -= .1
	elif player2["Rating"] >= 80:
		rng += .15
	elif player2["Rating"] >= 85:
		rng += .2
	elif player2["Rating"] >= 90:
		rng += .25
	elif player2["Rating"] >= 95:
		rng += .3
	if player2["Potential"] == 1:
		rng -= .2
	elif player2["Potential"] == 2:
		rng -= .1
	elif player2["Potential"] == 3:
		rng += .1
	elif player2["Potential"] == 4:
		rng += .15
	elif player2["Potential"] == 5:
		rng += .25
	if rng >= 1:
		rng = .99999
	if rng <= 0:
		rng = .0001 
	if player2["Age"] <= 30:
		var year_seed = int(str(player2["PlayerID"])[-1])
		if rng >=.75:
			if year_seed == 0:
				contract_years = 6
			elif year_seed == 1:
				contract_years = 2
			elif year_seed in [3, 4]:
				contract_years = 3
			elif year_seed in [6, 7, 8]:
				contract_years = 4
			elif year_seed in [5, 9, 2]:
				contract_years = 5
		elif rng >=.25:
			if year_seed == 0:
				contract_years = 1
			elif year_seed in [1, 2]:
				contract_years = 2
			elif year_seed in [3, 4]:
				contract_years = 3
			elif year_seed in [6, 7, 8]:
				contract_years = 4
			elif year_seed in [5, 9]:
				contract_years = 5
		else:
			if year_seed in [0, 9]:
				contract_years = 1
			elif year_seed in [1, 2]:
				contract_years = 2
			elif year_seed in [3, 4, 8]:
				contract_years = 3
			elif year_seed in [6, 7]:
				contract_years = 4
			elif year_seed in [5]:
				contract_years = 5
		
	elif player2["Age"] <= 35:
		if rng <= .5:
			contract_years = 3
		elif rng <= .75:
			contract_years = 2
		elif rng <= .9:
			contract_years = 4
		else:
			contract_years = 1
	else:
		if rng <= .5:
			contract_years = 2
		elif rng <= .75:
			contract_years = 1
		else:
			contract_years = 3

	if contract_years == 1:
		contract_guaranteed_years = 1
	elif contract_years == 2:
		if rng <= .5:
			contract_guaranteed_years = 2
		else:
			contract_guaranteed_years = 1
	elif contract_years == 3:
		if rng <= .45:
			contract_guaranteed_years = 1
		elif rng <= .9:
			contract_guaranteed_years = 2
		else:
			contract_guaranteed_years = 3
	elif contract_years == 4:
		if rng <= .3:
			contract_guaranteed_years = 1
		elif rng <= .8:
			contract_guaranteed_years = 2
		elif rng <= .95:
			contract_guaranteed_years = 3
		else:
			contract_guaranteed_years = 4
	elif contract_years == 5:
		if rng <= .15:
			contract_guaranteed_years = 1
		elif rng <= .35:
			contract_guaranteed_years = 2
		elif rng <= .8:
			contract_guaranteed_years = 3
		else:
			contract_guaranteed_years = 4
	else:
		if rng <= .05:
			contract_guaranteed_years = 1
		elif rng <= .2:
			contract_guaranteed_years = 2
		elif rng <= .6:
			contract_guaranteed_years = 3
		elif rng <= .9:
			contract_guaranteed_years = 4
		else:
			contract_guaranteed_years = 5
	resign_interest = int(str(player2["PlayerID"])[-3])
	if player2["Side"] == "Offense":
		match offensive_coach_boost:
			0:
				pass
			1:
				resign_points += 5
			2:
				resign_points += 8
			3:
				resign_points += 11
			4:
				resign_points += 14
			5:
				resign_points += 17
			6:
				resign_points += 20
	if player2["Side"] == "Defense":
		match defensive_coach_boost:
			0:
				pass
			1:
				resign_points += 5
			2:
				resign_points += 8
			3:
				resign_points += 11
			4:
				resign_points += 14
			5:
				resign_points += 17
			6:
				resign_points += 20
	resign_points += resign_interest
	set_contract_labels()
	check_deal()

func generate_salary(position, rating, potential):
	var minimum = .75
	var salary = 0
	if rating < 70:
		return minimum
	if position == "QB":
		var qb_min = 1
		var qb_max = 50
		if rating > 99:
			return 50
		elif rating >= 80:
			salary = 1 + (float(rating - 80) / (99 - 80)) * (50 - 15)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
		elif rating >= 70:
			salary = 1 + (float(rating - 70) / (80 - 70)) * (15 - 2.5)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
		else:
			return qb_min
	elif position == "RB":
		var min = 1
		var max = 14
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
	elif position == "WR":
		var min = 1
		var max = 22
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
	elif position == "TE":
		var min = 1
		var max = 15
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
	elif position == "LT" or position == "RT":
		var min = 1
		var max = 15
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
	elif position == "LG" or position == "RG":
		var min = 1
		var max = 13
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
	elif position == "C":
		var min = 1
		var max = 10
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
	elif position == "LE" or position == "RE":
		var min = 1
		var max = 25
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
	elif position == "DT":
		var min = 1
		var max = 20
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
	elif position == "OLB" or position == "MLB":
		var min = 1
		var max = 20
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
	elif position == "CB":
		var min = 1
		var max = 15
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
	elif position == "SS" or position == "FS":
		var min = 1
		var max = 15
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
	elif position in ["K", "P", "R"]:
		var min = 1
		var max = 8
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
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

func write_new_rosters():
	var temp_team_rosters = {}
	for player in all_rosters_array:
		var team_name = player["Team"]
		if not temp_team_rosters.has(team_name):
			temp_team_rosters[team_name] = []
		temp_team_rosters[team_name].append(player)
	Rosters.team_rosters = temp_team_rosters

func _on_roster_pressed():
	var root = get_tree().root
	var roster_scene = load("res://DepthChart.tscn")
	var roster_instance = roster_scene.instantiate()
	root.add_child(roster_instance)
	var current_scene = get_tree().current_scene

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

func _on_years_down_pressed():
	if contract_years <= 1:
		return
	if contract_years == contract_guaranteed_years:
		contract_years -= 1
		contract_guaranteed_years -= 1
		resign_points -= 10
		set_contract_labels()
		check_deal()
	else:
		contract_years -= 1
		resign_points -= 5
		set_contract_labels()
		check_deal()

func _on_years_up_pressed():
	if contract_years >= 6:
		return
	contract_years += 1
	resign_points += 5
	set_contract_labels()
	check_deal()

func _on_guaranteed_down_pressed():
	if contract_guaranteed_years <= 1:
		return
	contract_guaranteed_years -= 1
	resign_points -= 5
	set_contract_labels()
	check_deal()

func _on_guaranteed_up_pressed():
	if contract_guaranteed_years >= 6:
		return
	if contract_guaranteed_years >= contract_years:
		contract_guaranteed_years += 1
		contract_years += 1
		resign_points += 10
	else:
		contract_guaranteed_years += 1
		resign_points += 5
	set_contract_labels()
	check_deal()

func _on_salary_down_pressed():
	if salary_change <= -5:
		return
	salary_change -= 1
	if salary_change == 5:
		contract_salary = salary_request * 1.25
	elif salary_change == 4:
		contract_salary = salary_request * 1.2
	elif salary_change == 3:
		contract_salary = salary_request * 1.15
	elif salary_change == 2:
		contract_salary = salary_request * 1.1
	elif salary_change == 1:
		contract_salary = salary_request * 1.05
	elif salary_change == 0:
		contract_salary = salary_request
	elif salary_change == -1:
		contract_salary = salary_request * .95
	elif salary_change == -2:
		contract_salary = salary_request * .9
	elif salary_change == -3:
		contract_salary = salary_request * .85
	elif salary_change == -4:
		contract_salary = salary_request * .8
	elif salary_change == -5:
		contract_salary = salary_request * .75
	resign_points -= 5
	set_contract_labels()
	check_deal()

func _on_salary_up_pressed():
	if salary_change >= 5:
		return
	salary_change += 1
	if salary_change == 5:
		contract_salary = salary_request * 1.25
	elif salary_change == 4:
		contract_salary = salary_request * 1.2
	elif salary_change == 3:
		contract_salary = salary_request * 1.15
	elif salary_change == 2:
		contract_salary = salary_request * 1.1
	elif salary_change == 1:
		contract_salary = salary_request * 1.05
	elif salary_change == 0:
		contract_salary = salary_request
	elif salary_change == -1:
		contract_salary = salary_request * .95
	elif salary_change == -2:
		contract_salary = salary_request * .9
	elif salary_change == -3:
		contract_salary = salary_request * .85
	elif salary_change == -4:
		contract_salary = salary_request * .8
	elif salary_change == -5:
		contract_salary = salary_request * .75
	resign_points += 5
	set_contract_labels()
	check_deal()

func check_offensive_coach():
	for coach in Coaches.team_ocs:
		if coach["Team"] == selected_team:
			if coach["Trait"] == "Players Coach":
				match coach["Rank"]:
					"Copper":
						offensive_coach_boost = 1
					"Bronze":
						offensive_coach_boost = 2
					"Silver":
						offensive_coach_boost = 3
					"Gold":
						offensive_coach_boost = 4
					"Platinum":
						offensive_coach_boost = 5
					"Diamond":
						offensive_coach_boost = 6

func check_defensive_coach():
	for coach in Coaches.team_dcs:
		if coach["Team"] == selected_team:
			if coach["Trait"] == "Players Coach":
				match coach["Rank"]:
					"Copper":
						defensive_coach_boost = 1
					"Bronze":
						defensive_coach_boost = 2
					"Silver":
						defensive_coach_boost = 3
					"Gold":
						defensive_coach_boost = 4
					"Platinum":
						defensive_coach_boost = 5
					"Diamond":
						defensive_coach_boost = 6

func set_contract_labels():
	years_label.text = "Years: %d" % [contract_years]
	guaranteed_label.text = "Guaranteed: %d" % [contract_guaranteed_years]
	salary_label.text = "Salary: %.2f M" % [contract_salary]

func check_deal():
	if resign_points >= 100:
		deal_label.text = "Deal"
	else:
		deal_label.text = "No Deal"

func clear_labels():
	resign_interest = 100
	years_label.text = ""
	guaranteed_label.text = ""
	salary_label.text = ""
	deal_label.text = ""
	contract_years = 0
	contract_guaranteed_years = 0
	resign_interest = 0
	contract_salary = 0
	salary_change = 0
	offensive_coach_boost = 0
	defensive_coach_boost = 0
	salary_request = 0
	years = 0
