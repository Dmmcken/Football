extends Node

class_name GamePlay

class GameState:
	var team_left_score = 0
	var team_right_score = 0
	var down = 1
	var to_go = 10
	var los = 25
	var time = 3600
	var offense = ""
	var defense = ""
	var team_left_name = ""
	var team_right_name = ""
	var winner = ""
	var loser = ""


var player_choice = ""
func _on_run_pressed():
	player_choice = "run"

func _on_short_pass_pressed():
	player_choice = "short_pass"
	
func _on_medium_pass_pressed():
	player_choice = "medium_pass"
	
func _on_long_pass_pressed():
	player_choice = "long_pass"

func _on_field_goal_pressed():
	player_choice = "field_goal"

func _on_punt_pressed():
	player_choice = "punt"

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

func make_offensive_decision(game_state):
	var strategy = "normal"
	match game_state.down:
		1, 2:
			strategy = "normal"
		3:
			if game_state.to_go > 3:
				strategy = "short_pass"
			elif game_state.to_go > 7:
				strategy = "medium_pass"
			elif game_state.to_go > 12:
				strategy = "long_pass"
			else: strategy = "run"
		4:
			if game_state.los >= 60:
				strategy = "field_goal"
			else:
				strategy = "punt"
	return decide_play_type(game_state, strategy)

func decide_play_type(game_state, strategy):
	var play_type = "run"
	match strategy:
		"normal":
			play_type = normal_play_decision(game_state)
		"pass":
			play_type = pass_decision(game_state)
		"run":
			play_type = run_decision(game_state)
		"field_goal":
			play_type = "field_goal"
		"punt":
			play_type = "punt"
	return play_type

func normal_play_decision(game_state):
	if game_state.down < 3:
		var chance = randf()
		if chance <0.5:
			return "run"
		elif chance <0.8:
			return "short_pass"
		elif chance <.95:
			return "medium_pass"
		else:
			return "long_pass"

func pass_decision(game_state):
	return "pass"

func run_decision(game_state):
	return "run"

func execute_play(play_type, offensive_team_roster, defensive_team_roster, game_state):
	match play_type:
		"run":
			return calculate_run_play_outcome(offensive_team_roster, defensive_team_roster)
		"short_pass":
			return calculate_short_pass_play_outcome(offensive_team_roster, defensive_team_roster)
		"medium_pass":
			return calculate_medium_pass_play_outcome(offensive_team_roster, defensive_team_roster)
		"long_pass":
			return calculate_long_pass_play_outcome(offensive_team_roster, defensive_team_roster)
		"field_goal":
			return calculate_field_goal_outcome(offensive_team_roster, game_state)
		"punt":
			return calculate_punt_outcome(game_state)

func calculate_run_ability(team_roster):
	var positions = ["RB", "LT", "RT", "RG", "LG", "C"]
	var total_rating = 0
	var count = 0
	
	var highest_ratings = {"RB": 0, "LT": 0, "RT": 0,"RG":0, "LG": 0, "C": 0}
	
	for player_key in team_roster.keys():
		var player = team_roster[player_key]
		var position = player["Position"]
		var rating = player["Rating"]
		
		if position in positions and rating > highest_ratings[position]:
			highest_ratings[position] = rating
		
	for position in positions:
		total_rating += highest_ratings[position]
		if highest_ratings[position] > 0:
			count += 1
		
	return total_rating / max(count, 1)

func calculate_pass_ability(team_roster):
	var positions = ["QB", "LT", "RT", "RG", "LG", "C", "WR"]
	var total_rating = 0
	var count = 0
	
	var highest_ratings = {"QB": 0, "LT": 0, "RT": 0,"RG":0, "LG": 0, "C": 0, "WR": 0}
	
	for player_key in team_roster.keys():
		var player = team_roster[player_key]
		var position = player["Position"]
		var rating = player["Rating"]
		
		if position in positions and rating > highest_ratings[position]:
			highest_ratings[position] = rating
		
	for position in positions:
		total_rating += highest_ratings[position]
		if highest_ratings[position] > 0:
			count += 1
		
	return total_rating / max(count, 1)

func calculate_run_stop_ability(team_roster):
	var positions = ["LE", "RE", "DT", "OLB", "MLB"]
	var total_rating = 0
	var count = 0
	
	var highest_ratings = {"LE": 0, "RE": 0, "DT": 0,"OLB":0, "MLB": 0,}
	
	for player_key in team_roster.keys():
		var player = team_roster[player_key]
		var position = player["Position"]
		var rating = player["Rating"]
		
		if position in positions and rating > highest_ratings[position]:
			highest_ratings[position] = rating
		
	for position in positions:
		total_rating += highest_ratings[position]
		if highest_ratings[position] > 0:
			count += 1
		
	return total_rating / max(count, 1)

func calculate_pass_stop_ability(team_roster):
	var positions = ["LE", "RE", "DT", "CB", "SS", "FS"]
	var total_rating = 0
	var count = 0
	
	var highest_ratings = {"LE": 0, "RE": 0, "DT": 0,"CB":0, "SS": 0, "FS": 0}
	
	for player_key in team_roster.keys():
		var player = team_roster[player_key]
		var position = player["Position"]
		var rating = player["Rating"]
		
		if position in positions and rating > highest_ratings[position]:
			highest_ratings[position] = rating
		
	for position in positions:
		total_rating += highest_ratings[position]
		if highest_ratings[position] > 0:
			count += 1
		
	return total_rating / max(count, 1)

func weighted_run_yards():
	var chance = randf()
	if chance < 0.7:
		return randi() % 6
	elif chance < 0.85:
		return 5 + randi() % 6
	elif chance < 0.92:
		return 10 + randi() % 11
	elif chance < 0.97:
		return 20 + randi() % 21
	else:
		return randf_range(-3, 100)


func calculate_run_play_outcome(offensive_team_roster, defensive_team_roster):
	var run_ability = calculate_run_ability(offensive_team_roster)
	var run_stop_ability = calculate_run_stop_ability(defensive_team_roster)
	var base_yards_gained = weighted_run_yards()
	print("Base Yards: ", base_yards_gained)
	var adjusted_yards_gained = base_yards_gained + run_ability / 10 - run_stop_ability / 15
	adjusted_yards_gained = round(clamp(adjusted_yards_gained, -3, 100))
	var fumble_chance = randf()
	
	var outcome = {"yards_gained": adjusted_yards_gained, "turnover": fumble_chance < 0.03
	}
	return outcome

func weighted_short_pass_yards():
	var chance = randf()
	if chance < 0.05:
		return randi_range(-9, -3)
	elif chance < 0.25:
		return 0
	elif chance < 0.7:
		return randi() % 6
	elif chance < 0.85:
		return 5 + randi() % 6
	elif chance < 0.95:
		return 10 + randi() % 6
	else:
		return randi_range(1, 100)

func calculate_short_pass_play_outcome(offensive_team_roster, defensive_team_roster):
	var pass_ability = calculate_pass_ability(offensive_team_roster)
	var pass_stop_ability = calculate_pass_stop_ability(defensive_team_roster)
	var base_yards_gained = weighted_short_pass_yards()
	var adjusted_yards_gained = base_yards_gained + pass_ability / 10 - pass_stop_ability / 15
	adjusted_yards_gained = round(clamp(adjusted_yards_gained, -9, 100))
	var fumble_chance = randf()
	
	var outcome = {"yards_gained": adjusted_yards_gained, "turnover": fumble_chance < 0.04
	}
	return outcome

func weighted_medium_pass_yards():
	var chance = randf()
	if chance < 0.1:
		return randi_range(-9, -3)
	elif chance < 0.35:
		return 0
	elif chance < 0.7:
		return 5 +randi() % 6
	elif chance < 0.85:
		return 10 + randi() % 6
	elif chance < 0.95:
		return 15 + randi() % 6
	else:
		return randi_range(1, 100)

func calculate_medium_pass_play_outcome(offensive_team_roster, defensive_team_roster):
	var pass_ability = calculate_pass_ability(offensive_team_roster)
	var pass_stop_ability = calculate_pass_stop_ability(defensive_team_roster)
	var base_yards_gained = weighted_medium_pass_yards()
	var adjusted_yards_gained = base_yards_gained + pass_ability / 10 - pass_stop_ability / 15
	adjusted_yards_gained = round(clamp(adjusted_yards_gained, -9, 100))
	var fumble_chance = randf()
	
	var outcome = {"yards_gained": adjusted_yards_gained, "turnover": fumble_chance < 0.04
	}
	return outcome

func weighted_long_pass_yards():
	var chance = randf()
	if chance < 0.15:
		return randi_range(-11, -5)
	elif chance < 0.5:
		return 0
	elif chance < 0.7:
		return 15 +randi() % 10
	elif chance < 0.85:
		return 20 + randi() % 10
	elif chance < 0.95:
		return 25 + randi() % 10
	else:
		return randi_range(35, 100)

func calculate_long_pass_play_outcome(offensive_team_roster, defensive_team_roster):
	var pass_ability = calculate_pass_ability(offensive_team_roster)
	var pass_stop_ability = calculate_pass_stop_ability(defensive_team_roster)
	var base_yards_gained = weighted_long_pass_yards()
	var adjusted_yards_gained = base_yards_gained + pass_ability / 10 - pass_stop_ability / 15
	adjusted_yards_gained = round(clamp(adjusted_yards_gained, -9, 100))
	var fumble_chance = randf()
	
	var outcome = {"yards_gained": adjusted_yards_gained, "turnover": fumble_chance < 0.04
	}
	return outcome

func calculate_field_goal_ability(team_roster):
	var positions = ["K"]
	var total_rating = 0
	var count = 0
	
	var highest_ratings = {"K": 0}
	
	for player_key in team_roster.keys():
		var player = team_roster[player_key]
		var position = player["Position"]
		var rating = player["Rating"]
		
		if position in positions and rating > highest_ratings[position]:
			highest_ratings[position] = rating
		
	for position in positions:
		total_rating += highest_ratings[position]
		if highest_ratings[position] > 0:
			count += 1
		
	return total_rating / max(count, 1)

func calculate_field_goal_outcome(offensive_team_roster, game_state):
	var field_goal_ability = calculate_field_goal_ability(offensive_team_roster)
	var fg_distance = (100 - game_state.los)
	var success_probability = 0.0
	if field_goal_ability < 80:
		if fg_distance <= 10:
			success_probability = 0.98
		elif fg_distance <= 20:
			success_probability = 0.90
		elif fg_distance <= 30:
			success_probability = .75
		elif fg_distance <= 36:
			success_probability = 0.6
		elif fg_distance <= 40:
			success_probability = .4
		elif fg_distance > 40:
			success_probability = 0
	elif field_goal_ability <= 90:
		if fg_distance <= 10:
			success_probability = 0.99
		elif fg_distance <= 20:
			success_probability = 0.93
		elif fg_distance <= 30:
			success_probability = .82
		elif fg_distance <= 36:
			success_probability = 0.7
		elif fg_distance <= 40:
			success_probability = .5
		elif fg_distance > 40:
			success_probability = 0
	elif field_goal_ability > 90:
		if fg_distance <= 10:
			success_probability = 0.995
		elif fg_distance <= 20:
			success_probability = 0.96
		elif fg_distance <= 30:
			success_probability = .87
		elif fg_distance <= 36:
			success_probability = 0.8
		elif fg_distance <= 40:
			success_probability = .65
		elif fg_distance <= 45:
			success_probability = .4
		elif fg_distance > 45:
			success_probability = 0
	var outcome = {"success": false, "points_scored": 0, "yards_gained": 0}
	var random_chance = randf()
	if random_chance <= success_probability:
		outcome.success = true
		if game_state.offense == game_state.team_left_name:
			game_state.team_left_score += 3
		else: game_state.team_right_score += 3
		change_possession(game_state)
		game_state.down = 0
		game_state.to_go = 10
		game_state.los = 25
		print("FIELD GOAL SCORED")
	else:
		change_possession(game_state)
		game_state.down = 0
		game_state.to_go = 10
		game_state.los = 100 - game_state.los
		print("FIELD GOAL MISSED")
	return outcome

func calculate_punt_outcome(game_state):
	game_state.los = 20
	if game_state.los < 1:
		game_state.los = 1
	change_possession(game_state)
	game_state.down = 0
	game_state.to_go = 10
	print("PUNT")
	return {"yards_gained": 0}

func change_possession(game_state):
	var temp = game_state.offense
	game_state.offense = game_state.defense
	game_state.defense = temp

func update_game_state_after_play(play_outcome, game_state):
	game_state.to_go -= play_outcome.yards_gained
	game_state.los += play_outcome.yards_gained
	
	if game_state.los >= 100:
		print(game_state.offense)
		if game_state.offense == game_state.team_left_name:
			game_state.team_left_score += 7
		else: game_state.team_right_score += 7
		change_possession(game_state)
		game_state.los = 25
		game_state.to_go = 10
		game_state.down = 0
		print("TOUCHDOWN")

	if game_state.to_go <= 0:
		game_state.down = 1
		game_state.to_go = 10
	else:
		game_state.down += 1
	if game_state.los + game_state.to_go >= 100:
		game_state.to_go = 100 - game_state.los
	if game_state.down > 4:
		game_state.down = 1
		game_state.to_go = 10
		change_possession(game_state)
		game_state.los = 100 - game_state.los 
	if play_outcome.has("turnover") and play_outcome.turnover:
		game_state.down = 1
		game_state.to_go = 10
		change_possession(game_state)
		game_state.los = 100 - game_state.los
		print("TURNOVER")

	if game_state.time > 10:
		game_state.time -= randi_range(10,39)
	else:
		game_state.time = 0
	print("Down: ", game_state.down, " To Go: ", game_state.to_go, " Offense: ", game_state.offense, " LoS: ", game_state.los, " Left Team Score: ", game_state.team_left_score, " Right Team Score: ", game_state.team_right_score, " Time Remaining: ", game_state.time)

func get_play_description(play_decision, play_outcome):
	var description = "Last Play: "
	match play_decision:
		"run":
			description += "Run for %d yards" % play_outcome.yards_gained
			if play_outcome.turnover:
				description += ". Fumble!"
		"short_pass":
			description += "Pass for %d yards" % play_outcome.yards_gained
			if play_outcome.turnover:
				description += ". Intercepted!"
		"medium_pass":
			description += "Pass for %d yards" % play_outcome.yards_gained
			if play_outcome.turnover:
				description += ". Intercepted!"
		"long_pass":
			description += "Pass for %d yards" % play_outcome.yards_gained
			if play_outcome.turnover:
				description += ". Intercepted!"
		"field_goal":
			if play_outcome.success:
				description += "Field goal successful"
			else:
				description += "Field goal missed"
		"punt":
			description += "Punt"
	return description

func simulate_game(offensive_team_roster, defensive_team_roster, team_left_name, team_right_name, ui_scene_instance):
	var game_state = GameState.new()
	var last_play_description = ""
	game_state.offense = team_left_name
	game_state.defense = team_right_name
	game_state.team_left_name = team_left_name
	game_state.team_right_name = team_right_name
	ui_scene_instance.update_lines(25,10, game_state)
	print(game_state.los, game_state.down)
	
	while game_state.time > 0 and not is_game_over(game_state):
		if game_state.offense == game_state.team_left_name:
			player_choice = ""
			while player_choice == "":
				await get_tree().create_timer(.01).timeout
			var play_decision = player_choice
			print(play_decision)
			var play_outcome = execute_play(play_decision, offensive_team_roster, defensive_team_roster, game_state)
			update_game_state_after_play(play_outcome, game_state)
			
			last_play_description = get_play_description(play_decision, play_outcome)
			ui_scene_instance.update_game_ui(game_state, last_play_description)
			ui_scene_instance.update_lines(game_state.los, game_state.to_go, game_state)
			await get_tree().create_timer(.3).timeout
		else:
			var play_decision = make_offensive_decision(game_state)
			print(play_decision)
			var play_outcome = execute_play(play_decision, offensive_team_roster, defensive_team_roster, game_state)
			update_game_state_after_play(play_outcome, game_state)
		
			last_play_description = get_play_description(play_decision, play_outcome)
			ui_scene_instance.update_game_ui(game_state, last_play_description)
			ui_scene_instance.update_lines(game_state.los, game_state.to_go, game_state)
			await get_tree().create_timer(.01).timeout
	if game_state.time <= 0:
		if game_state.team_left_score > game_state.team_right_score:
			return {"winner": team_left_name, "loser": team_right_name}
		else:
			return {"winner": team_right_name, "loser": team_left_name}
	return game_state

func is_game_over(game_state):
	if game_state.time > 10:
		return false
	else:
		print("Game Over")
		game_state.time = 0
		return true
