extends Node

class_name GameSimulator

class GameState:
	var team_left_score = 0
	var team_right_score = 0
	var down = 1
	var to_go = 10
	var los = 25
	var time = 900
	var offense = ""
	var defense = ""
	var team_left_name = ""
	var team_right_name = ""
	var team_left_roster = {}
	var team_right_roster = {}
	var play_type = ""
	var kickoff = 1
	var quarter = 1
	var clock_drop = 0
	var team_left_oc = {}
	var team_left_dc = {}
	var team_right_oc = {}
	var team_right_dc = {}

var game_stats = {}
var short_passes = 0
var medium_passes = 0
var long_passes = 0
var hail_marys = 0
var injuries_added = 0
var clock_management = "Normal"
var rivalry = 0
var playoff = 0
var team_left_plays = 0
var team_right_plays = 0
var scoreboard_stats = {}

func is_starter_offense(position, depth_chart, injury):
	if position in ["QB", "RB", "TE", "LT", "LG", "RG", "RT", "C"] and depth_chart == 1:
		if injury == 0:
			return true
	elif position == "WR" and depth_chart <= 3:
		if injury == 0:
			return true
	elif position in ["QB", "RB", "TE", "LT", "LG", "RG", "RT", "C"] and depth_chart == 2:
		if injury == 0:
			return true
	elif position == "WR" and depth_chart <= 4:
		if injury == 0:
			return true
	elif position in ["QB", "RB", "TE", "LT", "LG", "RG", "RT", "C"] and depth_chart == 3:
		if injury == 0:
			return true
	elif position == "WR" and depth_chart <= 5:
		if injury == 0:
			return true
	elif position in ["QB", "RB", "TE", "LT", "LG", "RG", "RT", "C"] and depth_chart == 4:
		if injury == 0:
			return true
	elif position == "WR" and depth_chart <= 6:
		if injury == 0:
			return true
	elif position in ["QB", "RB", "TE", "LT", "LG", "RG", "RT", "C"] and depth_chart == 5:
		if injury == 0:
			return true
	elif position == "WR" and depth_chart <= 7:
		if injury == 0:
			return true
	elif position in ["QB", "RB", "TE", "LT", "LG", "RG", "RT", "C"] and depth_chart == 6:
		if injury == 0:
			return true
	elif position == "WR" and depth_chart <= 8:
		if injury == 0:
			return true
	elif position in ["QB", "RB", "TE", "LT", "LG", "RG", "RT", "C"] and depth_chart == 7:
		if injury == 0:
			return true
	elif position == "WR" and depth_chart <= 9:
		if injury == 0:
			return true
	return false

func is_starter_defense(position, depth_chart, injury):
	if position in ["LE", "RE", "MLB", "SS", "FS"] and depth_chart == 1:
		if injury == 0:
			return true
	elif position in ["DT", "OLB"] and depth_chart <= 2:
		if injury == 0:
			return true
	elif position == "CB" and depth_chart <= 3:
		if injury == 0:
			return true
	elif position in ["LE", "RE", "MLB", "SS", "FS"] and depth_chart == 2:
		if injury == 0:
			return true
	elif position in ["DT", "OLB"] and depth_chart <= 3:
		if injury == 0:
			return true
	elif position == "CB" and depth_chart <= 4:
		if injury == 0:
			return true
	elif position in ["LE", "RE", "MLB", "SS", "FS"] and depth_chart == 3:
		if injury == 0:
			return true
	elif position in ["DT", "OLB"] and depth_chart <= 4:
		if injury == 0:
			return true
	elif position == "CB" and depth_chart <= 5:
		if injury == 0:
			return true
	elif position in ["LE", "RE", "MLB", "SS", "FS"] and depth_chart == 4:
		if injury == 0:
			return true
	elif position in ["DT", "OLB"] and depth_chart <= 5:
		if injury == 0:
			return true
	elif position == "CB" and depth_chart <= 6:
		if injury == 0:
			return true
	elif position in ["LE", "RE", "MLB", "SS", "FS"] and depth_chart == 5:
		if injury == 0:
			return true
	elif position in ["DT", "OLB"] and depth_chart <= 6:
		if injury == 0:
			return true
	elif position == "CB" and depth_chart <= 7:
		if injury == 0:
			return true
	elif position in ["LE", "RE", "MLB", "SS", "FS"] and depth_chart == 6:
		if injury == 0:
			return true
	elif position in ["DT", "OLB"] and depth_chart <= 7:
		if injury == 0:
			return true
	elif position == "CB" and depth_chart <= 8:
		if injury == 0:
			return true
	elif position in ["LE", "RE", "MLB", "SS", "FS"] and depth_chart == 7:
		if injury == 0:
			return true
	elif position in ["DT", "OLB"] and depth_chart <= 8:
		if injury == 0:
			return true
	elif position == "CB" and depth_chart <= 9:
		if injury == 0:
			return true
	return false
	
func is_starter_st(position, depth_chart, injury):
	if position in ["K", "P", "R"] and depth_chart == 1:
		if injury == 0:
			return true
	elif position in ["K", "P", "R"] and depth_chart == 2:
		if injury == 0:
			return true
	elif position in ["K", "P", "R"] and depth_chart == 3:
		if injury == 0:
			return true
	elif position in ["K", "P", "R"] and depth_chart == 4:
		if injury == 0:
			return true
	elif position in ["K", "P", "R"] and depth_chart == 5:
		if injury == 0:
			return true
	return false

func make_offensive_decision(game_state):
	var strategy = "normal"
	if game_state.kickoff == 1:
		strategy = "kickoff"
		return decide_play_type(game_state, strategy)
	if game_state.quarter == 2:
		if game_state.time <= 120:
			strategy = "hurry"
			clock_management = "Hurry"
			return decide_play_type(game_state, strategy)
	elif game_state.quarter == 4:
		var offense = ""
		var defense = ""
		var offense_score = 0
		var defense_score = 0
		if game_state.offense == game_state.team_left_name:
			offense = game_state.team_left_name
			offense_score = game_state.team_left_score
			defense = game_state.team_right_name
			defense_score = game_state.team_right_score
		else:
			defense = game_state.team_left_name
			defense_score = game_state.team_left_score
			offense = game_state.team_right_name
			offense_score = game_state.team_right_score
		var score_difference = offense_score - defense_score
		if score_difference == 0:
			if game_state.time <= 120:
				strategy = "hurry"
				clock_management = "Hurry"
				return decide_play_type(game_state, strategy)
			else:
				clock_management = "Normal"
				strategy = "normal"
		elif score_difference < 0:
			if score_difference >= -8:
				if game_state.time <= 120:
					clock_management = "Hurry"
					strategy = "hurry"
					return decide_play_type(game_state, strategy)
				else:
					clock_management = "Normal"
					strategy = "normal"
			elif score_difference >= -16:
				if game_state.time <= 300:
					clock_management = "Hurry"
					strategy = "hurry"
					return decide_play_type(game_state, strategy)
			else:
				strategy = "hurry"
				clock_management = "Hurry"
				return decide_play_type(game_state, strategy)
		else:
			if score_difference <= 8:
				if game_state.time <= 300:
					clock_management = "Chew"
					strategy = "chew"
					return decide_play_type(game_state, strategy)
				else:
					clock_management = "Normal"
					strategy = "normal"
			else:
				if game_state.time <= 450:
					clock_management = "Chew"
					strategy = "chew"
					return decide_play_type(game_state, strategy)
				else:
					clock_management = "Normal"
					strategy = "normal"
	var strategy_rng = randf()
	clock_management = "Normal"
	match game_state.down:
		1, 2:
			strategy = "normal"
		3:
			if game_state.to_go > 4:
				strategy = "pass"
			else: 
				if strategy_rng >= .3:
					strategy = "run"
				else:
					strategy = "pass"
		4:
			if game_state.to_go >= 3:
				if game_state.los >= 60:
					strategy = "field_goal"
				else:
					strategy = "punt"
			else:
				if game_state.los <= 45:
					strategy = "punt"
				elif game_state.los >= 60:
					strategy = "field_goal"
				elif strategy_rng >= .5:
					strategy = "run"
				else:
					strategy = "pass"
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
		"kickoff":
			play_type = "kickoff"
		"hurry":
			play_type = make_hurry_decision(game_state)
		"chew":
			play_type = make_chew_decision(game_state)
	return play_type

func make_hurry_decision(game_state):
	var rng = randf()
	var offense = ""
	var defense = ""
	var offense_score = 0
	var defense_score = 0
	if game_state.offense == game_state.team_left_name:
		offense = game_state.team_left_name
		offense_score = game_state.team_left_score
		defense = game_state.team_right_name
		defense_score = game_state.team_right_score
	else:
		defense = game_state.team_left_name
		defense_score = game_state.team_left_score
		offense = game_state.team_right_name
		offense_score = game_state.team_right_score
	var score_difference = offense_score - defense_score
	if game_state.time <= 30:
		if score_difference < -3:
			return "hail_mary"
		elif score_difference >= -3:
			if game_state.los >= 60:
				return "field_goal"
		else:
			return "hail_mary"
	if game_state.down in [1, 2]:
		if rng <= .5:
			return "short_pass"
		elif rng <= .75:
			return "medium_pass"
		else:
			return "long_pass"
	elif game_state.down == 3:
		if game_state.to_go <= 4:
			return "short_pass"
		elif game_state.to_go <= 8:
			return "medium_pass"
		else:
			return "long_pass"
	elif game_state.down == 4:
		if score_difference >= -3 and game_state.los >= 60:
				return "field_goal"
		elif score_difference in [-9, -10, -11] and game_state.los >= 60 and game_state.to_go > 2:
			return "field_goal"
		elif game_state.to_go < 2 and score_difference == 0 and game_state.los >= 50:
			var fourth_rng = randf()
			if fourth_rng >= .5:
				return "punt"
			elif fourth_rng >= .25:
				return "short_pass"
			else:
				return "run"
		elif score_difference == 0:
			return "punt"
		elif game_state.to_go < 2:
			var fourth_rng = randf()
			if fourth_rng >= .5:
				return "run"
			else:
				return "short_pass"
		elif game_state.to_go < 4:
			return "short_pass"
		elif game_state.to_go < 8:
			return "medium_pass"
		else:
			return "long_pass"

func make_chew_decision(game_state):
	var rng = randf()
	var offense = ""
	var defense = ""
	var offense_score = 0
	var defense_score = 0
	if game_state.offense == game_state.team_left_name:
		offense = game_state.team_left_name
		offense_score = game_state.team_left_score
		defense = game_state.team_right_name
		defense_score = game_state.team_right_score
	else:
		defense = game_state.team_left_name
		defense_score = game_state.team_left_score
		offense = game_state.team_right_name
		offense_score = game_state.team_right_score
	var score_difference = offense_score - defense_score
	if game_state.time <= 20:
		return "run"
	elif game_state.down in [1, 2]:
		return "run"
	elif game_state.down == 3 and game_state.to_go <= 3:
		return "run"
	elif game_state.down == 3 and game_state.to_go > 3:
		if game_state.time > 20 and game_state.time < 40:
			return "run"
		elif game_state.to_go <= 4:
			return "short_pass"
		elif game_state.to_go <= 8:
			return "medium_pass"
		else:
			return "long_pass"
	elif game_state.down == 4:
		if game_state.los >= 60:
			return "field_goal"
		elif game_state.los >= 50 and game_state.to_go <= 3:
			return "run"
		else:
			return "punt"

func normal_play_decision(game_state):
	var rng = randf()
	var selected_team = game_state.offense
	var oc = {}
	if game_state.offense == game_state.team_left_name:
		oc = game_state.team_left_oc
	else:
		oc = game_state.team_right_oc
	if oc["Team"] == selected_team:
		if oc["Focus"] == "Run":
			if rng <= .55:
				return "run"
			elif rng <= .78:
				return "short_pass"
			elif rng <= .9:
				return "medium_pass"
			else:
				return "long_pass"
		else:
			if rng <= .45:
				return "run"
			elif rng <= .7:
				return "short_pass"
			elif rng <= .85:
				return "medium_pass"
			else:
				return "long_pass"
	print("NO COACH FOUND")
	if rng <= .5:
		return "run"
	elif rng <= .75:
		return "short_pass"
	elif rng <= .9:
		return "medium_pass"
	else:
		return "long_pass"

func pass_decision(game_state):
	var rng = randf()
	if game_state.to_go <= 4:
		if rng >= .7:
			return "short_pass"
		elif rng >= .95:
			return "medium_pass"
		else:
			return "long_pass"
	elif game_state.to_go <= 8:
		if rng >= .65:
			return "medium_pass"
		elif rng >= .85:
			return "long_pass"
		else:
			return "short_pass"
	else:
		if rng >= .65:
			return "long_pass"
		elif rng >= .85:
			return "medium_pass"
		else:
			return "short_pass"

func run_decision(game_state):
	return "run"

func execute_play(play_type, offensive_team_roster, defensive_team_roster, game_state):
	match play_type:
		"run":
			return calculate_run_play_outcome(offensive_team_roster, defensive_team_roster, game_state)
		"short_pass":
			short_passes += 1
			return calculate_short_pass_play_outcome(offensive_team_roster, defensive_team_roster, game_state)
			
		"medium_pass":
			medium_passes += 1
			return calculate_medium_pass_play_outcome(offensive_team_roster, defensive_team_roster, game_state)
			
		"long_pass":
			long_passes += 1
			return calculate_long_pass_play_outcome(offensive_team_roster, defensive_team_roster, game_state)
			
		"hail_mary":
			hail_marys += 1
			return calculate_hail_mary_play_outcome(offensive_team_roster, defensive_team_roster, game_state)
			
		"field_goal":
			return calculate_field_goal_outcome(offensive_team_roster, game_state)
		"punt":
			return calculate_punt_outcome(offensive_team_roster, defensive_team_roster, game_state)
		"kickoff":
			return calculate_kickoff_outcome(offensive_team_roster, defensive_team_roster, game_state)

func calculate_run_ability(team_roster, game_state):
	var positions = ["RB", "LT", "RT", "RG", "LG", "C"]
	var total_rating = 0
	var count = 0
	var selected_team = game_state.offense
	var oc = {}
	if game_state.offense == game_state.team_left_name:
		oc = game_state.team_left_oc
	else:
		oc = game_state.team_right_oc
	var trailing = 0
	if game_state.offense == game_state.team_left_name:
		if game_state.team_left_score < game_state.team_right_score:
			trailing = 1
	else:
		if game_state.team_right_score < game_state.team_left_score:
			trailing = 1
	
	for player in team_roster:
		var position = player["Position"]
		var rating = player["Rating"]
		var depth_chart = player["DepthChart"]
		var injury = player["Injury"]
		
		var offensive_coach_boost = 0
		var coach_boosts = []
		if oc["Team"] == selected_team:
			coach_boosts.append(oc["Boost1"])
			coach_boosts.append(oc["Boost2"])
			match oc["Rank"]:
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
			if oc["Trait"] == "Rivalry":
				if rivalry == 1:
					total_rating += (offensive_coach_boost * 2)
			if oc["Trait"] == "Clutch":
				if playoff == 1:
					total_rating += (offensive_coach_boost * 2)
			if oc["Trait"] == "Comeback Kid":
				if trailing == 1:
					total_rating += offensive_coach_boost
		if player["Position"] in coach_boosts:
			if player["Side"] == "Offense":
				rating += offensive_coach_boost
		if position in positions and is_starter_offense(position, depth_chart, injury):
			total_rating += rating
			count += 1
		if position == "RB" and is_starter_offense(position, depth_chart, injury):
			total_rating += (rating * 2)
			count += 2
	return total_rating / max(count, 1)

func calculate_pass_ability(team_roster, game_state):
	var positions = ["QB", "LT", "RT", "RG", "LG", "C", "WR", "TE"]
	var total_rating = 0
	var count = 0
	var selected_team = game_state.offense
	var oc = {}
	if game_state.offense == game_state.team_left_name:
		oc = game_state.team_left_oc
	else:
		oc = game_state.team_right_oc
	
	var trailing = 0
	if game_state.offense == game_state.team_left_name:
		if game_state.team_left_score < game_state.team_right_score:
			trailing = 1
	else:
		if game_state.team_right_score < game_state.team_left_score:
			trailing = 1
	
	for player in team_roster:
		var position = player["Position"]
		var rating = player["Rating"]
		var depth_chart = player["DepthChart"]
		var injury = player["Injury"]
		
		var offensive_coach_boost = 0
		var coach_boosts = []
		if oc["Team"] == selected_team:
			coach_boosts.append(oc["Boost1"])
			coach_boosts.append(oc["Boost2"])
			match oc["Rank"]:
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
		if oc["Trait"] == "Rivalry":
			if rivalry == 1:
				total_rating += (offensive_coach_boost * 2)
		if oc["Trait"] == "Clutch":
			if playoff == 1:
				total_rating += (offensive_coach_boost * 2)
		if oc["Trait"] == "Comeback Kid":
			if trailing == 1:
				total_rating += offensive_coach_boost
		if player["Position"] in coach_boosts:
			if player["Side"] == "Offense":
				rating += offensive_coach_boost
		
		if position in positions and is_starter_offense(position, depth_chart, injury):
			total_rating += rating
			count += 1
		if position == "QB" and is_starter_offense(position, depth_chart, injury):
			total_rating += (rating * 4)
			count += 4
	return total_rating / max(count, 1)

func calculate_run_stop_ability(team_roster, game_state):
	var positions = ["LE", "RE", "DT", "OLB", "MLB"]
	var total_rating = 0
	var count = 0
	var selected_team = game_state.defense
	var dc = {}
	if game_state.defense == game_state.team_left_name:
		dc = game_state.team_left_dc
	else:
		dc = game_state.team_right_dc
	
	var leading = 0
	if game_state.offense == game_state.team_left_name:
		if game_state.team_left_score < game_state.team_right_score:
			leading = 1
	else:
		if game_state.team_right_score < game_state.team_left_score:
			leading = 1
	
	for player in team_roster:
		var position = player["Position"]
		var rating = player["Rating"]
		var depth_chart = player["DepthChart"]
		var injury = player["Injury"]
		
		var defensive_coach_boost = 0
		var coach_boosts = []
		if dc["Team"] == selected_team:
			coach_boosts.append(dc["Boost1"])
			coach_boosts.append(dc["Boost2"])
			match dc["Rank"]:
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
		if dc["Trait"] == "Rivalry":
			if rivalry == 1:
				total_rating += (defensive_coach_boost * 2)
		if dc["Trait"] == "Clutch":
			if playoff == 1:
				total_rating += (defensive_coach_boost * 2)
		if dc["Trait"] == "Closer":
			if leading == 1:
				total_rating += defensive_coach_boost
		if player["Position"] in coach_boosts:
				rating += defensive_coach_boost
		
		if position in positions and is_starter_defense(position, depth_chart, injury):
			total_rating += rating
			count += 1
	var defensive_coach_boost = 0

	if dc["Team"] == selected_team:
		if dc["Focus"] == "Run Stop":
			match dc["Rank"]:
				"Copper":
					defensive_coach_boost = 2
				"Bronze":
					defensive_coach_boost = 4
				"Silver":
					defensive_coach_boost = 6
				"Gold":
					defensive_coach_boost = 8
				"Platinum":
					defensive_coach_boost = 10
				"Diamond":
					defensive_coach_boost = 12
			total_rating += defensive_coach_boost
		else:
			match dc["Rank"]:
				"Copper":
					defensive_coach_boost = 6
				"Bronze":
					defensive_coach_boost = 5
				"Silver":
					defensive_coach_boost = 4
				"Gold":
					defensive_coach_boost = 3
				"Platinum":
					defensive_coach_boost = 2
				"Diamond":
					defensive_coach_boost = 1
			total_rating -= defensive_coach_boost

	return total_rating / max(count, 1)

func calculate_pass_stop_ability(team_roster, game_state):
	var positions = ["LE", "RE", "DT", "CB", "SS", "FS"]
	var total_rating = 0
	var count = 0
	var selected_team = game_state.defense
	var dc = {}
	if game_state.defense == game_state.team_left_name:
		dc = game_state.team_left_dc
	else:
		dc = game_state.team_right_dc
	
	var leading = 0
	if game_state.offense == game_state.team_left_name:
		if game_state.team_left_score < game_state.team_right_score:
			leading = 1
	else:
		if game_state.team_right_score < game_state.team_left_score:
			leading = 1
	
	for player in team_roster:
		var position = player["Position"]
		var rating = player["Rating"]
		var depth_chart = player["DepthChart"]
		var injury = player["Injury"]
		
		var defensive_coach_boost = 0
		var coach_boosts = []
		if dc["Team"] == selected_team:
			coach_boosts.append(dc["Boost1"])
			coach_boosts.append(dc["Boost2"])
			match dc["Rank"]:
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
		if dc["Trait"] == "Rivalry":
			if rivalry == 1:
				total_rating += (defensive_coach_boost * 2)
		if dc["Trait"] == "Clutch":
			if playoff == 1:
				total_rating += (defensive_coach_boost * 2)
		if dc["Trait"] == "Closer":
			if leading == 1:
				total_rating += defensive_coach_boost
		if player["Position"] in coach_boosts:
				rating += defensive_coach_boost
		
		if position in positions and is_starter_defense(position, depth_chart, injury):
			total_rating += rating
			count += 1
	
	var defensive_coach_boost = 0
	if dc["Team"] == selected_team:
		if dc["Focus"] == "Pass Stop":
			match dc["Rank"]:
				"Copper":
					defensive_coach_boost = 2
				"Bronze":
					defensive_coach_boost = 4
				"Silver":
					defensive_coach_boost = 6
				"Gold":
					defensive_coach_boost = 8
				"Platinum":
					defensive_coach_boost = 10
				"Diamond":
					defensive_coach_boost = 12
			total_rating += defensive_coach_boost
		else:
			match dc["Rank"]:
				"Copper":
					defensive_coach_boost = 6
				"Bronze":
					defensive_coach_boost = 5
				"Silver":
					defensive_coach_boost = 4
				"Gold":
					defensive_coach_boost = 3
				"Platinum":
					defensive_coach_boost = 2
				"Diamond":
					defensive_coach_boost = 1
			total_rating -= defensive_coach_boost
	
	return total_rating / max(count, 1)

func calculate_run_play_outcome(offensive_team_roster, defensive_team_roster, game_state):
	game_state.play_type = "Run"
	var run_ability = calculate_run_ability(offensive_team_roster, game_state)
	var run_stop_ability = calculate_run_stop_ability(defensive_team_roster, game_state)
	var matchup_variation = run_ability - run_stop_ability
	matchup_variation *= .015
	var rng_manip = 1 + matchup_variation
	var outcome_rng = randf()
	outcome_rng *= rng_manip
	var fumble_chance = randf()
	var rb_id = get_starting_rb_id(offensive_team_roster)
	var rushes = 1
	var yards_gained = 0
	var touchdowns = 0
	var fumbles = 0
	var def_td = 0
	var def_id = 0
	var tackles = 1
	var outcome = {"yards_gained": yards_gained, "turnover": 0, "def_td": false, "safety": false}
	var clock_drop = 0
	var distance_to_goal = 100 - game_state.los
	var clock_continue = 0
	var defender_positions = ["LE", "RE", "DT", "OLB", "MLB", "CB", "SS", "FS"]
	
	if outcome_rng <= .15:
		yards_gained = randi_range(-4, 0)
	elif outcome_rng <= .5:
		yards_gained = randi_range(-3, 4)
	elif outcome_rng <= .7:
		yards_gained = randi_range(0, 8)
	elif outcome_rng <= .85:
		yards_gained = randi_range(0, 12)
	elif outcome_rng <= .965:
		yards_gained = randi_range(0, 20)
	else:
		yards_gained = randi_range(0, 100)
	
	if fumble_chance < 0.03:
		fumbles += 1
		outcome.turnover = 1
		var scoop_and_score_rng = randf()
		if scoop_and_score_rng <= .08:
			outcome.def_td = true
			def_td = 1
		else:
			pass
	if game_state.los + yards_gained >= 100:
		touchdowns += 1
		yards_gained = distance_to_goal
	outcome.yards_gained = yards_gained
	update_rushing_stats(rb_id, yards_gained, touchdowns, fumbles, rushes)
	if touchdowns == 0:
		def_id = get_defender_id(game_state, "Run", fumbles, 0, 0, def_td, yards_gained)
		update_defensive_stats(def_id, def_td, tackles, fumbles, 0, 0)
	if game_state.los + yards_gained <= 0:
		outcome.safety = true
	calculate_clock_drop(game_state, "Run", yards_gained, 0)
	return outcome

func get_defender_id(game_state, play_type, fumbles, interceptions, sacks, def_td, yards_gained):
	var defense_roster = []
	if game_state.defense == game_state.team_left_name:
		for player in game_state.team_left_roster:
			if player["Side"] == "Defense":
				defense_roster.append(player)
	else:
		for player in game_state.team_right_roster:
			if player["Side"] == "Defense":
				defense_roster.append(player)
	var injury = 0
	var players_by_position = {}
	for player in defense_roster:
		if player["Injury"] == 1:
			injury = 1
			defense_roster.erase(player)
	
	if injury == 1:
		for player in defense_roster:
			var position = player["Position"]
			if position not in players_by_position:
				players_by_position[position] = []
			players_by_position[position].append(player)
		for position in players_by_position.keys():
			var players = players_by_position[position]
			players.sort_custom(func(a, b): return a["DepthChart"] < b["DepthChart"])
			for index in range(len(players)):
				players[index]["DepthChart"] = index + 1
	
	
	
	var defender_id = 0
	var defender_lottery = []
	if play_type == "Run":
		if yards_gained <= 0:
			for player in defense_roster:
				if player["Position"] == "LE" and player["DepthChart"] == 1:
					var lottery_numbers = player["Rating"]
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "LE" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .1)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "RE" and player["DepthChart"] == 1:
					var lottery_numbers = player["Rating"]
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "RE" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .1)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "DT" and player["DepthChart"] == 1:
					var lottery_numbers = player["Rating"]
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "DT" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .1)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "OLB" and player["DepthChart"] == 1:
					var lottery_numbers = round(player["Rating"] * .7)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "OLB" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .07)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "MLB" and player["DepthChart"] == 1:
					var lottery_numbers = round(player["Rating"] * .7)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "MLB" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .07)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "SS" and player["DepthChart"] == 1:
					var lottery_numbers = round(player["Rating"] * .3)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "SS" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .03)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "FS" and player["DepthChart"] == 1:
					var lottery_numbers = round(player["Rating"] * .2)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "FS" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .02)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "CB" and player["DepthChart"] == 1:
					var lottery_numbers = round(player["Rating"] * .2)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "CB" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .15)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "CB" and player["DepthChart"] == 3:
					var lottery_numbers = round(player["Rating"] * .1)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
		elif yards_gained <= 5:
			for player in defense_roster:
				if player["Position"] == "LE" and player["DepthChart"] == 1:
					var lottery_numbers = player["Rating"]
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "LE" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .1)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "RE" and player["DepthChart"] == 1:
					var lottery_numbers = player["Rating"]
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "RE" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .1)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "DT" and player["DepthChart"] == 1:
					var lottery_numbers = player["Rating"]
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "DT" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .1)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "OLB" and player["DepthChart"] == 1:
					var lottery_numbers = round(player["Rating"] * .8)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "OLB" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .08)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "MLB" and player["DepthChart"] == 1:
					var lottery_numbers = round(player["Rating"] * .8)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "MLB" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .08)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "SS" and player["DepthChart"] == 1:
					var lottery_numbers = round(player["Rating"] * .4)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "SS" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .04)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "FS" and player["DepthChart"] == 1:
					var lottery_numbers = round(player["Rating"] * .3)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "FS" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .03)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "CB" and player["DepthChart"] == 1:
					var lottery_numbers = round(player["Rating"] * .3)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "CB" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .23)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "CB" and player["DepthChart"] == 3:
					var lottery_numbers = round(player["Rating"] * .15)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
		elif yards_gained <= 10:
			for player in defense_roster:
				if player["Position"] == "LE" and player["DepthChart"] == 1:
					var lottery_numbers = round(player["Rating"] * .7)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "LE" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .07)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "RE" and player["DepthChart"] == 1:
					var lottery_numbers = round(player["Rating"] * .7)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "RE" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .07)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "DT" and player["DepthChart"] == 1:
					var lottery_numbers = round(player["Rating"] * .7)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "DT" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .07)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "OLB" and player["DepthChart"] == 1:
					var lottery_numbers = player["Rating"]
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "OLB" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .01)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "MLB" and player["DepthChart"] == 1:
					var lottery_numbers = player["Rating"]
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "MLB" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .1)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "SS" and player["DepthChart"] == 1:
					var lottery_numbers = round(player["Rating"] * .5)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "SS" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .05)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "FS" and player["DepthChart"] == 1:
					var lottery_numbers = round(player["Rating"] * .5)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "FS" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .05)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "CB" and player["DepthChart"] == 1:
					var lottery_numbers = round(player["Rating"] * .5)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "CB" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .35)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "CB" and player["DepthChart"] == 3:
					var lottery_numbers = round(player["Rating"] * .25)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
		else:
			for player in defense_roster:
				if player["Position"] == "LE" and player["DepthChart"] == 1:
					var lottery_numbers = round(player["Rating"] * .3)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "LE" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .03)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "RE" and player["DepthChart"] == 1:
					var lottery_numbers = round(player["Rating"] * .3)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "rE" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .03)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "DT" and player["DepthChart"] == 1:
					var lottery_numbers = round(player["Rating"] * .3)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "DT" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .03)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "OLB" and player["DepthChart"] == 1:
					var lottery_numbers = player["Rating"]
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "OLB" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .1)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "MLB" and player["DepthChart"] == 1:
					var lottery_numbers = player["Rating"]
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "MLB" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .1)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "SS" and player["DepthChart"] == 1:
					var lottery_numbers = player["Rating"]
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "SS" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .1)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "FS" and player["DepthChart"] == 1:
					var lottery_numbers = player["Rating"]
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "FS" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .1)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "CB" and player["DepthChart"] == 1:
					var lottery_numbers = player["Rating"]
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "CB" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .75)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "CB" and player["DepthChart"] == 3:
					var lottery_numbers = round(player["Rating"] * .50)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
	if play_type == "Pass":
		if sacks == 1:
			for player in defense_roster:
				if player["Position"] == "LE" and player["DepthChart"] == 1:
					var lottery_numbers = player["Rating"]
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "LE" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .1)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "RE" and player["DepthChart"] == 1:
					var lottery_numbers = player["Rating"]
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "RE" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .1)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "DT" and player["DepthChart"] == 1:
					var lottery_numbers = player["Rating"]
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "DT" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .1)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "OLB" and player["DepthChart"] == 1:
					var lottery_numbers = round(player["Rating"] * .7)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "OLB" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .07)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "MLB" and player["DepthChart"] == 1:
					var lottery_numbers = round(player["Rating"] * .7)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "MLB" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .07)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "SS" and player["DepthChart"] == 1:
					var lottery_numbers = round(player["Rating"] * .3)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "SS" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .03)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "FS" and player["DepthChart"] == 1:
					var lottery_numbers = round(player["Rating"] * .2)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "FS" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .02)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "CB" and player["DepthChart"] == 1:
					var lottery_numbers = round(player["Rating"] * .15)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "CB" and player["DepthChart"] == 2:
					var lottery_numbers = round(player["Rating"] * .1)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
				elif player["Position"] == "CB" and player["DepthChart"] == 3:
					var lottery_numbers = round(player["Rating"] * .05)
					for i in range(lottery_numbers):
						defender_lottery.append(player["PlayerID"])
		elif interceptions == 1:
			if yards_gained <= 10:
				for player in defense_roster:
					if player["Position"] == "LE" and player["DepthChart"] == 1:
						var lottery_numbers = round(player["Rating"] * .15)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "LE" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .015)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "RE" and player["DepthChart"] == 1:
						var lottery_numbers = round(player["Rating"] * .15)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "RE" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .015)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "DT" and player["DepthChart"] == 1:
						var lottery_numbers = round(player["Rating"] * .15)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "DT" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .015)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "OLB" and player["DepthChart"] == 1:
						var lottery_numbers = player["Rating"]
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "OLB" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .1)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "MLB" and player["DepthChart"] == 1:
						var lottery_numbers = player["Rating"]
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "MLB" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .1)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "SS" and player["DepthChart"] == 1:
						var lottery_numbers = player["Rating"]
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "SS" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .1)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "FS" and player["DepthChart"] == 1:
						var lottery_numbers = player["Rating"]
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "FS" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .1)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "CB" and player["DepthChart"] == 1:
						var lottery_numbers = player["Rating"]
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "CB" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .75)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "CB" and player["DepthChart"] == 3:
						var lottery_numbers = round(player["Rating"] * .50)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
			elif yards_gained <= 20:
				for player in defense_roster:
					if player["Position"] == "LE" and player["DepthChart"] == 1:
						var lottery_numbers = round(player["Rating"] * .07)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "RE" and player["DepthChart"] == 1:
						var lottery_numbers = round(player["Rating"] * .07)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "DT" and player["DepthChart"] == 1:
						var lottery_numbers = round(player["Rating"] * .03)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "OLB" and player["DepthChart"] == 1:
						var lottery_numbers = round(player["Rating"] * .8)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "OLB" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .08)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "MLB" and player["DepthChart"] == 1:
						var lottery_numbers = round(player["Rating"] * .8)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "MLB" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .08)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "SS" and player["DepthChart"] == 1:
						var lottery_numbers = player["Rating"]
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "SS" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .1)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "FS" and player["DepthChart"] == 1:
						var lottery_numbers = player["Rating"]
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "FS" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .1)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "CB" and player["DepthChart"] == 1:
						var lottery_numbers = player["Rating"]
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "CB" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .75)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "CB" and player["DepthChart"] == 3:
						var lottery_numbers = round(player["Rating"] * .50)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
			else:
				for player in defense_roster:
					if player["Position"] == "OLB" and player["DepthChart"] == 1:
						var lottery_numbers = round(player["Rating"] * .3)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "OLB" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .03)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "MLB" and player["DepthChart"] == 1:
						var lottery_numbers = round(player["Rating"] * .3)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "MLB" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .03)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "SS" and player["DepthChart"] == 1:
						var lottery_numbers = player["Rating"]
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "SS" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .1)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "FS" and player["DepthChart"] == 1:
						var lottery_numbers = player["Rating"]
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "FS" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .1)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "CB" and player["DepthChart"] == 1:
						var lottery_numbers = player["Rating"]
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "CB" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .75)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "CB" and player["DepthChart"] == 3:
						var lottery_numbers = round(player["Rating"] * .50)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
		else:
			if yards_gained <= 10:
				for player in defense_roster:
					if player["Position"] == "LE" and player["DepthChart"] == 1:
						var lottery_numbers = round(player["Rating"] * .4)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "LE" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .04)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "RE" and player["DepthChart"] == 1:
						var lottery_numbers = round(player["Rating"] * .4)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "RE" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .04)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "DT" and player["DepthChart"] == 1:
						var lottery_numbers = round(player["Rating"] * .3)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "DT" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .03)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "OLB" and player["DepthChart"] == 1:
						var lottery_numbers = player["Rating"]
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "OLB" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .1)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "MLB" and player["DepthChart"] == 1:
						var lottery_numbers = player["Rating"]
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "MLB" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .1)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "SS" and player["DepthChart"] == 1:
						var lottery_numbers = round(player["Rating"] * .8)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "SS" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .08)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "FS" and player["DepthChart"] == 1:
						var lottery_numbers = round(player["Rating"] * .8)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "FS" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .08)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "CB" and player["DepthChart"] == 1:
						var lottery_numbers = round(player["Rating"] * .8)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "CB" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .5)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "CB" and player["DepthChart"] == 3:
						var lottery_numbers = round(player["Rating"] * .3)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
			elif yards_gained <= 20:
				for player in defense_roster:
					if player["Position"] == "LE" and player["DepthChart"] == 1:
						var lottery_numbers = round(player["Rating"] * .1)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "RE" and player["DepthChart"] == 1:
						var lottery_numbers = round(player["Rating"] * .1)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "DT" and player["DepthChart"] == 1:
						var lottery_numbers = round(player["Rating"] * .05)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "OLB" and player["DepthChart"] == 1:
						var lottery_numbers = player["Rating"]
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "OLB" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .1)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "MLB" and player["DepthChart"] == 1:
						var lottery_numbers = player["Rating"]
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "MLB" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .1)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "SS" and player["DepthChart"] == 1:
						var lottery_numbers = player["Rating"]
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "SS" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .1)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "FS" and player["DepthChart"] == 1:
						var lottery_numbers = player["Rating"]
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "FS" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .1)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "CB" and player["DepthChart"] == 1:
						var lottery_numbers = player["Rating"]
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "CB" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * 75)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "CB" and player["DepthChart"] == 3:
						var lottery_numbers = round(player["Rating"] * .5)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
			else:
				for player in defense_roster:
					if player["Position"] == "OLB" and player["DepthChart"] == 1:
						var lottery_numbers = round(player["Rating"] * .3)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "OLB" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .03)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "MLB" and player["DepthChart"] == 1:
						var lottery_numbers = round(player["Rating"] * .3)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "MLB" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .03)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "SS" and player["DepthChart"] == 1:
						var lottery_numbers = player["Rating"]
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "SS" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .1)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "FS" and player["DepthChart"] == 1:
						var lottery_numbers = player["Rating"]
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "FS" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .1)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "CB" and player["DepthChart"] == 1:
						var lottery_numbers = player["Rating"]
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "CB" and player["DepthChart"] == 2:
						var lottery_numbers = round(player["Rating"] * .75)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
					elif player["Position"] == "CB" and player["DepthChart"] == 3:
						var lottery_numbers = round(player["Rating"] * .5)
						for i in range(lottery_numbers):
							defender_lottery.append(player["PlayerID"])
			
	
	
	var index = randi_range(0, defender_lottery.size() - 1)
	defender_id = defender_lottery[index]
	return defender_id

func get_starting_rb_id(offensive_team_roster):
	var rb_rng = randf()
	for player in offensive_team_roster:
		if rb_rng <= .75:
			if player["Position"] == "RB" and player["DepthChart"] == 1:
				if player["Injury"] == 0:
					return player["PlayerID"]
			elif player["Position"] == "RB" and player["DepthChart"] == 2:
				if player["Injury"] == 0:
					return player["PlayerID"]
			elif player["Position"] == "RB" and player["DepthChart"] == 3:
				if player["Injury"] == 0:
					return player["PlayerID"]
			elif player["Position"] == "RB" and player["DepthChart"] == 4:
				if player["Injury"] == 0:
					return player["PlayerID"]
			elif player["Position"] == "RB" and player["DepthChart"] == 5:
				if player["Injury"] == 0:
					return player["PlayerID"]
			elif player["Position"] == "RB" and player["DepthChart"] == 6:
				if player["Injury"] == 0:
					return player["PlayerID"]
			elif player["Position"] == "RB" and player["DepthChart"] == 7:
				if player["Injury"] == 0:
					return player["PlayerID"]
		else:
			if player["Position"] == "RB" and player["DepthChart"] == 2:
				if player["Injury"] == 0:
					return player["PlayerID"]
			elif player["Position"] == "RB" and player["DepthChart"] == 3:
				if player["Injury"] == 0:
					return player["PlayerID"]
			elif player["Position"] == "RB" and player["DepthChart"] == 4:
				if player["Injury"] == 0:
					return player["PlayerID"]
			elif player["Position"] == "RB" and player["DepthChart"] == 5:
				if player["Injury"] == 0:
					return player["PlayerID"]
			elif player["Position"] == "RB" and player["DepthChart"] == 6:
				if player["Injury"] == 0:
					return player["PlayerID"]
			elif player["Position"] == "RB" and player["DepthChart"] == 7:
				if player["Injury"] == 0:
					return player["PlayerID"]
	return null

func calculate_short_pass_play_outcome(offensive_team_roster, defensive_team_roster, game_state):
	game_state.play_type = "Short Pass"
	var pass_ability = calculate_pass_ability(offensive_team_roster, game_state)
	var pass_stop_ability = calculate_pass_stop_ability(defensive_team_roster, game_state)
	var matchup_variation = pass_ability - pass_stop_ability
	matchup_variation *= .02
	var rng_manip = 1 + matchup_variation
	var outcome_rng = randf()
	outcome_rng *= rng_manip
	var yards_gained = 0
	var sack = 0
	var attempts = 1
	var completions = 0
	var interceptions = 0
	var fumble = 0
	var touchdown = 0
	var def_id = 0
	var qb_id = get_starting_qb_id(offensive_team_roster)
	var rec_id = get_receiver_id(offensive_team_roster)
	var catches = 0
	var outcome = {"yards_gained": yards_gained, "turnover": 0, "def_td": false, "safety": false}
	var distance_to_goal = 100 - game_state.los
	var clock_continue = 0
	var wr_fumble = 0
	var def_td = 0
	var tackles = 0
	var fumbles = 0
	if outcome_rng <= .03:
		interceptions += 1
		yards_gained = randi_range(0, 10)
	elif outcome_rng <= .08:
		sack = 1
		attempts = 0
		yards_gained = randi_range(-9, -2)
		clock_continue = 1
		if outcome_rng <= .047:
			fumble = 1
			
	elif outcome_rng <= .3:
		pass
	elif outcome_rng <= .45:
		var clock_rng = randf()
		if clock_rng <= .20:
			pass
		else:
			clock_continue = 1
		yards_gained = randi_range(-5, 8)
		completions = 1
		catches = 1
	elif outcome_rng <= .8:
		var clock_rng = randf()
		if clock_rng <= .20:
			pass
		else:
			clock_continue = 1
		yards_gained = randi_range(0, 8)
		completions = 1
		catches = 1
	elif outcome_rng <= .9:
		var clock_rng = randf()
		if clock_rng <= .20:
			pass
		else:
			clock_continue = 1
		yards_gained = randi_range(0, 12)
		completions = 1
		catches = 1
	elif outcome_rng <= .98:
		var clock_rng = randf()
		if clock_rng <= .20:
			pass
		else:
			clock_continue = 1
		yards_gained = randi_range(0, 20)
		completions = 1
		catches = 1
	else:
		var clock_rng = randf()
		if clock_rng <= .20:
			pass
		else:
			clock_continue = 1
		yards_gained = randi_range(0, 99)
		completions = 1
		catches = 1
	
	if completions == 1 and (game_state.los + yards_gained) < 100:
		var fumble_rng = randf()
		if fumble_rng <= .98:
			pass
		else:
			wr_fumble = 1
			clock_continue = 0
	if game_state.los + yards_gained >= 100:
		touchdown = 1
		clock_continue = 0
		yards_gained = distance_to_goal
	if interceptions == 1 or fumble == 1 or wr_fumble == 1:
		outcome.turnover = 1
		var def_td_rng = randf()
		if def_td_rng < .09:
			outcome.def_td = true
			def_td = 1
	outcome.yards_gained = yards_gained
	update_passing_stats(qb_id, yards_gained, touchdown, interceptions, completions, attempts, fumble)
	update_receiving_stats(rec_id, yards_gained, touchdown, catches, wr_fumble)
	if fumble == 1 or wr_fumble == 1:
		fumbles = 1
	if touchdown == 0:
		def_id = get_defender_id(game_state, "Pass", fumble, interceptions, sack, def_td, yards_gained)
		update_defensive_stats(def_id, def_td, tackles, fumbles, sack, interceptions)
	if game_state.los + yards_gained <= 0:
		outcome.safety = true
	calculate_clock_drop(game_state, "Pass", yards_gained, clock_continue)
	return outcome
	
func calculate_medium_pass_play_outcome(offensive_team_roster, defensive_team_roster, game_state):
	game_state.play_type = "Medium Pass"
	var pass_ability = calculate_pass_ability(offensive_team_roster, game_state)
	var pass_stop_ability = calculate_pass_stop_ability(defensive_team_roster, game_state)
	var matchup_variation = pass_ability - pass_stop_ability
	matchup_variation *= .02
	var rng_manip = 1 + matchup_variation
	var outcome_rng = randf()
	outcome_rng *= rng_manip
	var yards_gained = 0
	var sack = 0
	var attempts = 1
	var completions = 0
	var interceptions = 0
	var fumble = 0
	var touchdown = 0
	var defender = ""
	var qb_id = get_starting_qb_id(offensive_team_roster)
	var rec_id = get_receiver_id(offensive_team_roster)
	var catches = 0
	var outcome = {"yards_gained": yards_gained, "turnover": 0, "def_td": false, "safety": false}
	var distance_to_goal = 100 - game_state.los
	var clock_continue = 0
	var wr_fumble = 0
	var fumbles = 0
	var def_id = 0
	var def_td = 0
	var tackles = 1
	
	if outcome_rng <= .05:
		interceptions += 1
		yards_gained = randi_range(5, 15)
	elif outcome_rng <= .1:
		sack = 1
		attempts = 0
		yards_gained = randi_range(-9, -2)
		clock_continue = 1
		if outcome_rng <= .068:
			fumble = 1
	elif outcome_rng <= .4:
		pass
	elif outcome_rng <= .75:
		var clock_rng = randf()
		if clock_rng <= .20:
			pass
		else:
			clock_continue = 1
		yards_gained = randi_range(5, 12)
		completions = 1
		catches = 1
	elif outcome_rng <= .9:
		var clock_rng = randf()
		if clock_rng <= .20:
			pass
		else:
			clock_continue = 1
		yards_gained = randi_range(5, 20)
		completions = 1
		catches = 1
	elif outcome_rng <= .98:
		var clock_rng = randf()
		if clock_rng <= .20:
			pass
		else:
			clock_continue = 1
		yards_gained = randi_range(5, 35)
		completions = 1
		catches = 1
	else:
		var clock_rng = randf()
		if clock_rng <= .20:
			pass
		else:
			clock_continue = 1
		yards_gained = randi_range(5, 99)
		completions = 1
		catches = 1
	
	if completions == 1 and (game_state.los + yards_gained) < 100:
		var fumble_rng = randf()
		if fumble_rng <= .98:
			pass
		else:
			wr_fumble = 1
			clock_continue = 0
	if game_state.los + yards_gained >= 100:
		touchdown = 1
		clock_continue = 0
		yards_gained = distance_to_goal
	if interceptions == 1 or fumble == 1 or wr_fumble == 1:
		outcome.turnover = 1
		var def_td_rng = randf()
		if def_td_rng < .09:
			outcome.def_td = true
			def_td = 1
	outcome.yards_gained = yards_gained
	update_passing_stats(qb_id, yards_gained, touchdown, interceptions, completions, attempts, fumble)
	update_receiving_stats(rec_id, yards_gained, touchdown, catches, wr_fumble)
	
	if fumble == 1 or wr_fumble == 1:
		fumbles = 1
	if touchdown == 0:
		def_id = get_defender_id(game_state, "Pass", fumble, interceptions, sack, def_td, yards_gained)
		update_defensive_stats(def_id, def_td, tackles, fumbles, sack, interceptions)
	if game_state.los + yards_gained <= 0:
		outcome.safety = true
	calculate_clock_drop(game_state, "Pass", yards_gained, clock_continue)
	return outcome

func calculate_long_pass_play_outcome(offensive_team_roster, defensive_team_roster, game_state):
	game_state.play_type = "Long Pass"
	var pass_ability = calculate_pass_ability(offensive_team_roster, game_state)
	var pass_stop_ability = calculate_pass_stop_ability(defensive_team_roster, game_state)
	var matchup_variation = pass_ability - pass_stop_ability
	matchup_variation *= .03
	var rng_manip = 1 + matchup_variation
	var outcome_rng = randf()
	outcome_rng *= rng_manip
	var yards_gained = 0
	var sack = 0
	var attempts = 1
	var completions = 0
	var interceptions = 0
	var fumble = 0
	var touchdown = 0
	var defender = ""
	var qb_id = get_starting_qb_id(offensive_team_roster)
	var rec_id = get_receiver_id(offensive_team_roster)
	var catches = 0
	var outcome = {"yards_gained": yards_gained, "turnover": 0, "def_td": false, "safety": false}
	var distance_to_goal = 100 - game_state.los
	var clock_continue = 0
	var wr_fumble = 0
	var def_td = 0
	var fumbles = 0
	var def_id = 0
	var tackles = 1
	
	if outcome_rng <= .06:
		interceptions += 1
		yards_gained = randi_range(10, distance_to_goal)
	elif outcome_rng <= .115:
		sack = 1
		attempts = 0
		yards_gained = randi_range(-9, -2)
		clock_continue = 1
		if outcome_rng <= .082:
			fumble = 1
	elif outcome_rng <= .6:
		pass
	elif outcome_rng <= .8:
		var clock_rng = randf()
		if clock_rng <= .20:
			pass
		else:
			clock_continue = 1
		yards_gained = randi_range(12, 20)
		completions = 1
		catches = 1
	elif outcome_rng <= .9:
		var clock_rng = randf()
		if clock_rng <= .20:
			pass
		else:
			clock_continue = 1
		yards_gained = randi_range(12, 30)
		completions = 1
		catches = 1
	elif outcome_rng <= .98:
		var clock_rng = randf()
		if clock_rng <= .20:
			pass
		else:
			clock_continue = 1
		yards_gained = randi_range(12, 50)
		completions = 1
		catches = 1
	else:
		var clock_rng = randf()
		if clock_rng <= .20:
			pass
		else:
			clock_continue = 1
		yards_gained = randi_range(12, 99)
		completions = 1
		catches = 1
	
	if completions == 1 and (game_state.los + yards_gained) < 100:
		var fumble_rng = randf()
		if fumble_rng <= .98:
			pass
		else:
			wr_fumble = 1
			clock_continue = 0
	if game_state.los + yards_gained >= 100:
		touchdown = 1
		clock_continue = 0
		yards_gained = distance_to_goal
	if interceptions == 1 or fumble == 1 or wr_fumble == 1:
		outcome.turnover = 1
		var def_td_rng = randf()
		if def_td_rng < .09:
			outcome.def_td = true
			def_td = 1
	outcome.yards_gained = yards_gained
	update_passing_stats(qb_id, yards_gained, touchdown, interceptions, completions, attempts, fumble)
	update_receiving_stats(rec_id, yards_gained, touchdown, catches, wr_fumble)
	
	if fumble == 1 or wr_fumble == 1:
		fumbles = 1
	if touchdown == 0:
		def_id = get_defender_id(game_state, "Pass", fumble, interceptions, sack, def_td, yards_gained)
		update_defensive_stats(def_id, def_td, tackles, fumbles, sack, interceptions)
	
	if game_state.los + yards_gained <= 0:
		outcome.safety = true
	calculate_clock_drop(game_state, "Pass", yards_gained, clock_continue)
	return outcome

func calculate_hail_mary_play_outcome(offensive_team_roster, defensive_team_roster, game_state):
	game_state.play_type = "Hail Mary"
	var pass_ability = calculate_pass_ability(offensive_team_roster, game_state)
	var pass_stop_ability = calculate_pass_stop_ability(defensive_team_roster, game_state)
	var matchup_variation = pass_ability - pass_stop_ability
	matchup_variation *= .03
	var rng_manip = 1 + matchup_variation
	var outcome_rng = randf()
	outcome_rng *= rng_manip
	var yards_gained = 0
	var sack = 0
	var attempts = 1
	var completions = 0
	var interceptions = 0
	var fumble = 0
	var touchdown = 0
	var defender = ""
	var qb_id = get_starting_qb_id(offensive_team_roster)
	var rec_id = get_receiver_id(offensive_team_roster)
	var catches = 0
	var outcome = {"yards_gained": yards_gained, "turnover": 0, "def_td": false, "safety": false}
	var distance_to_goal = 100 - game_state.los
	var clock_continue = 0
	var wr_fumble = 0
	var def_td = 0
	var def_id = 0
	var fumbles = 0
	var tackles = 1
	if outcome_rng <= .15:
		interceptions += 1
		yards_gained = randi_range(0, distance_to_goal)
	elif outcome_rng <= .35:
		sack = 1
		attempts = 0
		yards_gained = randi_range(-9, -2)
		clock_continue = 1
		if outcome_rng <= .23:
			fumble = 1
	elif outcome_rng <= .8:
		pass
	else:
		var clock_rng = randf()
		if clock_rng <= .25:
			pass
		else:
			clock_continue = 1
		yards_gained = randi_range(50, 99)
		completions = 1
		catches = 1
	
	if completions == 1 and (game_state.los + yards_gained) < 100:
		var fumble_rng = randf()
		if fumble_rng <= .98:
			pass
		else:
			wr_fumble = 1
			clock_continue = 0
	if game_state.los + yards_gained >= 100:
		touchdown = 1
		clock_continue = 0
		yards_gained = distance_to_goal
	if interceptions == 1 or fumble == 1 or wr_fumble == 1:
		outcome.turnover = 1
		var def_td_rng = randf()
		if def_td_rng < .09:
			outcome.def_td = true
			def_td = 1
	outcome.yards_gained = yards_gained
	update_passing_stats(qb_id, yards_gained, touchdown, interceptions, completions, attempts, fumble)
	update_receiving_stats(rec_id, yards_gained, touchdown, catches, wr_fumble)
	
	if fumble == 1 or wr_fumble == 1:
		fumbles = 1
	if touchdown == 0:
		def_id = get_defender_id(game_state, "Pass", fumble, interceptions, sack, def_td, yards_gained)
		update_defensive_stats(def_id, def_td, tackles, fumbles, sack, interceptions)
	
	if game_state.los + yards_gained <= 0:
		outcome.safety = true
	calculate_clock_drop(game_state, "Pass", yards_gained, clock_continue)
	return outcome

func get_receiver_id(offensive_team_roster):
	var random = randf()
	var offense_roster = []
	var injury = 0
	
	for player in offensive_team_roster:
		if player["Injury"] == 0 and player["Position"] in ["WR", "TE", "RB"]:
			offense_roster.append(player)
		if player["Injury"] == 1 and player["Position"] in ["WR", "TE", "RB"]:
			injury = 1
	
	
	var players_by_position = {}
	if injury == 1:
		for player in offense_roster:
			var position = player["Position"]
			if position not in players_by_position:
				players_by_position[position] = []
			players_by_position[position].append(player)
		for position in players_by_position.keys():
			var players = players_by_position[position]
			players.sort_custom(func(a, b): return a["DepthChart"] < b["DepthChart"])
			for index in range(len(players)):
				players[index]["DepthChart"] = index + 1
	
	var receiver_id = 0
	var offense_lottery = []
	
	for player in offense_roster:
		if player["Position"] == "WR" and player["DepthChart"] == 1:
			var lottery_numbers = player["Rating"]
			for i in range(lottery_numbers):
				offense_lottery.append(player["PlayerID"])
		elif player["Position"] == "WR" and player["DepthChart"] == 2:
			var lottery_numbers = round(player["Rating"] * .75)
			for i in range(lottery_numbers):
				offense_lottery.append(player["PlayerID"])
		elif player["Position"] == "WR" and player["DepthChart"] == 3:
			var lottery_numbers = round(player["Rating"] * .5)
			for i in range(lottery_numbers):
				offense_lottery.append(player["PlayerID"])
		elif player["Position"] == "TE" and player["DepthChart"] == 1:
			var lottery_numbers = round(player["Rating"] * .8)
			for i in range(lottery_numbers):
				offense_lottery.append(player["PlayerID"])
		elif player["Position"] == "TE" and player["DepthChart"] == 2:
			var lottery_numbers = round(player["Rating"] * .3)
			for i in range(lottery_numbers):
				offense_lottery.append(player["PlayerID"])
		elif player["Position"] == "RB" and player["DepthChart"] == 1:
			var lottery_numbers = round(player["Rating"] * .2)
			for i in range(lottery_numbers):
				offense_lottery.append(player["PlayerID"])
		elif player["Position"] == "RB" and player["DepthChart"] == 2:
			var lottery_numbers = round(player["Rating"] * .05)
			for i in range(lottery_numbers):
				offense_lottery.append(player["PlayerID"])
		elif player["Position"] != "RB":
			var lottery_numbers = round(player["Rating"] * .1)
			for i in range(lottery_numbers):
				offense_lottery.append(player["PlayerID"])
	
	var index = randi_range(0, offense_lottery.size() -1)
	receiver_id = offense_lottery[index]
	return receiver_id

func get_starting_qb_id(offensive_team_roster):
	var position = "QB"
	for player in offensive_team_roster:
		if player["Position"] == position and player["DepthChart"] == 1:
			if player["Injury"] == 0:
				return player["PlayerID"]
		elif player["Position"] == position and player["DepthChart"] == 2:
			if player["Injury"] == 0:
				return player["PlayerID"]
		elif player["Position"] == position and player["DepthChart"] == 3:
			if player["Injury"] == 0:
				return player["PlayerID"]
		elif player["Position"] == position and player["DepthChart"] == 4:
			if player["Injury"] == 0:
				return player["PlayerID"]
		elif player["Position"] == position and player["DepthChart"] == 5:
			if player["Injury"] == 0:
				return player["PlayerID"]
		elif player["Position"] == position and player["DepthChart"] == 6:
			if player["Injury"] == 0:
				return player["PlayerID"]
		elif player["Position"] == position and player["DepthChart"] == 7:
			if player["Injury"] == 0:
				return player["PlayerID"]
	return null

func get_returner_id(offensive_team_roster):
	var position = "R"
	for player in offensive_team_roster:
		if player["Position"] == position and player["DepthChart"] == 1:
			if player["Injury"] == 0:
				return player["PlayerID"]
		elif player["Position"] == position and player["DepthChart"] == 2:
			if player["Injury"] == 0:
				return player["PlayerID"]
		elif player["Position"] == position and player["DepthChart"] == 3:
			if player["Injury"] == 0:
				return player["PlayerID"]
		elif player["Position"] == position and player["DepthChart"] == 4:
			if player["Injury"] == 0:
				return player["PlayerID"]
		elif player["Position"] == position and player["DepthChart"] == 5:
			if player["Injury"] == 0:
				return player["PlayerID"]
		elif player["Position"] == position and player["DepthChart"] == 6:
			if player["Injury"] == 0:
				return player["PlayerID"]
		elif player["Position"] == position and player["DepthChart"] == 7:
			if player["Injury"] == 0:
				return player["PlayerID"]
	return null

func get_punter_id(offensive_team_roster):
	var position = "P"
	for player in offensive_team_roster:
		if player["Position"] == position and player["DepthChart"] == 1:
			if player["Injury"] == 0:
				return player["PlayerID"]
		elif player["Position"] == position and player["DepthChart"] == 2:
			if player["Injury"] == 0:
				return player["PlayerID"]
		elif player["Position"] == position and player["DepthChart"] == 3:
			if player["Injury"] == 0:
				return player["PlayerID"]
		elif player["Position"] == position and player["DepthChart"] == 4:
			if player["Injury"] == 0:
				return player["PlayerID"]
		elif player["Position"] == position and player["DepthChart"] == 5:
			if player["Injury"] == 0:
				return player["PlayerID"]
		elif player["Position"] == position and player["DepthChart"] == 6:
			if player["Injury"] == 0:
				return player["PlayerID"]
		elif player["Position"] == position and player["DepthChart"] == 7:
			if player["Injury"] == 0:
				return player["PlayerID"]
	return null

func get_kicker_id(offensive_team_roster):
	var position = "K"
	for player in offensive_team_roster:
		if player["Position"] == position and player["DepthChart"] == 1:
			if player["Injury"] == 0:
				return player["PlayerID"]
		elif player["Position"] == position and player["DepthChart"] == 2:
			if player["Injury"] == 0:
				return player["PlayerID"]
		elif player["Position"] == position and player["DepthChart"] == 3:
			if player["Injury"] == 0:
				return player["PlayerID"]
		elif player["Position"] == position and player["DepthChart"] == 4:
			if player["Injury"] == 0:
				return player["PlayerID"]
		elif player["Position"] == position and player["DepthChart"] == 5:
			if player["Injury"] == 0:
				return player["PlayerID"]
		elif player["Position"] == position and player["DepthChart"] == 6:
			if player["Injury"] == 0:
				return player["PlayerID"]
		elif player["Position"] == position and player["DepthChart"] == 7:
			if player["Injury"] == 0:
				return player["PlayerID"]
	return null

func calculate_field_goal_ability(team_roster):
	var positions = ["K"]
	var total_rating = 0
	var count = 0
	
	var highest_ratings = {"K": 0}
	
	for player in team_roster:
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
	game_state.play_type = "FG"
	var field_goal_ability = calculate_field_goal_ability(offensive_team_roster)
	var fg_distance = (100 - game_state.los)
	var success_probability = 0.0
	var under_30_attempts = 0
	var under_30_makes = 0
	var attempts_30_40 = 0
	var makes_30_40 = 0
	var attempts_41_50 = 0
	var makes_41_50 = 0
	var attempts_51_60 = 0
	var makes_51_60 = 0
	var attempts_61 = 0
	var makes_61 = 0
	var kicker_id = get_kicker_id(offensive_team_roster)
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
	var outcome = {"success": false, "points_scored": 0, "yards_gained": 0}
	var random_chance = randf()
	var kick_length = fg_distance + 18
	if kick_length < 30:
		under_30_attempts = 1
	elif kick_length <= 40:
		attempts_30_40 = 1
	elif kick_length <= 50:
		attempts_41_50 = 1
	elif kick_length <= 60:
		attempts_51_60 = 1
	else:
		attempts_61 = 1
	if random_chance <= success_probability:
		outcome.success = true
		if kick_length < 30:
			under_30_makes = 1
		elif kick_length <= 40:
			makes_30_40 = 1
		elif kick_length <= 50:
			makes_41_50 = 1
		elif kick_length <= 60:
			makes_51_60 = 1
		else:
			makes_61 = 1
		if game_state.offense == game_state.team_left_name:
			game_state.team_left_score += 3
		else: game_state.team_right_score += 3
		change_possession(game_state)
		game_state.down = 1
		game_state.to_go = 10
		game_state.los = 25

	else:
		change_possession(game_state)
		game_state.down = 1
		game_state.to_go = 10
		game_state.los = 100 - game_state.los
	
	update_kicker_stats(kicker_id, under_30_attempts, under_30_makes, attempts_30_40, makes_30_40, attempts_41_50, makes_41_50, attempts_51_60, makes_51_60, attempts_61, makes_61, 0, 0)
	calculate_clock_drop(game_state, "Field Goal", 0, 0)
	return outcome

func calculate_punt_outcome(offensive_team_roster, defensive_team_roster, game_state):
	game_state.play_type = "Punt"
	var punt_rating = 0
	var return_rating = 0
	for player in offensive_team_roster:
		if player["Position"] == "P" and player["DepthChart"] == 1:
			punt_rating = player["Rating"]
	for player in defensive_team_roster:
		if player["Position"] == "R" and player["DepthChart"] == 1:
			return_rating = player["Rating"]
	var touchback = 0
	var touchback_rng = randf()
	var punt_landing_yard = 0
	var kicking_line = game_state.los
	var kick_distance = 0
	var ending_line = 0
	var returner_id = get_returner_id(defensive_team_roster)
	var touchdown = 0
	var return_yards = 0
	var returns = 0
	var punt_yards = 0
	var net_yards = 0
	var punter_id = get_punter_id(offensive_team_roster)
	var punts = 1
	if game_state.los >= 50:
		if punt_rating < 80:
			if touchback_rng > .5:
				touchback = 1
		elif punt_rating < 85:
			if touchback_rng > .43:
				touchback = 1
		elif punt_rating < 90:
			if touchback_rng > .36:
				touchback = 1
		elif punt_rating < 95:
			if touchback_rng > .29:
				touchback = 1
		else:
			if touchback_rng > .22:
				touchback = 1
		if touchback == 0:
			var landing_yard_rng = randf()
			if punt_rating < 80:
				if landing_yard_rng < .5:
					punt_landing_yard = randi_range(80, 90)
				elif landing_yard_rng < .8:
					punt_landing_yard = randi_range(80, 95)
				else:
					punt_landing_yard = randi_range(80, 99)
			elif punt_rating < 85:
				if landing_yard_rng < .4:
					punt_landing_yard = randi_range(80, 90)
				elif landing_yard_rng < .7:
					punt_landing_yard = randi_range(80, 95)
				else:
					punt_landing_yard = randi_range(80, 99)
			elif punt_rating < 90:
				if landing_yard_rng < .3:
					punt_landing_yard = randi_range(80, 90)
				elif landing_yard_rng < .6:
					punt_landing_yard = randi_range(80, 95)
				else:
					punt_landing_yard = randi_range(80, 99)
			elif punt_rating < 95:
				if landing_yard_rng < .2:
					punt_landing_yard = randi_range(80, 90)
				elif landing_yard_rng < .4:
					punt_landing_yard = randi_range(80, 95)
				else:
					punt_landing_yard = randi_range(80, 99)
			else:
					punt_landing_yard = randi_range(80, 99)
	else:
		if punt_rating < 75:
			kick_distance = randi_range(35, 50)
		elif punt_rating < 80:
			kick_distance = randi_range(38, 53)
		elif punt_rating < 85:
			kick_distance = randi_range(41, 56)
		elif punt_rating < 90:
			kick_distance = randi_range(44, 59)
		elif punt_rating < 95:
			kick_distance = randi_range(47, 62)
		else:
			kick_distance = randi_range(50, 65)
		punt_landing_yard = kicking_line + kick_distance
		if punt_landing_yard >= 100:
			touchback = 1
	if touchback == 0:
		var return_rng = randf()
		if return_rating < 75:
			if return_rng < .7:
				ending_line = punt_landing_yard
			elif return_rng < .85:
				ending_line = punt_landing_yard - randi_range(1, 10)
			elif return_rng < .999:
				ending_line = punt_landing_yard - randi_range(1, 20)
			else:
				ending_line = 0
		elif return_rating < 80:
			if return_rng < .7:
				ending_line = punt_landing_yard
			elif return_rng < .8:
				ending_line = punt_landing_yard - randi_range(1, 10)
			elif return_rng < .995:
				ending_line = punt_landing_yard - randi_range(1, 20)
			else:
				ending_line = 0
		elif return_rating < 85:
			if return_rng < .65:
				ending_line = punt_landing_yard
			elif return_rng < .8:
				ending_line = punt_landing_yard - randi_range(1, 12)
			elif return_rng < .99:
				ending_line = punt_landing_yard - randi_range(1, 25)
			else:
				ending_line = 0
		elif return_rating < 90:
			if return_rng < .60:
				ending_line = punt_landing_yard
			elif return_rng < .8:
				ending_line = punt_landing_yard - randi_range(1, 12)
			elif return_rng < .99:
				ending_line = punt_landing_yard - randi_range(1, 30)
			else:
				ending_line = 0
		elif return_rating < 95:
			if return_rng < .60:
				ending_line = punt_landing_yard
			elif return_rng < .75:
				ending_line = punt_landing_yard - randi_range(1, 15)
			elif return_rng < .985:
				ending_line = punt_landing_yard - randi_range(1, 30)
			else:
				ending_line = 0
		else:
			if return_rng < .60:
				ending_line = punt_landing_yard
			elif return_rng < .70:
				ending_line = punt_landing_yard - randi_range(1, 20)
			elif return_rng < .98:
				ending_line = punt_landing_yard - randi_range(1, 35)
			else:
				ending_line = 0
	if touchback == 1:
		ending_line = 80
	var outcome = {"los": 0, "touchdown": false}
	if ending_line <= 0:
		outcome.touchdown = true
		touchdown = 1
		returns = 1
	else:
		outcome.los = ending_line
	if touchback == 0:
		return_yards = punt_landing_yard - ending_line
		if return_yards == 0:
			pass
		else:
			returns = 1
	if touchback == 1:
		punt_yards = 100 - kicking_line
		net_yards = punt_yards - 20
	if touchback == 0:
		punt_yards = punt_landing_yard - kicking_line
		net_yards = ending_line - kicking_line
	update_punter_stats(punter_id, touchback, punt_yards, net_yards, punts)
	update_returner_stats(returner_id, touchdown, return_yards, returns)
	calculate_clock_drop(game_state, "Punt", 0, 0)
	return outcome

func calculate_kickoff_outcome(offensive_team_roster, defensive_team_roster, game_state):
	game_state.play_type = "kickoff"
	var return_rating = 0
	for player in offensive_team_roster:
		if player["Position"] == "R" and player["DepthChart"] == 1:
			return_rating = player["Rating"]
	var touchback = 0
	var onside = 0
	var touchback_rng = randf()
	var ending_line = 0
	if touchback_rng <= .75:
		touchback = 1
	var returner_id = get_returner_id(offensive_team_roster)
	var touchdown = 0
	var return_yards = 0
	var returns = 0
	
	var offense = ""
	var defense = ""
	var offense_score = 0
	var defense_score = 0
	if game_state.offense == game_state.team_left_name:
		offense = game_state.team_left_name
		offense_score = game_state.team_left_score
		defense = game_state.team_right_name
		defense_score = game_state.team_right_score
	else:
		defense = game_state.team_left_name
		defense_score = game_state.team_left_score
		offense = game_state.team_right_name
		offense_score = game_state.team_right_score
	var score_difference = offense_score - defense_score
	
	if game_state.quarter == 4:
		if score_difference < -24:
			if game_state.time <= 390:
				onside = 1
				var onside_rng = randf()
				if onside_rng <= .93:
					ending_line = randi_range(45, 60)
				else:
					change_possession(game_state)
					ending_line = randi_range(40, 55)
		elif score_difference < -16:
			if game_state.time <= 300:
				onside = 1
				var onside_rng = randf()
				if onside_rng <= .93:
					ending_line = randi_range(45, 60)
				else:
					change_possession(game_state)
					ending_line = randi_range(40, 55)
		elif score_difference < -8:
			if game_state.time <= 210:
				onside = 1
				var onside_rng = randf()
				if onside_rng <= .93:
					ending_line = randi_range(45, 60)
				else:
					change_possession(game_state)
					ending_line = randi_range(40, 55)
		elif score_difference < 0:
			if game_state.time <= 120:
				onside = 1
				var onside_rng = randf()
				if onside_rng <= .93:
					ending_line = randi_range(45, 60)
				else:
					change_possession(game_state)
					ending_line = randi_range(40, 55)
		else:
			pass
	if touchback == 0 and onside == 0:
		var return_rng = randf()
		if return_rating <= 75:
			if return_rng <= .5:
				ending_line = randi_range(10, 25)
			elif return_rng <= .8:
				ending_line = randi_range(15, 30)
			elif return_rng <= .999:
				ending_line = randi_range(15, 40)
			else:
				ending_line = 101
		elif return_rating <= 80:
			if return_rng <= .4:
				ending_line = randi_range(10, 25)
			elif return_rng <= .75:
				ending_line = randi_range(15, 30)
			elif return_rng <= .999:
				ending_line = randi_range(15, 40)
			else:
				ending_line = 101
		elif return_rating <= 85:
			if return_rng <= .35:
				ending_line = randi_range(10, 25)
			elif return_rng <= .7:
				ending_line = randi_range(15, 30)
			elif return_rng <= .995:
				ending_line = randi_range(15, 40)
			else:
				ending_line = 101
		elif return_rating <= 90:
			if return_rng <= .3:
				ending_line = randi_range(12, 25)
			elif return_rng <= .6:
				ending_line = randi_range(15, 30)
			elif return_rng <= .99:
				ending_line = randi_range(15, 40)
			else:
				ending_line = 101
		elif return_rating <= 95:
			if return_rng <= .3:
				ending_line = randi_range(15, 25)
			elif return_rng <= .5:
				ending_line = randi_range(15, 30)
			elif return_rng <= .99:
				ending_line = randi_range(15, 40)
			else:
				ending_line = 101
		else:
			if return_rng <= .2:
				ending_line = randi_range(15, 25)
			elif return_rng <= .5:
				ending_line = randi_range(15, 30)
			elif return_rng <= .985:
				ending_line = randi_range(20, 40)
			else:
				ending_line = 101
	if touchback == 1:
		ending_line = 25
	var outcome = {"los": 0, "touchdown": false}
	if ending_line >= 100:
		outcome.touchdown = true
		touchdown = 1
		returns = 1
	else:
		outcome.los = ending_line
	if touchback == 0:
		return_yards = ending_line
		returns = 1
	game_state.kickoff = 0
	update_returner_stats(returner_id, touchdown, return_yards, returns)
	if touchback == 1:
		calculate_clock_drop(game_state, "Kickoff", 0, 0)
	else:
		calculate_clock_drop(game_state, "Kickoff", 1, 0)
	return outcome

func extra_point(team_name, game_state):
	var scoring_team = ""
	var scoring_team_roster = {}
	var scoring_team_score = 0
	var opponent_score = 0
	var kicker_id = 0
	if team_name == game_state.team_left_name:
		scoring_team = game_state.team_left_name
		scoring_team_roster = game_state.team_left_roster
		scoring_team_score = game_state.team_left_score
		opponent_score = game_state.team_right_score
		kicker_id = get_kicker_id(game_state.team_left_roster)
	else:
		scoring_team = game_state.team_right_name
		scoring_team_roster = game_state.team_right_roster
		scoring_team_score = game_state.team_right_score
		opponent_score = game_state.team_left_score
		kicker_id = get_kicker_id(game_state.team_right_roster)
	var score_difference = scoring_team_score - opponent_score
	if score_difference not in [-2, -5, -10, 1, 5]:
		var kicking_rating = 0
		for player in scoring_team_roster:
			if player["Position"] == "K" and player["DepthChart"] == 1:
				kicking_rating = player["Rating"]
		var kick_rng = randf()
		if kicking_rating <= 75:
			if kick_rng < .97:
				update_kicker_stats(kicker_id, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1)
				return 1
			else:
				update_kicker_stats(kicker_id, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0)
				return 0
		elif kicking_rating <= 80:
			if kick_rng < .975:
				update_kicker_stats(kicker_id, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1)
				return 1
			else:
				update_kicker_stats(kicker_id, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0)
				return 0
		elif kicking_rating <= 85:
			if kick_rng < .98:
				update_kicker_stats(kicker_id, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1)
				return 1
			else:
				update_kicker_stats(kicker_id, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0)
				return 0
		elif kicking_rating <= 90:
			if kick_rng < .985:
				update_kicker_stats(kicker_id, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1)
				return 1
			else:
				update_kicker_stats(kicker_id, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0)
				return 0
		elif kicking_rating <= 95:
			if kick_rng < .99:
				update_kicker_stats(kicker_id, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1)
				return 1
			else:
				update_kicker_stats(kicker_id, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0)
				return 0
		else:
			if kick_rng < .995:
				update_kicker_stats(kicker_id, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1)
				return 1
			else:
				update_kicker_stats(kicker_id, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0)
				return 0
	else:
		var two_pt_rng = randf()
		if two_pt_rng < .5:
			return 0
		else:
			return 2

func change_possession(game_state):
	var temp = game_state.offense
	game_state.offense = game_state.defense
	game_state.defense = temp

func calculate_clock_drop(game_state, play_type, yards_gained, clock_continue):
	var offense_score = 0
	var defense_score = 0
	if game_state.offense == game_state.team_left_name:
		offense_score = game_state.team_left_score
		defense_score = game_state.team_right_score
	else:
		offense_score = game_state.team_right_score
		defense_score = game_state.team_left_score
	var score_difference = offense_score - defense_score
	var play_time = 0
	var between_play_time = 0
	if play_type == "Run":
		if yards_gained <= 5:
			play_time = randi_range(6, 11)
		elif yards_gained <= 10:
			play_time = randi_range(7, 12)
		elif yards_gained <= 20:
			play_time = randi_range(8, 14)
		elif yards_gained <= 30:
			play_time = randi_range(9, 15)
		else:
			play_time = randi_range(10, 17)
	elif play_type == "Pass":
		if yards_gained <= 5:
			play_time = randi_range(6, 13)
		elif yards_gained <= 15:
			play_time = randi_range(8, 15)
		elif yards_gained <= 25:
			play_time = randi_range(9, 16)
		else:
			play_time = randi_range(11, 18)
	elif play_type == "Punt":
		play_time = randi_range(9, 17)
	elif play_type == "Field Goal":
		play_time = randi_range(5, 8)
	elif play_type == "Kickoff":
		if yards_gained == 0:
			play_time = 0
		else:
			play_time = randi_range(5, 13)
	if clock_management == "Normal":
		if play_type == "Run":
			var rng = randf()
			if rng < .1:
				between_play_time = 0
			else:
				between_play_time = randi_range(29, 39)
		elif play_type == "Pass":
			if clock_continue == 0:
				between_play_time = 0
			else:
				between_play_time = randi_range(29, 39)
		else:
			between_play_time = 0
	if clock_management == "Hurry":
		if play_type == "Run":
			var rng = randf()
			if rng < .1:
				between_play_time = 0
			else:
				between_play_time = randi_range(11, 25)
		elif play_type == "Pass":
			if clock_continue == 0:
				between_play_time = 0
			else:
				between_play_time = randi_range(11, 25)
		else:
			between_play_time = 0
	if clock_management == "Chew":
		if play_type == "Run":
			var rng = randf()
			if rng < .03:
				between_play_time = 0
			else:
				between_play_time = 39
		elif play_type == "Pass":
			if clock_continue == 0:
				between_play_time = 0
			else:
				between_play_time = 39
		else:
			between_play_time = 39
	
	var time_runoff = play_time + between_play_time
	game_state.time -= time_runoff

func update_game_state_after_play(play_outcome, game_state):
	if game_state.offense == game_state.team_left_name:
		team_left_plays += 1
	else:
		team_right_plays += 1 
	if game_state.play_type == "kickoff":
		if play_outcome.touchdown == true:
			if game_state.offense == game_state.team_left_name:
				game_state.team_left_score += 6
				game_state.team_left_score += extra_point(game_state.team_left_name, game_state)
			else: 
				game_state.team_right_score += 6
				game_state.team_right_score += extra_point(game_state.team_right_name, game_state)
			game_state.los = 20
			game_state.to_go = 10
			game_state.down = 1
			game_state.kickoff = 1
			change_possession(game_state)
		else:
			game_state.los = play_outcome.los
			game_state.to_go = 10
			game_state.down = 1
	elif game_state.play_type == "Punt":
		if play_outcome.touchdown == true:
			if game_state.offense == game_state.team_left_name:
				game_state.team_left_score += 6
				game_state.team_left_score += extra_point(game_state.team_left_name, game_state)
			else: 
				game_state.team_right_score += 6
				game_state.team_right_score += extra_point(game_state.team_right_name, game_state)
			game_state.los = 20
			game_state.to_go = 10
			game_state.down = 1
			change_possession(game_state)
			game_state.kickoff = 1
		else:
			game_state.los = 100 - play_outcome.los
			game_state.to_go = 10
			game_state.down = 1
			change_possession(game_state)
	elif play_outcome.has("safety") and play_outcome.def_td == true:
		if game_state.offense == game_state.team_left_name:
				game_state.team_right_score += 6
				game_state.team_right_score += extra_point(game_state.team_right_name, game_state)
		else: 
			game_state.team_left_score += 6
			game_state.team_left_score += extra_point(game_state.team_left_name, game_state)
		game_state.los = 20
		game_state.to_go = 10
		game_state.down = 1
		game_state.kickoff = 1
	elif play_outcome.has("safety") and play_outcome.safety == true:
		if game_state.offense == game_state.team_left_name:
			game_state.team_right_score += 2
		else:
			game_state.team_left_score += 2
		change_possession(game_state)
		game_state.los = randi_range(20, 40)
		game_state.to_go = 10
		game_state.down = 1
	else:
		game_state.to_go -= play_outcome.yards_gained
		game_state.los += play_outcome.yards_gained
		
		if game_state.los >= 100:

			if game_state.offense == game_state.team_left_name:
				game_state.team_left_score += 6
				game_state.team_left_score += extra_point(game_state.team_left_name, game_state)
			else: 
				game_state.team_right_score += 6
				game_state.team_right_score += extra_point(game_state.team_right_name, game_state)
			game_state.to_go = 10
			game_state.down = 1
			change_possession(game_state)
			game_state.los = 25
			game_state.kickoff = 1


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
		if play_outcome.has("turnover") and play_outcome.turnover == 1:
			game_state.down = 1
			game_state.to_go = 10
			change_possession(game_state)
			game_state.los = 100 - game_state.los


func get_play_description(play_decision, play_outcome):
	var description = "Last Play: "
	match play_decision:
		"run":
			description += "Run for %d yards" % play_outcome.yards_gained
			if play_outcome.turnover:
				description += ". Fumble!"
		"pass":
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

func simulate_game(team_left_roster, team_right_roster, team_left_name, team_right_name, division_rivalry, is_playoff):
	var game_state = GameState.new()
	var last_play_description = ""
	game_state.offense = team_left_name
	game_state.defense = team_right_name
	game_state.team_left_name = team_left_name
	game_state.team_right_name = team_right_name
	game_state.team_left_roster = team_left_roster
	game_state.team_right_roster = team_right_roster
	var offensive_team_roster = ""
	var defensive_team_roster = ""
	for coach in Coaches.team_ocs:
		if coach["Team"] == game_state.team_left_name:
			game_state.team_left_oc = coach
		elif coach["Team"] == game_state.team_right_name:
			game_state.team_right_oc = coach
	for coach in Coaches.team_dcs:
		if coach["Team"] == game_state.team_left_name:
			game_state.team_left_dc = coach
		elif coach["Team"] == game_state.team_right_name:
			game_state.team_right_dc = coach
	rivalry = division_rivalry
	playoff = is_playoff
	
	while not is_game_over(game_state):
		if game_state.offense == team_left_name:
			offensive_team_roster = team_left_roster
			defensive_team_roster = team_right_roster
		else:
			offensive_team_roster = team_right_roster
			defensive_team_roster = team_left_roster
		var play_decision = make_offensive_decision(game_state)
		var play_outcome = execute_play(play_decision, offensive_team_roster, defensive_team_roster, game_state)
		update_game_state_after_play(play_outcome, game_state)
		last_play_description = get_play_description(play_decision, play_outcome)
		#print("OFFENSE: %s DEFENSE: %s LEFT SCORE: %d RIGHT SCORE: %d QUARTER: %d TIME: %d" % [game_state.offense, game_state.defense, game_state.team_left_score, game_state.team_right_score, game_state.quarter, game_state.time])
		#print("LOS: %d DOWN: %d TOGO: %d, PLAY: %s" % [game_state.los, game_state.down, game_state.to_go, game_state.play_type])
		if game_state.time <= 0 and game_state.quarter == 1:
			game_state.quarter = 2
			game_state.time = 900
		if game_state.time <= 0 and game_state.quarter == 2:
			game_state.offense = team_right_name
			game_state.defense = team_left_name
			game_state.kickoff = 1
			game_state.quarter = 3
			game_state.time = 900
		if game_state.time <= 0 and game_state.quarter == 3:
			game_state.quarter = 4
			game_state.time = 900
	if is_game_over(game_state):
		injuries_added = 0
		var left_team_stats = get_left_team_stats(game_state)
		var right_team_stats = get_right_team_stats(game_state)
		if game_state.team_left_score > game_state.team_right_score:
			return {"winner": team_left_name, "loser": team_right_name, "team_left_score": game_state.team_left_score, "team_right_score": game_state.team_right_score, "team_left_stats": left_team_stats, "team_right_stats": right_team_stats}
		else:
			return {"winner": team_right_name, "loser": team_left_name, "team_left_score": game_state.team_left_score, "team_right_score": game_state.team_right_score, "team_left_stats": left_team_stats, "team_right_stats": right_team_stats}
		scoreboard_stats.clear()
		
	return game_state

func is_game_over(game_state):
	if game_state.quarter in [1, 2, 3]:
		return false
	if game_state.time > 10:
		return false
	if game_state.time <= 10 and game_state.quarter >= 4:
		if game_state.team_left_score != game_state.team_right_score:
			game_state.time = 0
			#print("LEFT SCORE: %d RIGHT SCORE %d" % [game_state.team_left_score, game_state.team_right_score])
			#print("Short Passes %d Medium Passes %d Long Passes %d Hail Marys %d" % [short_passes, medium_passes, long_passes, hail_marys])
			team_left_plays = 0
			team_right_plays = 0
			if playoff == 0:
				SeasonStats.update_season_stats(game_stats)
			if game_stats.size() > 0:
				scoreboard_stats = game_stats.duplicate()
			game_stats.clear()
			injuries_added = 0
			return true
		else:
			game_state.quarter += 1
			game_state.kickoff = 1
			var teams = [game_state.team_left_name, game_state.team_right_name]
			var coin_toss = randi_range(0, 1)
			var ot_offense = teams[coin_toss]
			if ot_offense == game_state.team_left_name:
				game_state.offense = game_state.team_left_name
				game_state.defense = game_state.team_right_name
			else:
				game_state.offense = game_state.team_right_name
				game_state.defense = game_state.team_left_name
			game_state.time = 600
			return false

func get_left_team_stats(game_state):
	var left_team_stats = []
	var team_left_roster = []
	for player in game_state.team_left_roster:
		team_left_roster.append(player["PlayerID"])
	for player in scoreboard_stats:
		if player in team_left_roster:
			scoreboard_stats[player]["PlayerID"] = player
			left_team_stats.append(scoreboard_stats[player])
	return left_team_stats

func get_right_team_stats(game_state):
	var right_team_stats = []
	var team_right_roster = []
	for player in game_state.team_right_roster:
		team_right_roster.append(player["PlayerID"])
	for player in scoreboard_stats:
		if player in team_right_roster:
			scoreboard_stats[player]["PlayerID"] = player
			right_team_stats.append(scoreboard_stats[player])
	return right_team_stats

func update_passing_stats(PlayerID, yards_gained, touchdowns, interceptions, completions, attempts, fumbles):
	if not game_stats.has(PlayerID):
		game_stats[PlayerID] = {"pass_yards": 0, "pass_tds": 0, "interceptions": 0, "completions": 0, "attempts": 0, "fumbles": 0}
	game_stats[PlayerID]["pass_yards"] += yards_gained
	game_stats[PlayerID]["pass_tds"] += touchdowns
	game_stats[PlayerID]["interceptions"] += interceptions
	game_stats[PlayerID]["completions"] += completions
	game_stats[PlayerID]["attempts"] += attempts
	game_stats[PlayerID]["fumbles"] += fumbles

func update_rushing_stats(PlayerID, yards_gained, touchdowns, fumbles, rushes):
	if not game_stats.has(PlayerID):
		game_stats[PlayerID] = {"rush_yards": 0, "rush_tds": 0, "fumbles": 0, "rushes": 0, "rec_yards": 0, "rec_tds": 0, "catches": 0}
	game_stats[PlayerID]["rush_yards"] += yards_gained
	game_stats[PlayerID]["rush_tds"] += touchdowns
	game_stats[PlayerID]["fumbles"] += fumbles
	game_stats[PlayerID]["rushes"] += rushes

func update_receiving_stats(PlayerID, yards_gained, touchdowns, catches, wr_fumble):
	if not game_stats.has(PlayerID):
		game_stats[PlayerID] = {"rush_yards": 0, "rush_tds": 0, "rushes": 0, "rec_yards": 0, "rec_tds": 0, "catches": 0, "fumbles": 0}
	game_stats[PlayerID]["rec_yards"] += yards_gained
	game_stats[PlayerID]["rec_tds"] += touchdowns
	game_stats[PlayerID]["catches"] += catches
	game_stats[PlayerID]["fumbles"] += wr_fumble

func update_defensive_stats(PlayerID, def_touchdowns, tackles, fumbles, sacks, interceptions):
	if not game_stats.has(PlayerID):
		game_stats[PlayerID] = {"touchdowns": 0, "tackles": 0, "forced_fumbles": 0, "sacks": 0, "interceptions": 0}
	game_stats[PlayerID]["touchdowns"] += def_touchdowns
	game_stats[PlayerID]["tackles"] += tackles
	game_stats[PlayerID]["forced_fumbles"] += fumbles
	game_stats[PlayerID]["sacks"] += sacks
	game_stats[PlayerID]["interceptions"] += interceptions

func update_returner_stats(PlayerID, touchdowns, return_yards, returns):
	if not game_stats.has(PlayerID):
		game_stats[PlayerID] = {"touchdowns": 0, "return_yards": 0, "returns": 0}
	game_stats[PlayerID]["touchdowns"] += touchdowns
	game_stats[PlayerID]["return_yards"] += return_yards
	game_stats[PlayerID]["returns"] += returns

func update_punter_stats(PlayerID, touchbacks, punt_yards, net_yards, punts):
	if not game_stats.has(PlayerID):
		game_stats[PlayerID] = {"touchbacks": 0, "punt_yards": 0, "net_yards": 0, "punts": 0}
	game_stats[PlayerID]["touchbacks"] += touchbacks
	game_stats[PlayerID]["punt_yards"] += punt_yards
	game_stats[PlayerID]["net_yards"] += net_yards
	game_stats[PlayerID]["punts"] += punts

func update_kicker_stats(PlayerID, under_30_attempts, under_30_makes, attempts_30_40, makes_30_40, attempts_41_50, makes_41_50, attempts_51_60, makes_51_60, attempts_61, makes_61, xp_attempts, xp_makes):
	if not game_stats.has(PlayerID):
		game_stats[PlayerID] = {"under_30_attempts": 0, "under_30_makes": 0, "attempts_30_40": 0, "makes_30_40": 0, "attempts_41_50": 0, "makes_41_50": 0, "attempts_51_60": 0, "makes_51_60": 0, "attempts_61": 0, "makes_61": 0, "xp_attempts": 0, "xp_makes": 0}
	game_stats[PlayerID]["under_30_attempts"] += under_30_attempts
	game_stats[PlayerID]["under_30_makes"] += under_30_makes
	game_stats[PlayerID]["attempts_30_40"] += attempts_30_40
	game_stats[PlayerID]["makes_30_40"] += makes_30_40
	game_stats[PlayerID]["attempts_41_50"] += attempts_41_50
	game_stats[PlayerID]["makes_41_50"] += makes_41_50
	game_stats[PlayerID]["attempts_51_60"] += attempts_51_60
	game_stats[PlayerID]["makes_51_60"] += makes_51_60
	game_stats[PlayerID]["attempts_61"] += attempts_61
	game_stats[PlayerID]["makes_61"] += makes_61
	game_stats[PlayerID]["xp_attempts"] += xp_attempts
	game_stats[PlayerID]["xp_makes"] += xp_makes
