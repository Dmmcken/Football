extends Node

var team_rosters = {}
var selected_team = GameData.get_selected_team_name()
var first_names = []
var last_names = []
var dead_cap = []

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

func generate_random_starter(side, position):
	var player = {}
	first_names = load_first_names()
	last_names = load_last_names()
	
	var first_names_array = first_names.keys()
	var last_names_array = last_names.keys()
	var random_index = randi() % first_names_array.size()
	var salary_rng = randf()
	var rookie_contract = 0
	
	player["FirstName"] = first_names_array[random_index]
	player["LastName"] = last_names_array[randi() % last_names_array.size()]
	player["Side"] = side
	player["Position"] = position
	if player["Position"] in ["QB", "P", "K"]:
		player["Age"] = randi() % 18 + 21
	elif player["Position"] in ["RB", "R"]:
		player["Age"] = randi() % 12 + 21
	else:
		player["Age"] = randi() % 15 + 21
	if player["Age"] >= 27:
		var rating_rng = randf()
		if rating_rng < .5:
			player["Rating"] = randi() % 20 + 70
		elif rating_rng < .75:
			player["Rating"] = randi() % 25 + 70
		else:
			player["Rating"] = randi() % 30 + 70
	else:
		var rating_rng = randf()
		if rating_rng <= .5:
			player["Rating"] = randi() % 15 + 70
		else:
			player["Rating"] = randi() % 25 + 70
	player["PlayerID"] = str(randi() % 100000000).pad_zeros(8)
	player["Potential"] = generate_potential()
	if player["Age"] >= 27:
		player["Salary"] = generate_salary(player["Position"], player["Rating"], player["Potential"])
	elif player["Age"] == 26:
		if salary_rng <= .6:
			player["Salary"] = generate_salary(player["Position"], player["Rating"], player["Potential"])
		else:
			player["Salary"] = generate_rookie_salary(player["Age"], player["Rating"], player["Potential"])
			rookie_contract = 1
	elif player["Age"] == 25:
		if salary_rng <= .35:
			player["Salary"] = generate_salary(player["Position"], player["Rating"], player["Potential"])
		else:
			player["Salary"] = generate_rookie_salary(player["Age"], player["Rating"], player["Potential"])
			rookie_contract = 1
	elif player["Age"] == 24:
		if salary_rng <= .1:
			player["Salary"] = generate_salary(player["Position"], player["Rating"], player["Potential"])
		else:
			player["Salary"] = generate_rookie_salary(player["Age"], player["Rating"], player["Potential"])
			rookie_contract = 1
	else:
		player["Salary"] = generate_rookie_salary(player["Age"], player["Rating"], player["Potential"])
		rookie_contract = 1
	if rookie_contract == 0:
		player["Remaining Contract"] = randi() % 5 + 1
	else:
		player["Remaining Contract"] = generate_rookie_contract_len(player["Age"])
	if rookie_contract == 1:
		player["Guaranteed Years"] = player["Remaining Contract"] - 2
		if player["Guaranteed Years"] <= 0:
			player["Guaranteed Years"] = 0
	else:
		var rand_years = randi() % 4
		player["Guaranteed Years"] = player["Remaining Contract"] - rand_years
		if player["Guaranteed Years"] <= 0:
			player["Guaranteed Years"] = 0
		elif player["Guaranteed Years"] >= 3:
			player["Guaranteed Years"] = 3
	if rookie_contract == 1:
		if player["Remaining Contract"] >= 4:
			player["Rookie"] = 1
		else:
			player["Rookie"] = 0
	else:
		player["Rookie"] = 0
	player["Trade Value"] = 0
	player["Scouted"] = 0
	player["Injury"] = 0
	player["Injury Length"] = 0
	return player

func generate_random_backup(side, position):
	var player = {}
	first_names = load_first_names()
	last_names = load_last_names()
	
	var first_names_array = first_names.keys()
	var last_names_array = last_names.keys()
	var random_index = randi() % first_names_array.size()
	var salary_rng = randf()
	var rookie_contract = 0
	player["FirstName"] = first_names_array[random_index]
	player["LastName"] = last_names_array[randi() % last_names_array.size()]
	player["Side"] = side
	player["Position"] = position
	if player["Position"] in ["QB", "P", "K"]:
		player["Age"] = randi() % 18 + 21
	elif player["Position"] in ["RB", "R"]:
		player["Age"] = randi() % 12 + 21
	else:
		player["Age"] = randi() % 15 + 21
	if player["Position"] == "QB":
		player["Rating"] = randi() % 20 + 55
	else:
		if player["Age"] >= 27:
			player["Rating"] = randi() % 32 + 50
		else:
			var rating_rng = randf()
			if rating_rng <= .5:
				player["Rating"] = randi() % 25 + 50
			else:
				player["Rating"] = randi() % 32 + 50
	player["PlayerID"] = str(randi() % 100000000).pad_zeros(8)
	player["Potential"] = generate_potential()
	if player["Age"] >= 27:
		player["Salary"] = generate_salary(player["Position"], player["Rating"], player["Potential"])
	elif player["Age"] == 26:
		if salary_rng <= .6:
			player["Salary"] = generate_salary(player["Position"], player["Rating"], player["Potential"])
		else:
			player["Salary"] = generate_rookie_salary(player["Age"], player["Rating"], player["Potential"])
			rookie_contract = 1
	elif player["Age"] == 25:
		if salary_rng <= .35:
			player["Salary"] = generate_salary(player["Position"], player["Rating"], player["Potential"])
		else:
			player["Salary"] = generate_rookie_salary(player["Age"], player["Rating"], player["Potential"])
			rookie_contract = 1
	elif player["Age"] == 24:
		if salary_rng <= .1:
			player["Salary"] = generate_salary(player["Position"], player["Rating"], player["Potential"])
		else:
			player["Salary"] = generate_rookie_salary(player["Age"], player["Rating"], player["Potential"])
			rookie_contract = 1
	else:
		player["Salary"] = generate_rookie_salary(player["Age"], player["Rating"], player["Potential"])
		rookie_contract = 1
	if rookie_contract == 0:
		player["Remaining Contract"] = randi() % 5 + 1
	else:
		player["Remaining Contract"] = generate_rookie_contract_len(player["Age"])
	if rookie_contract == 1:
		player["Guaranteed Years"] = player["Remaining Contract"] - 2
		if player["Guaranteed Years"] <= 0:
			player["Guaranteed Years"] = 0
	else:
		var rand_years = randf()
		if randf() <= .5:
			player["Guaranteed Years"] = player["Remaining Contract"] - 4
		elif randf() <= .8:
			player["Guaranteed Years"] = player["Remaining Contract"] - 3
		else:
			player["Guaranteed Years"] = player["Remaining Contract"] - 2
		if player["Guaranteed Years"] <= 0:
			player["Guaranteed Years"] = 0
		elif player["Guaranteed Years"] >= 2:
			player["Guaranteed Years"] = 2
	if rookie_contract == 1:
		if player["Remaining Contract"] >= 4:
			player["Rookie"] = 1
		else:
			player["Rookie"] = 0
	else:
		player["Rookie"] = 0
	player["Scouted"] = 0
	player["Trade Value"] = 0
	player["Injury"] = 0
	player["Injury Length"] = 0
	return player

func generate_random_free_agent(side, position):
	var player = {}
	first_names = load_first_names()
	last_names = load_last_names()
	
	var first_names_array = first_names.keys()
	var last_names_array = last_names.keys()
	var random_index = randi() % first_names_array.size()
	
	player["FirstName"] = first_names_array[random_index]
	player["LastName"] = last_names_array[randi() % last_names_array.size()]
	player["Side"] = side
	player["Position"] = position
	player["Rating"] = randi() % 30 + 50
	player["PlayerID"] = str(randi() % 100000000).pad_zeros(8)
	player["Potential"] = randi() % 2 + 1
	if player["Position"] in ["QB", "P", "K"]:
		player["Age"] = randi() % 16 + 23
	elif player["Position"] in ["RB", "R"]:
		player["Age"] = randi() % 10 + 23
	else:
		player["Age"] = randi() % 13 + 23
	player["Salary"] = generate_salary(player["Position"], player["Rating"], player["Potential"])
	player["Remaining Contract"] = 1
	player["Guaranteed Years"] = 0
	player["Scouted"] = 0
	player["Trade Value"] = 0
	player["Injury"] = 0
	player["Injury Length"] = 0
	player["Rookie"] = 0
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
			
			var num_starters = 1 if position not in ["WR", "CB"] else 2
			var num_backups = positions[side][position] - num_starters
			
			for i in range(num_starters):
				roster.append(generate_random_starter(side, position))
			
			for i in range(num_backups):
				roster.append(generate_random_backup(side, position))
			
	var all_positions_flat = []
	for side in positions.keys():
		for position in positions[side].keys():
			all_positions_flat.append(position)
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var roster_size = randi_range(49, 53)
	while roster.size() < roster_size:
		var random_index = rng.randi_range(0, all_positions_flat.size() - 1)
		var random_position = all_positions_flat[random_index]
		roster.append(generate_random_backup("Offense" if random_position in positions["Offense"] else "Defense", random_position))
	
	roster = assign_depth_charts(roster)
	return roster

func assign_depth_charts(roster):
	var new_roster = []
	var positions = {
		"QB": 2, "RB": 3, "WR": 5, "TE": 2, "RT": 2, "LT": 2, "RG": 2, "LG": 2, "C": 1,
		"LE": 2, "RE": 2, "DT": 3, "OLB": 3, "MLB": 2, "CB": 5, "SS": 2, "FS": 2,
		"K": 1, "P": 1, "R": 1}
	for position in positions:
		var players_at_position = roster.filter(func(p): return p["Position"] == position)
		players_at_position.sort_custom(func(a, b): return a["Rating"] > b["Rating"])
		for i in range(players_at_position.size()):
			players_at_position[i]["DepthChart"] = i + 1
			new_roster.append(players_at_position[i])
	return new_roster

func generate_free_agents():
	var roster = []
	var positions = {
		"Offense": {"QB": randi() % 12 + 8, "RB": randi() % 12 + 8, "WR": randi() % 20 + 10, "TE": randi() % 12 + 8, "RT": randi() % 12 + 8, "LT": randi() % 12 + 8, "RG": randi() % 12 + 8, "LG": randi() % 12 + 8, "C": randi() % 12 + 8},
		"Defense": {"LE": randi() % 12 + 8, "RE": randi() % 12 + 8, "DT": randi() % 12 + 8, "OLB": randi() % 12 + 8, "MLB": randi() % 15 + 10, "CB": randi() % 20 + 8, "SS": randi() % 12 + 8, "FS": randi() % 12 + 8},
		"ST": {"K": randi() % 10 + 6, "P": randi() % 10 + 6, "R": randi() % 10 + 6}
	}
	for side in positions.keys():
		for position in positions[side].keys():
			var position_group = []
			for i in range(positions[side][position]):
				position_group.append(generate_random_free_agent(side, position))
			sort_position(position_group)
			for i in range(position_group.size()):
				position_group[i]["DepthChart"] = 0
				roster.append(position_group[i])
	return roster

var team_names = [
	"New York Spartans", "Charlotte Beasts", "Philadelphia Suns", "DC Senators", "Columbus Hawks", "Milwaukee Owls", "Chicago Warriors", "Baltimore Bombers", "Oklahoma Tornadoes", "New Orleans Voodoo", "Omaha Ducks", "Memphis Pyramids", "Las Vegas Aces", "Oregon Sea Lions", "San Diego Spartans", "Los Angeles Stars", "Miami Pirates", "Boston Wildcats", "Tampa Wolverines", "Georgia Peaches", "Louisville Stallions", "Cleveland Blue Jays", "Indianapolis Cougars", "Detroit Motors", "Dallas Rebels", "Kansas City Badgers", "Houston Bulls", "Nashville Strings", "Seattle Vampires", "Sacramento Golds", "Albuquerque Scorpions", "Phoenix Roadrunners", "Free Agent"
]

func generate_all_team_rosters():
	var all_team_rosters = {}
	for i in range(33):
		var team_name = team_names[i]
		if team_name != "Free Agent":
			all_team_rosters[team_name] = generate_team_roster()
		else:
			all_team_rosters[team_name] = generate_free_agents()
	return all_team_rosters

func _ready():
	team_rosters = generate_all_team_rosters()
	create_deadcap()


func compare_by_rating(player1, player2):
	if player1["Rating"] >= player2["Rating"]:
		return true
	else:
		return false

func sort_position(position_group):
	position_group.sort_custom(compare_by_rating)

func generate_salary(position, rating, potential):
	var minimum = .75
	var salary = 0
	if rating < 70:
		return minimum
	if position == "QB":
		var qb_min = 1
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
		var max = 15
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
	elif position == "WR":
		var min = 1
		var max = 20
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
		var max = 20
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

func generate_rookie_salary(age, rating, potential):
	if age <= 24:
		if rating >= 85:
			if potential >= 4:
				var salaries = [6.9, 6.6, 6.4, 6.2, 5.8, 5.1, 4.5, 4]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
			elif potential >= 2:
				var salaries = [6.2, 5.8, 5.1, 4.5, 4, 3.9, 3.8, 3.2, 2.8, 2.6, 2.4, 2.1]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
			else:
				var salaries = [1.8, 5.1, 4.5, 4, 3.9, 3.8, 3.2, 2.8, 2.6, 2.4, 2.1]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
		elif rating >= 80:
			if potential >= 4:
				var salaries = [6.9, 6.6, 6.4, 6.2, 5.8, 5.1, 4.5, 4, 3.9, 3.8, 3.2, 2.8, 2.6, 2.4, 2.1]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
			elif potential >= 2:
				var salaries = [1.8, 1.6, 1.3, 5.8, 5.1, 4.5, 4, 3.9, 3.8, 3.2, 2.8, 2.6, 2.4, 2.1]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
			else:
				var salaries = [1.8, 1.6, 1.3, 1.1, 4, 3.9, 3.8, 3.2, 2.8, 2.6, 2.4, 2.1]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
		elif rating >= 75:
			if potential >= 4:
				var salaries = [1.8, 1.6, 1.3, 1.1, 4.5, 4, 3.9, 3.8, 3.2, 2.8, 2.6, 2.4, 2.1]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
			elif potential >= 2:
				var salaries = [1.8, 1.6, 1.3, 1.1, .95, 3.9, 3.8, 3.2, 2.8, 2.6, 2.4, 2.1]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
			else:
				var salaries = [1.8, 1.6, 1.3, 1.1, .95, .83, .75, 3.2, 2.8, 2.6, 2.4, 2.1]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
		elif rating >= 70:
			if potential >= 4:
				var salaries = [1.8, 1.6, 1.3, 1.1, .95, 3.9, 3.8, 3.2, 2.8, 2.6, 2.4, 2.1]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
			elif potential >= 2:
				var salaries = [1.8, 1.6, 1.3, 1.1, .95, .83, .75, 2.6, 2.4, 2.1]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
			else:
				var salaries = [1.6, 1.3, 1.1, .95, .83, .75]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
		else:
			var salaries = [1.8, 1.6, 1.3, 1.1, .95, .83, .75, 2.4, 2.1]
			var random_index = randi() % salaries.size()
			var selected_salary = salaries[random_index]
			return selected_salary
	else:
		if rating >= 90:
			if potential >= 4:
				var salaries = [6.9, 6.6, 6.4, 6.2, 5.8, 5.1, 4.5, 4]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
			elif potential >= 2:
				var salaries = [6.2, 5.8, 5.1, 4.5, 4, 3.9, 3.8, 3.2, 2.8, 2.6, 2.4, 2.1]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
			else:
				var salaries = [1.8, 5.1, 4.5, 4, 3.9, 3.8, 3.2, 2.8, 2.6, 2.4, 2.1]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
		elif rating >= 85:
			if potential >= 4:
				var salaries = [6.9, 6.6, 6.4, 6.2, 5.8, 5.1, 4.5, 4, 3.9, 3.8, 3.2, 2.8, 2.6, 2.4, 2.1]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
			elif potential >= 2:
				var salaries = [1.8, 1.6, 1.3, 5.8, 5.1, 4.5, 4, 3.9, 3.8, 3.2, 2.8, 2.6, 2.4, 2.1]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
			else:
				var salaries = [1.8, 1.6, 1.3, 1.1, 4, 3.9, 3.8, 3.2, 2.8, 2.6, 2.4, 2.1]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
		elif rating >= 80:
			if potential >= 4:
				var salaries = [1.8, 1.6, 1.3, 1.1, 4.5, 4, 3.9, 3.8, 3.2, 2.8, 2.6, 2.4, 2.1]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
			elif potential >= 2:
				var salaries = [1.8, 1.6, 1.3, 1.1, .95, 3.9, 3.8, 3.2, 2.8, 2.6, 2.4, 2.1]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
			else:
				var salaries = [1.8, 1.6, 1.3, 1.1, .95, .83, .75, 3.2, 2.8, 2.6, 2.4, 2.1]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
		elif rating >= 75:
			if potential >= 4:
				var salaries = [1.8, 1.6, 1.3, 1.1, .95, 3.9, 3.8, 3.2, 2.8, 2.6, 2.4, 2.1]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
			elif potential >= 2:
				var salaries = [1.8, 1.6, 1.3, 1.1, .95, .83, .75, 2.4, 2.1]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
			else:
				var salaries = [1.6, 1.3, 1.1, .95, .83, .75]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
		elif rating >= 70:
			if potential >= 4:
				var salaries = [1.8, 1.6, 1.3, 1.1, .95, 3.2, 2.8, 2.6, 2.4, 2.1]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
			elif potential >= 2:
				var salaries = [1.3, 1.1, .95, .83, .75]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
			else:
				var salaries = [1.1, .95, .83, .75]
				var random_index = randi() % salaries.size()
				var selected_salary = salaries[random_index]
				return selected_salary
		else:
			var salaries = [.83, .75]
			var random_index = randi() % salaries.size()
			var selected_salary = salaries[random_index]
			return selected_salary

func generate_rookie_contract_len(age):
	var length_rng = randf()
	var contract_length = 0
	match age:
		21:
			if length_rng <= .7:
				contract_length = 5
			else:
				contract_length = 4
		22:
			if length_rng <= .4:
				contract_length = 5
			elif length_rng <= .75:
				contract_length = 4
			else:
				contract_length = 3
		23:
			if length_rng <= .2:
				contract_length = 5
			elif length_rng <= .5:
				contract_length = 4
			elif length_rng <= .8:
				contract_length = 3
			else:
				contract_length = 2
		24:
			if length_rng <= .3:
				contract_length = 4
			elif length_rng <= .6:
				contract_length = 3
			elif length_rng <= .8:
				contract_length = 2
			else:
				contract_length = 1
		25:
			if length_rng <= .3:
				contract_length = 3
			elif length_rng <= .6:
				contract_length = 2
			else:
				contract_length = 1
		26:
			if length_rng <= .6:
				contract_length = 2
			else:
				contract_length = 1
		27:
			contract_length = 1
	return contract_length

func potential_multiplier(potential):
	if potential == 1:
		return .7
	elif potential == 2:
		return .8
	elif potential == 3:
		return .9
	elif potential == 4:
		return 1
	elif potential == 5:
		return 1.1
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

func create_deadcap():
	var years = [2024, 2025, 2026, 2027, 2028]
	for year in years:
		var deadcap = {}
		deadcap["Year"] = year
		deadcap["Dead Cap"] = 0
		dead_cap.append(deadcap)

func update_deadcap():
	dead_cap.sort_custom(func(a, b):
		return a["Year"] < b["Year"])
	var old_deadcap = dead_cap[0]
	dead_cap.erase(old_deadcap)
	var highest_year = 0
	dead_cap.sort_custom(func(a, b):
		return a["Year"] > b["Year"])
	highest_year = dead_cap[0]["Year"]
	var deadcap = {}
	deadcap["Year"] = highest_year + 1
	deadcap["Dead Cap"] = 0
	dead_cap.append(deadcap)
