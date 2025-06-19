extends Node2D

var current_week = 1
var wins = 0
var losses = 0
var opponent = ""
var schedule_data = []
var game_simulator = GameSimulator.new()
var game_play = GamePlay.new()
var selected_team = ""
var team_records = {}
var schedule = []
var all_playoff_teams = []
var wild_card_winners = []
var divisional_winners = []
var conference_winners = []
var wild_card_losers = []
var divisional_losers = []
var conference_losers = []
var super_bowl_winner = []
var super_bowl_loser = []
var salary_cap = 0

var current_season = 2024
var retiring_players = []
var last_schedule = 0
var new_injured_players = []
var first_names = []
var last_names = []

func calculate_team_averages(team_name):
	var team_roster = Rosters.team_rosters[team_name]
	var total_offense = 0
	var total_defense = 0
	var total_special_teams = 0
	var count_offense = 0
	var count_defense = 0
	var count_special_teams = 0
	
	for player in team_roster:
		var rating = player.get("Rating", 0)
		var depth_chart = player.get("DepthChart", 0)
		var position = player.get("Position", "")
		var side = player.get("Side", "")
		var injury = player.get("Injury", 0)
		var offensive_coach_boost = 0
		var defensive_coach_boost = 0
		var coach_boosts = []
		for coach in Coaches.team_ocs:
			if coach["Team"] == selected_team:
				coach_boosts.append(coach["Boost1"])
				coach_boosts.append(coach["Boost2"])
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
		for coach in Coaches.team_dcs:
			if coach["Team"] == selected_team:
				coach_boosts.append(coach["Boost1"])
				coach_boosts.append(coach["Boost2"])
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
		if player["Position"] in coach_boosts:
			if player["Side"] == "Offense":
				rating += offensive_coach_boost
			if player["Side"] == "Defense":
				rating += defensive_coach_boost
		if side == "Offense" and is_starter_offense(position, depth_chart):
			total_offense += rating
			count_offense += 1
		elif side == "Defense" and is_starter_defense(position, depth_chart):
			total_defense += rating
			count_defense += 1
		elif side == "ST" and is_starter_st(position, depth_chart):
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

func is_starter_offense(position, depth_chart):
	if position in ["QB", "RB", "TE", "LT", "LG", "RG", "RT", "C"] and depth_chart == 1:
		return true
	elif position == "WR" and depth_chart <= 3:
		return true
	return false

func is_starter_defense(position, depth_chart):
	if position in ["LE", "RE", "MLB", "SS", "FS"] and depth_chart == 1:
		return true
	elif position in ["DT", "OLB"] and depth_chart <= 2:
		return true
	elif position == "CB" and depth_chart <= 3:
		return true
	return false
	
func is_starter_st(position, depth_chart):
	if position in ["K", "P", "R"] and depth_chart == 1:
		return true
	return false

@onready var player_team_label = $PlayerTeam
@onready var week_label = $CurrentWeek
@onready var record_label = $PlayerRecord
@onready var opponent_label = $OpponentTeam
@onready var team_offense_label = $TeamOffense
@onready var team_defense_label = $TeamDefense
@onready var team_st_label = $TeamST
@onready var team_ovr_label = $TeamOVR
@onready var salary_cap_label = $SalaryCap
@onready var best_player_1_label = $BestPlayers1
@onready var best_player_2_label = $BestPlayers2
@onready var best_player_3_label = $BestPlayers3

func _ready():
	add_child(game_simulator)
	add_child(game_play)
	selected_team = GameData.get_selected_team_name()
	set_depth_chart()
	player_team_label.text = selected_team
	week_label.text = "Week " + str(current_week)
	record_label.text = str(wins) + "-" + str(losses)
	schedule = read_schedule("res://JSON Files/MasterSchedule.json")
	opponent = get_opponent_for_week(schedule, selected_team, current_week)
	set_team_ovr()
	get_salary_cap()
	var salary_cap_round = round(salary_cap * 10) / 10.0
	salary_cap_label.text = str(salary_cap_round)
	if opponent == "BYE":
		opponent_label.text = "BYE WEEK"
	else:
		var opponent_roster = Rosters.team_rosters[opponent]
		var opponent_averages = calculate_team_averages(opponent)
		opponent_label.text = "%s - Offense: %d, Defense: %d, Special Teams: %d, Overall: %d" % [opponent, opponent_averages["Offense_Ovr"], opponent_averages["Defense_Ovr"], opponent_averages["Special_Teams_Ovr"], opponent_averages["Team_Ovr"]]
	team_records = load_team_records("res://JSON Files/Team_Records.json")
	create_first_drafts()

func print_playerid():
	for team_name in Rosters.team_rosters.keys():
		print("Team Name: ", team_name)
		var team_roster = Rosters.team_rosters[team_name]
		for player in team_roster:
			print("Player: ", player["Position"], player["PlayerID"], player["DepthChart"])
		print("------")

func set_team_ovr():
	var team_averages = calculate_team_averages(selected_team)
	team_offense_label.text = "%s" % [team_averages["Offense_Ovr"]]
	team_defense_label.text = "%s" % [team_averages["Defense_Ovr"]]
	team_st_label.text = "%s" % [team_averages["Special_Teams_Ovr"]]
	team_ovr_label.text = "%s" % [team_averages["Team_Ovr"]]
	set_team_top_three()

func set_team_top_three():
	var player1 = ""
	var player2 = ""
	var player3 = ""
	var roster = []
	for player in Rosters.team_rosters[selected_team]:
		if player["DepthChart"] == 1:
			roster.append(player)
	roster.sort_custom(func(a, b):
		return a["Rating"] > b["Rating"])
	player1 = roster[0]
	player2 = roster[1]
	player3 = roster[2]
	best_player_1_label.text = "%s %s %s %s" % [player1["Position"], player1["FirstName"], player1["LastName"], player1["Rating"]]
	best_player_2_label.text = "%s %s %s %s" % [player2["Position"], player2["FirstName"], player2["LastName"], player2["Rating"]]
	best_player_3_label.text = "%s %s %s %s" % [player3["Position"], player3["FirstName"], player3["LastName"], player3["Rating"]]

func load_team_records(json_file_path):
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var records_json = JSON.new()
	records_json.parse(file.get_as_text())
	file.close()
	team_records = records_json.get_data()
	return team_records["Sheet1"]

func read_schedule(json_file_path):
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var schedule_json = JSON.new()
	schedule_json.parse(file.get_as_text())
	file.close()
	var full_schedule = schedule_json.get_data()
	var chosen_key = randi_range(1, 16)
	if last_schedule == 0:
		pass
	else:
		if chosen_key == last_schedule:
			if chosen_key != 1:
				chosen_key -= 1
			else:
				chosen_key += 1
	var current_schedule = {}
	for key in full_schedule.keys():
		if int(key) == chosen_key:
			current_schedule = full_schedule[key]
	last_schedule = chosen_key
	return current_schedule

func get_opponent_for_week(schedule, team_name, week):
	for game_key in schedule.keys():
		var game = schedule[game_key]
		if game["week"] == week:
			if game["home"] == str(team_name):
				return game["away"]

			elif game["away"] == str(team_name):
				return game["home"]

func read_team_records(json_file_path):
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var records_json = JSON.new()
	records_json.parse(file.get_as_text())
	file.close
	return records_json.get_data

#func _on_play_button_pressed():
	var current_scene = get_tree().current_scene
	var game_ui_scene = load("res://gameplay.tscn")
	var ui_scene_instance = game_ui_scene.instantiate()
	get_tree().root.add_child(ui_scene_instance)
	get_tree().current_scene = ui_scene_instance
	ui_scene_instance.connect("run_button_pressed", game_play._on_run_pressed)
	ui_scene_instance.connect("short_pass_button_pressed", game_play._on_short_pass_pressed)
	ui_scene_instance.connect("medium_pass_button_pressed", game_play._on_medium_pass_pressed)
	ui_scene_instance.connect("long_pass_button_pressed", game_play._on_long_pass_pressed)
	ui_scene_instance.connect("field_goal_button_pressed", game_play._on_field_goal_pressed)
	ui_scene_instance.connect("punt_button_pressed", game_play._on_punt_pressed)
	var schedule = read_schedule("res://JSON Files/MasterSchedule.json")
	var team_left_name = selected_team
	var team_right_name = get_opponent_for_week(schedule, selected_team, current_week)

	var team_left_key = team_left_name
	var team_right_key = team_right_name
	var team_left_roster = Rosters.team_rosters[team_left_name]
	var team_right_roster = Rosters.team_rosters[team_right_name]
	#game_play.simulate_game(team_left_roster, team_right_roster, team_left_name, team_right_name, ui_scene_instance)
	if team_right_name == "BYE":
		#current_week += 1
		record_label.text = str(wins) + "-" + str(losses)
		week_label.text = "Week " + str(current_week)
		opponent = get_opponent_for_week(schedule, selected_team, current_week)
		if opponent == "BYE":
			opponent_label.text = "BYE WEEK"
		else:
			var opponent_roster = Rosters.team_rosters[opponent]
			var opponent_averages = calculate_team_averages(opponent)
			opponent_label.text = "%s - Offense: %d, Defense: %d, Special Teams: %d, Overall: %d" % [opponent, opponent_averages["Offense_Ovr"], opponent_averages["Defense_Ovr"], opponent_averages["Special_Teams_Ovr"], opponent_averages["Team_Ovr"]]
	else:
		var game_result = await game_play.simulate_game(team_left_roster, team_right_roster, team_left_name, team_right_name, ui_scene_instance)
		update_team_records(game_result.winner, game_result.loser)
		#var team_records = load_team_records("res://JSON Files/Team_Records.json")
		if game_result.winner == selected_team:
			wins += 1
		else:
			losses += 1
	for game_key in schedule.keys():
		var game = schedule[game_key]
		opponent = get_opponent_for_week(schedule, selected_team, current_week)
		if game["week"] == current_week:
			if game["home"] != selected_team and game["away"] != selected_team:
				if game["home"] != opponent and game["away"] != opponent:
					if game["away"] != "BYE":
						var game_result = simulate_game_between_teams(game["home"], game["away"], 0, 0)
						update_team_records(game_result.winner, game_result.loser)
					else:
						pass
	record_label.text = str(wins) + "-" + str(losses)
	week_label.text = "Week " + str(current_week)
	opponent = get_opponent_for_week(schedule, selected_team, current_week)
	if opponent == "BYE":
			opponent_label.text = "BYE WEEK"
	else:
		var opponent_roster = Rosters.team_rosters[opponent]
		var opponent_averages = calculate_team_averages(opponent)
		opponent_label.text = "%s - Offense: %d, Defense: %d, Special Teams: %d, Overall: %d" % [opponent, opponent_averages["Offense_Ovr"], opponent_averages["Defense_Ovr"], opponent_averages["Special_Teams_Ovr"], opponent_averages["Team_Ovr"]]

	current_week += 1
	record_label.text = str(wins) + "-" + str(losses)
	week_label.text = "Week " + str(current_week)
	opponent = get_opponent_for_week(schedule, selected_team, current_week)
	if opponent == "BYE":
		opponent_label.text = "BYE WEEK"
	else:
		var opponent_roster = Rosters.team_rosters[opponent]
		var opponent_averages = calculate_team_averages(opponent)
		opponent_label.text = "%s - Offense: %d, Defense: %d, Special Teams: %d, Overall: %d" % [opponent, opponent_averages["Offense_Ovr"], opponent_averages["Defense_Ovr"], opponent_averages["Special_Teams_Ovr"], opponent_averages["Team_Ovr"]]
	ui_scene_instance.queue_free()
	if current_scene and current_scene.is_inside_tree():
		current_scene.visible = true

func simulate_game_between_teams(home_team, away_team, rivalry, playoff):
	var home_team_roster = Rosters.team_rosters[home_team]
	var away_team_roster = Rosters.team_rosters[away_team]
	return game_simulator.simulate_game(home_team_roster, away_team_roster, home_team, away_team, rivalry, playoff)

func _on_simulate_button_pressed():
	set_team_ovr()
	get_salary_cap()
	var salary_cap_round = round(salary_cap * 10) / 10.0
	salary_cap_label.text = str(salary_cap_round)
	if current_week < 19:
		if salary_cap < 0:
			salary_cap_popup()
			return
		var roster_size = Rosters.team_rosters[selected_team].size()
		if roster_size > 53:
			roster_size_popup()
			return
		var position_mins = check_position_mins()
		if position_mins == 0:
			return
		var injury_mins = check_injury_mins()
		if injury_mins == 0:
			return
	if current_week < 19:
		var team_left_name = selected_team
		var team_right_name = get_opponent_for_week(schedule, selected_team, current_week)

		if team_right_name == "BYE":
			record_label.text = str(wins) + "-" + str(losses)
			week_label.text = "Week " + str(current_week)
			opponent = get_opponent_for_week(schedule, selected_team, current_week)
			if opponent == "BYE":
				opponent_label.text = "BYE WEEK"
			else:
				var opponent_roster = Rosters.team_rosters[opponent]
				var opponent_averages = calculate_team_averages(opponent)
				opponent_label.text = "%s - Offense: %d, Defense: %d, Special Teams: %d, Overall: %d" % [opponent, opponent_averages["Offense_Ovr"], opponent_averages["Defense_Ovr"], opponent_averages["Special_Teams_Ovr"], opponent_averages["Team_Ovr"]]
		else:
			var team_left_key = team_left_name
			var team_right_key = team_right_name
			var team_left_roster = Rosters.team_rosters[team_left_name]
			var team_right_roster = Rosters.team_rosters[team_right_name]
			var rivalry = is_rivalry_game(team_left_name, team_right_name)
			var game_result = game_simulator.simulate_game(team_left_roster, team_right_roster, team_left_name, team_right_name, rivalry, 0)

			if game_result.winner == selected_team:
				wins += 1
			else:
				losses += 1
			update_team_records(game_result.winner, game_result.loser)
			score_popup(team_left_name, team_right_name, game_result.team_left_score, game_result.team_right_score, game_result.team_left_stats, game_result.team_right_stats)

		for game_key in schedule.keys():
			var game = schedule[game_key]
			opponent = get_opponent_for_week(schedule, selected_team, current_week)
			if game["week"] == current_week:
				if game["home"] != selected_team and game["away"] != selected_team:
					if game["home"] != opponent and game["away"] != opponent:
						if game["away"] != "BYE":
							var rivalry = is_rivalry_game(game["home"], game["away"])
							var game_result = simulate_game_between_teams(game["home"], game["away"], rivalry, 0)
							update_team_records(game_result.winner, game_result.loser)
						else:
							pass
		current_week += 1
		boost_ovr()
		if opponent != "BYE":
			injure_players()
		record_label.text = str(wins) + "-" + str(losses)
		update_draft_order()
		if current_week < 19:
			week_label.text = "Week " + str(current_week)
			opponent = get_opponent_for_week(schedule, selected_team, current_week)
			if opponent == "BYE":
				opponent_label.text = "BYE WEEK"
			else:
				var opponent_roster = Rosters.team_rosters[opponent]
				var opponent_averages = calculate_team_averages(opponent)
				opponent_label.text = "%s - Offense: %d, Defense: %d, Special Teams: %d, Overall: %d" % [opponent, opponent_averages["Offense_Ovr"], opponent_averages["Defense_Ovr"], opponent_averages["Special_Teams_Ovr"], opponent_averages["Team_Ovr"]]
		else:
			var is_in_playoffs = false
			record_label.text = str(wins) + "-" + str(losses)
			week_label.text = "Wild Card"
			var playoff_teams = get_playoff_team_seeds()
			add_wild_card_games(playoff_teams)
			for conference in playoff_teams.keys():
				for team_info in playoff_teams[conference]:
					if selected_team == team_info["team"]:
						is_in_playoffs = true
						break
			if is_in_playoffs:
				opponent = get_opponent_for_week(schedule, selected_team, current_week)
				if opponent == "BYE":
					opponent_label.text = "1st Round BYE"
				else:
					var opponent_roster = Rosters.team_rosters[opponent]
					var opponent_averages = calculate_team_averages(opponent)
					opponent_label.text = "%s - Offense: %d, Defense: %d, Special Teams: %d, Overall: %d" % [opponent, opponent_averages["Offense_Ovr"], opponent_averages["Defense_Ovr"], opponent_averages["Special_Teams_Ovr"], opponent_averages["Team_Ovr"]]
			else:
				opponent_label.text = "ELIMINATED"
	elif current_week == 19:
		var is_in_playoffs = false
		var playoff_teams = get_playoff_team_seeds()
		for conference in playoff_teams.keys():
				for team_info in playoff_teams[conference]:
					if selected_team == team_info["team"]:
						is_in_playoffs = true
						break
		if is_in_playoffs:
			if salary_cap < 0:
				salary_cap_popup()
				return
			var roster_size = Rosters.team_rosters[selected_team].size()
			if roster_size > 53:
				roster_size_popup()
				return
			var position_mins = check_position_mins()
			if position_mins == 0:
				return
			var injury_mins = check_injury_mins()
			if injury_mins == 0:
				return
			var team_left_name = selected_team
			var team_right_name = get_opponent_for_week(schedule, selected_team, current_week)
			var team_left_key = team_left_name
			var team_right_key = team_right_name
			if team_right_name == "BYE":
				pass
			else:
				var team_left_roster = Rosters.team_rosters[team_left_name]
				var team_right_roster = Rosters.team_rosters[team_right_name]
				var rivalry = is_rivalry_game(team_left_name, team_right_name)
				var game_result = game_simulator.simulate_game(team_left_roster, team_right_roster, team_left_name, team_right_name, rivalry, 1)
				wild_card_winners.append(game_result.winner)
				wild_card_losers.append(game_result.loser)

		else:
			pass
		
		for game_key in schedule.keys():
			var game = schedule[game_key]
			opponent = get_opponent_for_week(schedule, selected_team, current_week)
			if game["week"] == current_week:
				if game["home"] != selected_team and game["away"] != selected_team:
					if game["home"] != opponent and game["away"] != opponent:
						if game["away"] != "BYE":
							var rivalry = is_rivalry_game(game["home"], game["away"])
							var game_result = simulate_game_between_teams(game["home"], game["away"], rivalry, 1)

							wild_card_winners.append(game_result.winner)
							wild_card_losers.append(game_result.loser)
						else:
							pass
		current_week +=1
		if is_in_playoffs and opponent != "BYE":
			injure_players()
		
		record_label.text = str(wins) + "-" + str(losses)
		week_label.text = "Divisional Round"
		var divisional_teams = divisional_round(playoff_teams, wild_card_winners)
		add_divisional_games(divisional_teams)
		var is_in_divisional_round = false
		for conference in divisional_teams.keys():
			for team_info in divisional_teams[conference]:
				if selected_team == team_info["team"]:
					is_in_divisional_round = true
					break
			if is_in_divisional_round:
				opponent = get_opponent_for_week(schedule, selected_team, current_week)
				if opponent == "BYE":
					opponent_label.text = "1st Round BYE"
				else:
					var opponent_roster = Rosters.team_rosters[opponent]
					var opponent_averages = calculate_team_averages(opponent)
					opponent_label.text = "%s - Offense: %d, Defense: %d, Special Teams: %d, Overall: %d" % [opponent, opponent_averages["Offense_Ovr"], opponent_averages["Defense_Ovr"], opponent_averages["Special_Teams_Ovr"], opponent_averages["Team_Ovr"]]
			else:
				opponent_label.text = "ELIMINATED"
	elif current_week == 20:
		var is_in_divisional_round = false
		#var divisional_winners = []
		var playoff_teams = get_playoff_team_seeds()
		var divisional_teams = divisional_round(playoff_teams, wild_card_winners)
		for conference in divisional_teams.keys():
				for team_info in divisional_teams[conference]:
					if selected_team == team_info["team"]:
						is_in_divisional_round = true
						break
		if is_in_divisional_round:
			if salary_cap < 0:
				salary_cap_popup()
				return
			var roster_size = Rosters.team_rosters[selected_team].size()
			if roster_size > 53:
				roster_size_popup()
				return
			var position_mins = check_position_mins()
			if position_mins == 0:
				return
			var injury_mins = check_injury_mins()
			if injury_mins == 0:
				return
			var team_left_name = selected_team
			var team_right_name = get_opponent_for_week(schedule, selected_team, current_week)
			var team_left_key = team_left_name
			var team_right_key = team_right_name
			var team_left_roster = Rosters.team_rosters[team_left_name]
			var team_right_roster = Rosters.team_rosters[team_right_name]
			var rivalry = is_rivalry_game(team_left_name, team_right_name)
			var game_result = game_simulator.simulate_game(team_left_roster, team_right_roster, team_left_name, team_right_name, rivalry, 1)
			divisional_winners.append(game_result.winner)
			divisional_losers.append(game_result.loser)
		else:
			pass
			
		
		for game_key in schedule.keys():
			var game = schedule[game_key]
			opponent = get_opponent_for_week(schedule, selected_team, current_week)
			if game["week"] == current_week:
				if game["home"] != selected_team and game["away"] != selected_team:
					if game["home"] != opponent and game["away"] != opponent:
						if game["away"] != "BYE":
							var rivalry = is_rivalry_game(game["home"], game["away"])
							var game_result = simulate_game_between_teams(game["home"], game["away"], rivalry, 1)
							divisional_winners.append(game_result.winner)
							divisional_losers.append(game_result.loser)
						else:
							pass
		current_week +=1
		if is_in_divisional_round:
			injure_players()
		record_label.text = str(wins) + "-" + str(losses)
		week_label.text = "Conference Championship"
		var conference_round_teams = conference_round(divisional_teams, divisional_winners)
		add_conference_games(conference_round_teams)
		var is_in_conference_round = false
		for conference in conference_round_teams.keys():
			for team_info in conference_round_teams[conference]:
				if selected_team == team_info["team"]:
					is_in_conference_round = true
					break
			if is_in_conference_round:
				opponent = get_opponent_for_week(schedule, selected_team, current_week)
				if opponent == "BYE":
					opponent_label.text = "1st Round BYE"
				else:
					var opponent_roster = Rosters.team_rosters[opponent]
					var opponent_averages = calculate_team_averages(opponent)
					opponent_label.text = "%s - Offense: %d, Defense: %d, Special Teams: %d, Overall: %d" % [opponent, opponent_averages["Offense_Ovr"], opponent_averages["Defense_Ovr"], opponent_averages["Special_Teams_Ovr"], opponent_averages["Team_Ovr"]]
			else:
				opponent_label.text = "ELIMINATED"
	elif current_week == 21:
		var is_in_conference_round = false
		var playoff_teams = get_playoff_team_seeds()
		var divisional_teams = divisional_round(playoff_teams, wild_card_winners)
		var conference_round_teams = conference_round(divisional_teams, divisional_winners)
		for conference in conference_round_teams.keys():
				for team_info in conference_round_teams[conference]:
					if selected_team == team_info["team"]:
						is_in_conference_round = true
						break
		if is_in_conference_round:
			if salary_cap < 0:
				salary_cap_popup()
				return
			var roster_size = Rosters.team_rosters[selected_team].size()
			if roster_size > 53:
				roster_size_popup()
				return
			var position_mins = check_position_mins()
			if position_mins == 0:
				return
			var injury_mins = check_injury_mins()
			if injury_mins == 0:
				return
			var team_left_name = selected_team
			var team_right_name = get_opponent_for_week(schedule, selected_team, current_week)
			var team_left_key = team_left_name
			var team_right_key = team_right_name
			var team_left_roster = Rosters.team_rosters[team_left_name]
			var team_right_roster = Rosters.team_rosters[team_right_name]
			var rivalry = is_rivalry_game(team_left_name, team_right_name)
			var game_result = game_simulator.simulate_game(team_left_roster, team_right_roster, team_left_name, team_right_name, rivalry, 1)
			conference_winners.append(game_result.winner)
			conference_losers.append(game_result.loser)
		else:
			pass
		
		for game_key in schedule.keys():
			var game = schedule[game_key]
			opponent = get_opponent_for_week(schedule, selected_team, current_week)
			if game["week"] == current_week:
				if game["home"] != selected_team and game["away"] != selected_team:
					if game["home"] != opponent and game["away"] != opponent:
						if game["away"] != "BYE":
							var rivalry = is_rivalry_game(game["home"], game["away"])
							var game_result = simulate_game_between_teams(game["home"], game["away"], rivalry, 1)
							conference_winners.append(game_result.winner)
							conference_losers.append(game_result.loser)
						else:
							pass
		current_week +=1
		if is_in_conference_round:
			injure_players()
		record_label.text = str(wins) + "-" + str(losses)
		week_label.text = "Super Bowl"
		var super_bowl_teams = super_bowl(conference_round_teams, conference_winners)
		add_super_bowl(super_bowl_teams)
		var is_in_super_bowl = false
		for conference in super_bowl_teams.keys():
			for team_info in super_bowl_teams[conference]:
				if selected_team == team_info["team"]:
					is_in_super_bowl = true
					break
			if is_in_super_bowl:
				opponent = get_opponent_for_week(schedule, selected_team, current_week)
				if opponent == "BYE":
					opponent_label.text = "1st Round BYE"
				else:
					var opponent_roster = Rosters.team_rosters[opponent]
					var opponent_averages = calculate_team_averages(opponent)
					opponent_label.text = "%s - Offense: %d, Defense: %d, Special Teams: %d, Overall: %d" % [opponent, opponent_averages["Offense_Ovr"], opponent_averages["Defense_Ovr"], opponent_averages["Special_Teams_Ovr"], opponent_averages["Team_Ovr"]]
			else:
				opponent_label.text = "ELIMINATED"
	elif current_week == 22:
		var is_in_super_bowl = false
		var playoff_teams = get_playoff_team_seeds()
		var divisional_teams = divisional_round(playoff_teams, wild_card_winners)
		var conference_round_teams = conference_round(divisional_teams, divisional_winners)
		var super_bowl_teams = super_bowl(conference_round_teams, conference_winners)
		for conference in super_bowl_teams.keys():
				for team_info in super_bowl_teams[conference]:
					if selected_team == team_info["team"]:
						is_in_super_bowl = true
						break
		if is_in_super_bowl:
			if salary_cap < 0:
				salary_cap_popup()
				return
			var roster_size = Rosters.team_rosters[selected_team].size()
			if roster_size > 53:
				roster_size_popup()
				return
			var position_mins = check_position_mins()
			if position_mins == 0:
				return
			var injury_mins = check_injury_mins()
			if injury_mins == 0:
				return
			var team_left_name = selected_team
			var team_right_name = get_opponent_for_week(schedule, selected_team, current_week)
			var team_left_key = team_left_name
			var team_right_key = team_right_name
			var team_left_roster = Rosters.team_rosters[team_left_name]
			var team_right_roster = Rosters.team_rosters[team_right_name]
			var game_result = game_simulator.simulate_game(team_left_roster, team_right_roster, team_left_name, team_right_name, 0, 1)
			super_bowl_winner.append(game_result.winner)
			super_bowl_loser.append(game_result.loser)
		else:
			pass
		
		for game_key in schedule.keys():
			var game = schedule[game_key]
			opponent = get_opponent_for_week(schedule, selected_team, current_week)
			if game["week"] == current_week:
				if game["home"] != selected_team and game["away"] != selected_team:
					if game["home"] != opponent and game["away"] != opponent:
						if game["away"] != "BYE":
							var game_result = simulate_game_between_teams(game["home"], game["away"], 0, 1)
							super_bowl_winner.append(game_result.winner)
							super_bowl_loser.append(game_result.loser)
						else:
							pass
		current_week +=1
		record_label.text = str(wins) + "-" + str(losses)
		week_label.text = "Off Season"
		season_end_popup()
	elif current_week == 23:
		reset_injuries()
		retirement()
		current_week += 1
		week_label.text = "Retiring Players"
	elif current_week == 24:
		start_offseason()
		current_week += 1
		week_label.text = "Free Agency"
		other_team_resign()
	elif current_week == 25:
		start_free_agency()
		current_week += 1
		week_label.text = "Draft"
	elif current_week == 26:
		cpu_finish_free_agency()
		start_draft()
		current_week += 1
		week_label.text = "Start New Season"
	elif current_week == 27:
		start_new_season()
 
func cpu_finish_free_agency():
	var free_agents = []
	for team in Rosters.team_rosters.keys():
		if team == "Free Agent":
			for player in Rosters.team_rosters[team]:
				free_agents.append(player)
	var teams = ["New York Spartans", "Charlotte Beasts", "Philadelphia Suns", "DC Senators", "Columbus Hawks", "Milwaukee Owls", "Chicago Warriors", "Baltimore Bombers", "Oklahoma Tornadoes", "New Orleans Voodoo", "Omaha Ducks", "Memphis Pyramids", "Las Vegas Aces", "Oregon Sea Lions", "San Diego Spartans", "Los Angeles Stars", "Miami Pirates", "Boston Wildcats", "Tampa Wolverines", "Georgia Peaches", "Louisville Stallions", "Cleveland Blue Jays", "Indianapolis Cougars", "Detroit Motors", "Dallas Rebels", "Kansas City Badgers", "Houston Bulls", "Nashville Strings", "Seattle Vampires", "Sacramento Golds", "Albuquerque Scorpions", "Phoenix Roadrunners"]
	while teams.size() > 5:
		var index_total = teams.size() - 1
		var index = randi_range(0, index_total)
		var chosen_team = teams[index]
		var team_roster = Rosters.team_rosters[chosen_team]
		if chosen_team == selected_team:
			teams.erase(chosen_team)
			continue
		else:
			var positions_filled = get_positions_filled(team_roster)
			var eligible_signings_1 = []
			var eligible_signings_2 = []
			var eligible_signings_3 = []
			for free_agent in free_agents:
				var position = free_agent["Position"]
				var highest_rating = get_highest_rating_for_position(team_roster, position)
				var rating_criteria = 0
				rating_criteria = free_agent["Rating"] - highest_rating
				match position:
					"QB":
						rating_criteria * 4
					"RB":
						rating_criteria * 2.5
					"WR":
						rating_criteria * 2.5
					"TE":
						rating_criteria * 2.5
					"RT":
						rating_criteria * 2
					"RG":
						rating_criteria * 2
					"C":
						rating_criteria * 2
					"LG":
						rating_criteria * 2
					"LT":
						rating_criteria * 2
					"RE":
						rating_criteria * 3
					"LE":
						rating_criteria * 3
					"DT":
						rating_criteria * 2
					"OLB":
						rating_criteria * 2
					"MLB":
						rating_criteria * 2
					"CB":
						rating_criteria * 2
					"SS":
						rating_criteria * 2
					"FS":
						rating_criteria * 2
					"K":
						rating_criteria * 1
					"R":
						rating_criteria * 1
					"P":
						rating_criteria * 1
				if rating_criteria >= 30:
					eligible_signings_1.append(free_agent)
				elif rating_criteria >= 20:
					eligible_signings_2.append(free_agent)
				elif rating_criteria >= 10:
					eligible_signings_3.append(free_agent)
			if eligible_signings_1.size() > 0:
				var player = eligible_signings_1[0]
				var salary_request = generate_salary(player["Position"], player["Rating"], player["Potential"])
				var years = randi() % 4 + 2
				player["Salary"] = salary_request
				player["Remaining Contract"] = years
				var max_depth_chart = get_max_depth_chart(Rosters.team_rosters[chosen_team], player["Position"])
				player["DepthChart"] = max_depth_chart + 1
				Rosters.team_rosters[chosen_team].append(player)
				Rosters.team_rosters["Free Agent"].erase(player)
				free_agents.erase(player)
				print("Player Signed ", chosen_team)
			elif eligible_signings_2.size() > 0:
				var player = eligible_signings_2[0]
				var salary_request = generate_salary(player["Position"], player["Rating"], player["Potential"])
				var years = randi() % 4 + 2
				player["Salary"] = salary_request
				player["Remaining Contract"] = years
				var max_depth_chart = get_max_depth_chart(Rosters.team_rosters[chosen_team], player["Position"])
				player["DepthChart"] = max_depth_chart + 1
				Rosters.team_rosters[chosen_team].append(player)
				Rosters.team_rosters["Free Agent"].erase(player)
				free_agents.erase(player)
				print("Player Signed ", chosen_team)
			elif eligible_signings_3.size() > 0:
				var player = eligible_signings_3[0]
				var salary_request = generate_salary(player["Position"], player["Rating"], player["Potential"])
				var years = randi() % 3 + 2
				player["Salary"] = salary_request
				player["Remaining Contract"] = years
				var max_depth_chart = get_max_depth_chart(Rosters.team_rosters[chosen_team], player["Position"])
				player["DepthChart"] = max_depth_chart + 1
				Rosters.team_rosters[chosen_team].append(player)
				Rosters.team_rosters["Free Agent"].erase(player)
				free_agents.erase(player)
				print("Player Signed ", chosen_team)
			else:
				teams.erase(chosen_team)
			continue
	reorder_cpu_depth_charts()


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

func get_highest_rating_for_position(roster, position):
	var highest_rating = 0
	for player in roster:
		if player["Position"] == position and player["Rating"] > highest_rating:
			highest_rating = player["Rating"]
	return highest_rating

func get_positions_filled(team_roster):
	var positions = {}
	for player in team_roster:
		positions[player["Position"]] = true
	return positions

func other_team_resign():
	for team_name in Rosters.team_rosters.keys():
		if team_name == selected_team or team_name == "Free Agents":
			continue
		for player in Rosters.team_rosters[team_name]:
			if player.get("Remaining Contract", 0) == 1:
				var salary_request = generate_salary(player["Position"], player["Rating"], player["Potential"])
				var years = randi() % 4 + 2
				var rng = randf()
				if rng > .25:
					player["Salary"] = salary_request
					player["Remaining Contract"] = years
					
				else:
					
					continue

func start_new_season():
	fill_rosters()
	trim_rosters()
	current_week = 1
	wins = 0
	losses = 0
	current_season += 1
	record_label.text = str(wins) + "-" + str(losses)
	week_label.text = "Week " + str(current_week)
	schedule = read_schedule("res://JSON Files/MasterSchedule.json")
	team_records = load_team_records("res://JSON Files/Team_Records.json")
	wild_card_winners = []
	divisional_winners = []
	conference_winners = []
	super_bowl_winner = []
	wild_card_losers = []
	divisional_losers = []
	conference_losers = []
	super_bowl_loser = []
	all_playoff_teams = []
	opponent = get_opponent_for_week(schedule, selected_team, current_week)
	var opponent_roster = Rosters.team_rosters[opponent]
	var opponent_averages = calculate_team_averages(opponent)
	opponent_label.text = "%s - Offense: %d, Defense: %d, Special Teams: %d, Overall: %d" % [opponent, opponent_averages["Offense_Ovr"], opponent_averages["Defense_Ovr"], opponent_averages["Special_Teams_Ovr"], opponent_averages["Team_Ovr"]]
	SeasonStats.season_stats = {}
	Rosters.update_deadcap()

func start_offseason():
	set_final_draft_order()
	add_age()
	stat_decay()
	reset_rookies()
	SeasonStats.season_stats = {}
	var current_scene = get_tree().current_scene
	var pending_scene = load("res://PendingFA.tscn")
	var pending_instance = pending_scene.instantiate()
	get_tree().root.add_child(pending_instance)
	get_tree().current_scene = pending_instance

func reset_rookies():
	for team_name in Rosters.team_rosters.keys():
		var i = 0
		while i < Rosters.team_rosters[team_name].size():
			var player = Rosters.team_rosters[team_name][i]
			if "Rookie" in player:
				if player["Rookie"] == 1:
					player["Rookie"] = 0
					continue
			i += 1

func start_free_agency():
	lower_contract()
	var current_scene = get_tree().current_scene
	var free_agency_scene = load("res://FreeAgency.tscn")
	var free_agency_instance = free_agency_scene.instantiate()
	get_tree().root.add_child(free_agency_instance)
	get_tree().current_scene = free_agency_instance

func start_draft():
	var current_scene = get_tree().current_scene
	var draft_scene = load("res://Draft.tscn")
	var draft_instance = draft_scene.instantiate()
	get_tree().root.add_child(draft_instance)
	draft_instance.current_season = current_season
	get_tree().current_scene = draft_instance

func lower_contract():
	var free_agents = []
	for team_name in Rosters.team_rosters.keys():
		var i = 0
		while i < Rosters.team_rosters[team_name].size():
			var player = Rosters.team_rosters[team_name][i]
			if "Remaining Contract" in player:
				player["Remaining Contract"] -= 1
				if player["Remaining Contract"] <= 0:
					free_agents.append(player)
					Rosters.team_rosters[team_name].remove_at(i)
					continue
			i += 1
	Rosters.team_rosters["Free Agent"] += free_agents

func add_age():
	for team_name in Rosters.team_rosters.keys():
		for player in Rosters.team_rosters[team_name]:
			if "Age" in player:
				player["Age"] += 1

func update_team_records(winner, loser):
	team_records[winner]["Wins"] += 1
	team_records[loser]["Losses"] += 1

	if team_records[winner]["Conference"] == team_records[loser]["Conference"]:
		team_records[winner]["Conference Wins"] += 1
		team_records[loser]["Conference Losses"] += 1
		if team_records[winner]["Division"] == team_records[loser]["Division"]:
			team_records[winner]["Division Wins"] += 1
			team_records[loser]["Division Losses"] += 1

func _on_standings_button_pressed():
	var current_scene = get_tree().current_scene
	var standings_scene = load("res://Standings.tscn")
	var standings_instance = standings_scene.instantiate()
	
	get_tree().root.add_child(standings_instance)
	standings_instance.team_records = team_records
	get_tree().current_scene = standings_instance

func get_playoff_teams():
	var conferences = {
		"CFC": {
			"North": [],
			"East": [],
			"South": [],
			"West": []
		},
		"AHC": {
			"North": [],
			"East": [],
			"South": [],
			"West": []
		}
	}
	var playoff_teams = {
		"CFC": {"Division Winners": [], "Wild Cards": []},
		"AHC": {"Division Winners": [], "Wild Cards": []}
	}
	for team in team_records.keys():
		var record = team_records[team]
		conferences[record["Conference"]][record["Division"]].append(team)
	
	for conference in conferences.keys():
		var conference_teams = []
		for division in conferences[conference].keys():
			var division_teams = conferences[conference][division]
			sort_teams(division_teams)
			var div_win = division_teams[0]
			if div_win not in all_playoff_teams:
				all_playoff_teams.append(div_win)
			playoff_teams[conference]["Division Winners"].append(division_teams[0])
			sort_teams(playoff_teams[conference]["Division Winners"])
			conference_teams += division_teams
			
		sort_teams(conference_teams)
		
		var wild_card_count = 0
		for team in conference_teams:
			if team not in playoff_teams[conference]["Division Winners"]:
				if team not in all_playoff_teams:
					all_playoff_teams.append(team)
				playoff_teams[conference]["Wild Cards"].append(team)
				wild_card_count += 1
				if wild_card_count >= 3:
					break
	return playoff_teams

func sort_teams(teams_array):
	teams_array.sort_custom(compare_teams)

func compare_teams(team1, team2):

	if team_records[team1]["Wins"] != team_records[team2]["Wins"]:
		if team_records[team1]["Wins"] > team_records[team2]["Wins"]:
			return true
		else:
			return false


	elif team_records[team1]["Division Wins"] != team_records[team2]["Division Wins"]:
		if team_records[team1]["Division Wins"] > team_records[team2]["Division Wins"]:
			return true
		else:
			return false

	else:
		if team_records[team1]["Conference Wins"] > team_records[team2]["Conference Wins"]:
			return true
		else:
			return false

func _on_playoff_button_pressed():
	pass

func print_draft(year):
	var draft_order = Draft.drafts[year]
	for pick_number in range(1, 65):
		if pick_number in draft_order:
			var pick_info = draft_order[pick_number]
			var team_name = pick_info["current_team"]
			print("Pick Number: %d, Team: %s" % [pick_number, team_name])

func get_playoff_team_seeds():
	var playoff_teams = get_playoff_teams()
	var seeded_playoff_teams = {
		"CFC": [],
		"AHC": []
	}
	for conference in playoff_teams.keys():
		var seed = 1
		for division_winner in playoff_teams[conference]["Division Winners"]:
			seeded_playoff_teams[conference].append({
				"team": division_winner,
				"seed": seed
			})
			seed += 1
		for wild_card in playoff_teams[conference]["Wild Cards"]:
			seeded_playoff_teams[conference].append({
				"team": wild_card,
				"seed": seed
			})
			seed += 1
	return seeded_playoff_teams

func add_wild_card_games(playoff_teams):
	var last_key = get_last_schedule_key()
	for conference in playoff_teams.keys():

		var matchups = [
			{"home": playoff_teams[conference][1]["team"], "away": playoff_teams[conference][6]["team"]},  # 2 vs 7
			{"home": playoff_teams[conference][2]["team"], "away": playoff_teams[conference][5]["team"]},  # 3 vs 6
			{"home": playoff_teams[conference][3]["team"], "away": playoff_teams[conference][4]["team"]},  # 4 vs 5
			{"home": playoff_teams[conference][0]["team"], "away": "BYE"}
		]
		for matchup in matchups:
			last_key += 1
			schedule[str(last_key)] = {
				"week": 19,
				"away": matchup["away"],
				"home": matchup["home"]
			}

func get_last_schedule_key():
	var max_key = 0
	for key in schedule.keys():
		var int_key = int(key)
		if int_key > max_key:
			max_key = int_key
	return max_key

func divisional_round(playoff_teams, wild_card_winners):
	var divisional_round_teams = {
		"CFC": [],
		"AHC": []
	}
	for conference in playoff_teams.keys():
		var remaining_teams = []
		for team_info in playoff_teams[conference]:
			if team_info["team"] in wild_card_winners or team_info["seed"] == 1:
				remaining_teams.append(team_info)
		remaining_teams.sort_custom(compare_seeds)
		for team_info in remaining_teams:
			divisional_round_teams[conference].append(team_info)

	return divisional_round_teams
	
func compare_seeds(team_info1, team_info2):
	return team_info1["seed"] - team_info2["seed"]

func add_divisional_games(playoff_teams):
	var last_key = get_last_schedule_key()
	for conference in playoff_teams.keys():
		var matchups = [
			{"home": playoff_teams[conference][0]["team"], "away": playoff_teams[conference][3]["team"]}, 
			{"home": playoff_teams[conference][1]["team"], "away": playoff_teams[conference][2]["team"]}, 

		]
		for matchup in matchups:
			last_key += 1
			schedule[str(last_key)] = {
				"week": 20,
				"away": matchup["away"],
				"home": matchup["home"]
			}

func conference_round(divisional_teams, divisional_winners):
	var conference_round_teams = {
		"CFC": [],
		"AHC": []
	}
	for conference in divisional_teams.keys():
		var remaining_teams = []
		for team_info in divisional_teams[conference]:
			if team_info["team"] in divisional_winners:
				remaining_teams.append(team_info)
		remaining_teams.sort_custom(compare_seeds)
		for team_info in remaining_teams:
			conference_round_teams[conference].append(team_info)

	return conference_round_teams

func add_conference_games(divisional_teams):
	var last_key = get_last_schedule_key()
	for conference in divisional_teams.keys():
		var matchups = [
			{"home": divisional_teams[conference][0]["team"], "away": divisional_teams[conference][1]["team"]}

		]
		for matchup in matchups:
			last_key += 1
			schedule[str(last_key)] = {
				"week": 21,
				"away": matchup["away"],
				"home": matchup["home"]
			}

func super_bowl(conference_teams, conference_winners):
	var super_bowl_teams = {
		"CFC": [],
		"AHC": []
	}
	for conference in conference_teams.keys():
		var remaining_teams = []
		for team_info in conference_teams[conference]:
			if team_info["team"] in conference_winners:
				remaining_teams.append(team_info)
		for team_info in remaining_teams:
			super_bowl_teams[conference].append(team_info)

	return super_bowl_teams
	
func add_super_bowl(conference_teams):
	var last_key = get_last_schedule_key()
	last_key += 1
	var cfc_winner = conference_teams["CFC"][0]["team"]
	var ahc_winner = conference_teams["AHC"][0]["team"]
	
	schedule[str(last_key)] = {
		"week": 22,
		"away": cfc_winner,
		"home": ahc_winner
	}

func _on_depth_chart_pressed():
	var current_scene = get_tree().current_scene
	var depthchart_scene = load("res://DepthChart.tscn")
	var depthchart_instance = depthchart_scene.instantiate()
	get_tree().root.add_child(depthchart_instance)
	get_tree().current_scene = depthchart_instance

func _on_free_agents_pressed():
	var current_scene = get_tree().current_scene
	if current_week == 25:
		var free_agency_scene = load("res://FreeAgency.tscn")
		var free_agency_instance = free_agency_scene.instantiate()
		get_tree().root.add_child(free_agency_instance)
		get_tree().current_scene = free_agency_instance
	else:
		var depthchart_scene = load("res://FreeAgents.tscn")
		var depthchart_instance = depthchart_scene.instantiate()
		get_tree().root.add_child(depthchart_instance)
		get_tree().current_scene = depthchart_instance

func get_salary_cap():
	var total_salary = 0.0
	var team_roster = Rosters.team_rosters[selected_team]
	for player in team_roster:
		total_salary += player.get("Salary", 0.0)
	var dead_cap = 0
	for cap in Rosters.dead_cap:
		if cap["Year"] == current_season:
			dead_cap = cap["Dead Cap"]
	salary_cap = 225 - total_salary - dead_cap

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
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (50 - 1)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
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

func score_popup(team_left_name, team_right_name, team_left_score, team_right_score, team_left_stats, team_right_stats):
	var current_scene = get_tree().current_scene
	var score_scene = load("res://ScorePopUp.tscn")
	var score_instance = score_scene.instantiate()
	score_instance.team_left_name = team_left_name
	score_instance.team_right_name = team_right_name
	score_instance.team_left_score = team_left_score
	score_instance.team_right_score = team_right_score
	score_instance.team_left_stats = team_left_stats
	score_instance.team_right_stats = team_right_stats
	get_tree().root.add_child(score_instance)
	get_tree().current_scene = score_instance

func fill_rosters():
	var position_minimums = {"QB": 2, "RB": 3, "WR": 5, "TE": 2, "RT": 2, "LT": 2, "RG": 2, "LG": 2, "C": 1,
	"LE": 2, "RE": 2, "DT": 3, "OLB": 3, "MLB": 2, "CB": 5, "SS": 2, "FS": 2,
	"K": 1, "P": 1, "R": 1}
	var free_agents = Rosters.team_rosters["Free Agent"]
	for team_name in Rosters.team_rosters.keys():
		if team_name != selected_team and team_name != "Free Agent":
			var team_roster = Rosters.team_rosters[team_name]
			var position_counts = count_positions(team_roster)
			
			for position in position_minimums.keys():
				var minimum = position_minimums[position]
				var current_count = position_counts.get(position, 0)
				while current_count < minimum:
					var free_agent = find_and_remove_fa(free_agents, position)
					if free_agent:
						team_roster.append(free_agent)
						current_count += 1
					else:
						break
			reorder_teams(team_roster)
			Rosters.team_rosters[team_name] = team_roster
	var fa_position_minimums = {"QB": 10, "RB": 10, "WR": 15, "TE": 10, "RT": 10, "LT": 10, "RG": 10, "LG": 10, "C": 10,
	"LE": 10, "RE": 10, "DT": 10, "OLB": 10, "MLB": 10, "CB": 15, "SS": 10, "FS": 10, "K": 10, "P": 10, "R": 10}
	for team_name in Rosters.team_rosters.keys():
		if team_name == "Free Agent":
			var team_roster = Rosters.team_rosters[team_name]
			var position_counts = count_positions(team_roster)
			
			for position in fa_position_minimums.keys():
				var minimum = position_minimums[position]
				var current_count = position_counts.get(position, 0)
				while current_count < minimum:
					var player = create_fa(current_count, minimum, position)
					Rosters.team_rosters[team_name].append(player)

func create_fa(current_count, minimum, position):
	var player = {}
	var first_names = load_first_names()
	var last_names = load_last_names()
	var side = ""
	
	if position in ["QB", "RB", "WR", "TE", "RT", "RG", "C", "LG", "LT"]:
		side = "Offense"
	elif position in ["K", "P", "R"]:
		side = "ST"
	else:
		side = "Defense"
	var first_names_array = first_names.keys()
	var last_names_array = last_names.keys()
	var random_index = randi() % first_names_array.size()
	
	player["FirstName"] = first_names_array[random_index]
	player["LastName"] = last_names_array[randi() % last_names_array.size()]
	player["Side"] = side
	player["Position"] = position
	player["Rating"] = randi() % 25 + 50
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
	print(player)
	return player

func trim_rosters():
	var position_minimums = {"QB": 2, "RB": 3, "WR": 5, "TE": 2, "RT": 2, "LT": 2, "RG": 2, "LG": 2, "C": 1,
	"LE": 2, "RE": 2, "DT": 3, "OLB": 3, "MLB": 2, "CB": 5, "SS": 2, "FS": 2,
	"K": 1, "P": 1, "R": 1}
	for team in Rosters.team_rosters.keys():
		if team != selected_team and team != "Free Agent":
			var team_roster = Rosters.team_rosters[team]
			var position_counts = count_positions(team_roster)
			for position in position_counts:
				if position_counts[position] > position_minimums[position] + 2:
					var position_group = []
					var extra = position_counts[position] - position_minimums[position] - 2
					for player in Rosters.team_rosters[team]:
						if player["Position"] == position:
							position_group.append(player)
					position_group.sort_custom(func(a, b):
						return a["Rating"] < b["Rating"])
					var players_to_cut = []
					for i in range(extra):
						players_to_cut.append(position_group[i])
					for player in players_to_cut:
						for roster_player in Rosters.team_rosters[team]:
							if player["PlayerID"] == roster_player["PlayerID"]:
								Rosters.team_rosters[team].erase(roster_player)
								Rosters.team_rosters["Free Agent"].append(roster_player)
	for team in Rosters.team_rosters.keys():
		if team != selected_team and team != "Free Agent":
			if Rosters.team_rosters[team].size() > 53:
				var team_roster = Rosters.team_rosters[team]
				var position_counts = count_positions(team_roster)
				for position in position_counts:
					if position_counts[position] > position_minimums[position] + 1:
						var position_group = []
						var extra = position_counts[position] - position_minimums[position] - 1
						for player in Rosters.team_rosters[team]:
							if player["Position"] == position:
								position_group.append(player)
						position_group.sort_custom(func(a, b):
							return a["Rating"] < b["Rating"])
						var players_to_cut = []
						for i in range(extra):
							players_to_cut.append(position_group[i])
						for player in players_to_cut:
							for roster_player in Rosters.team_rosters[team]:
								if player["PlayerID"] == roster_player["PlayerID"]:
									Rosters.team_rosters[team].erase(roster_player)
									Rosters.team_rosters["Free Agent"].append(roster_player)

func set_depth_chart():
	var team_roster = Rosters.team_rosters[selected_team]
	reorder_teams(team_roster)
	Rosters.team_rosters[selected_team] = team_roster

func reorder_teams(team_roster):
	var positions = ["QB", "RB", "WR", "TE", "LT", "LG", "C", "RG", "RT", "LE", "RE", "DT", "OLB", "MLB", "CB", "SS", "FS", "K", "P", "R"]
	for position in positions:
		reorder_position(position, team_roster)

func reorder_position(position, team_roster):
	var position_array = []
	for player in team_roster:
		if player["Position"] == position:
			position_array.append(player)
	sort_rating(position_array)
	for i in range(len(position_array)):
		position_array[i]["DepthChart"] = i + 1

func reorder_cpu_depth_charts():
	for team in Rosters.team_rosters.keys():
		var positions = ["QB", "RB", "WR", "TE", "LT", "LG", "C", "RG", "RT", "LE", "RE", "DT", "OLB", "MLB", "CB", "SS", "FS", "K", "P", "R"]
		while positions.size() > 0:
			if team != selected_team or team != "Free Agent":
				var position_group = []
				var current_position = positions[0]
				for player in Rosters.team_rosters[team]:
					if player["Position"] == current_position:
						position_group.append(player)
				position_group.sort_custom(func(a, b):
					return a["Rating"] > b["Rating"])
				for i in range(len(position_group)):
					position_group[i]["DepthChart"] = i + 1
				for player in position_group:
					for roster_player in Rosters.team_rosters[team]:
						if player["PlayerID"] == roster_player["PlayerID"]:
							roster_player["DepthChart"] = player["DepthChart"]
				positions.erase(current_position)
				continue

func sort_rating(position_group):
	position_group.sort_custom(compare_by_rating)
	
func compare_by_rating(player1, player2):
	if player1["Rating"] >= player2["Rating"]:
		return true
	else:
		false

func count_positions(team_roster):
	var counts = {}
	for player in team_roster:
		var position = player["Position"]
		counts[position] = counts.get(position, 0) + 1
	return counts

func find_and_remove_fa(free_agents, position):
	for i in range(len(free_agents)):
		if free_agents[i]["Position"] == position:
			var player_to_remove = free_agents[i]
			free_agents.remove_at(i)
			return player_to_remove
	return null

func boost_ovr():
	for team_name in Rosters.team_rosters.keys():
		for player in Rosters.team_rosters[team_name]:
			var potential = player.get("Potential", 0)
			var chance = 0.0
			if player["DepthChart"] == 1 and player["Injury"] == 0:
				match potential:
					5:
						chance = .15
					4:
						chance = .12
					3:
						chance = .08
					2:
						chance = .04
					1:
						chance = .01
			elif player["DepthChart"] == 2 and player["Position"] in ["WR", "CB", "RB", "DT", "OLB"] and player["Injury"] == 0:
				match potential:
					5:
						chance = .1
					4:
						chance = .08
					3:
						chance = .05
					2:
						chance = .025
					1:
						chance = .005
			elif player["DepthChart"] == 2 and player["Injury"] == 0:
				match potential:
					5:
						chance = .06
					4:
						chance = .04
					3:
						chance = .02
					2:
						chance = .01
					1:
						chance = .001
			elif player["DepthChart"] == 3 and player["Position"] in ["WR", "CB"] and player["Injury"] == 0:
				match potential:
					5:
						chance = .08
					4:
						chance = .06
					3:
						chance = .04
					2:
						chance = .02
					1:
						chance = .003
			else:
				match potential:
					5:
						chance = .05
					4:
						chance = .03
					3:
						chance = .015
					2:
						chance = .008
					1:
						chance = .001
			if player["Side"] == "Offense":
				for coach in Coaches.team_ocs:
					if coach["Team"] == selected_team:
						if coach["Trait"] == "Practice Makes Perfect":
							match coach["Rank"]:
								"Copper":
									chance *= 1.03
								"Bronze":
									chance *= 1.06
								"Silver":
									chance *= 1.09
								"Gold":
									chance *= 1.12
								"Platinum":
									chance *= 1.15
								"Diamond":
									chance *= 1.18
			elif player["Side"] == "Defense":
				for coach in Coaches.team_dcs:
					if coach["Team"] == selected_team:
						if coach["Trait"] == "Practice Makes Perfect":
							match coach["Rank"]:
								"Copper":
									chance *= 1.03
								"Bronze":
									chance *= 1.06
								"Silver":
									chance *= 1.09
								"Gold":
									chance *= 1.12
								"Platinum":
									chance *= 1.15
								"Diamond":
									chance *= 1.18
			if randf() <= chance:
				player["Rating"] += 1

func stat_decay():
	for team_name in Rosters.team_rosters.keys():
		for player in Rosters.team_rosters[team_name]:
			var potential = player.get("Potential", 0)
			var chance = 0.0
			var youth = ["RB", "R", "WR"]
			var normal = ["TE", "LT", "LG", "C", "RG", "RT", "LE", "RE", "DT", "OLB", "MLB", "CB", "SS", "FS"]
			var old = ["QB", "P", "K"]
			if player["Age"] >= 29 and player["Position"] in youth:
				match potential:
					5:
						chance = .4
					4:
						chance = .55
					3:
						chance = .7
					2:
						chance = .85
					1:
						chance = .95
			elif player["Age"] >= 32 and player["Position"] in youth:
				match potential:
					5:
						chance = .8
					4:
						chance = .9
					3:
						chance = .95
					2:
						chance = 1
					1:
						chance = 1
			elif player["Age"] >= 31 and player["Position"] in normal:
				match potential:
					5:
						chance = .4
					4:
						chance = .55
					3:
						chance = .7
					2:
						chance = .85
					1:
						chance = .95
			elif player["Age"] >= 35 and player["Position"] in normal:
				match potential:
					5:
						chance = .8
					4:
						chance = .9
					3:
						chance = .95
					2:
						chance = 1
					1:
						chance = 1
			elif player["Age"] >= 34 and player["Position"] in old:
				match potential:
					5:
						chance = .4
					4:
						chance = .55
					3:
						chance = .7
					2:
						chance = .85
					1:
						chance = .95
			elif player["Age"] >= 37 and player["Position"] in old:
				match potential:
					5:
						chance = .8
					4:
						chance = .9
					3:
						chance = .95
					2:
						chance = 1
					1:
						chance = 1
			else:
				pass
			var decrease_rng = randf()
			if player["Side"] == "Offense":
				for coach in Coaches.team_ocs:
					if coach["Team"] == team_name:
						if coach["Trait"] == "Youthful Spirit":
							match coach["Rank"]:
								"Copper":
									chance *= .95
									decrease_rng *= 1.05
								"Bronze":
									chance *= .9
									decrease_rng *= 1.1
								"Silver":
									chance *= .85
									decrease_rng *= 1.15
								"Gold":
									chance *= .8
									decrease_rng *= 1.2
								"Platinum":
									chance *= .75
									decrease_rng *= 1.25
								"Diamond":
									chance *= .7
									decrease_rng *= 1.3
			elif player["Side"] == "Defense":
				for coach in Coaches.team_dcs:
					if coach["Team"] == team_name:
						if coach["Trait"] == "Youthful Spirit":
							match coach["Rank"]:
								"Copper":
									chance *= .95
									decrease_rng *= 1.05
								"Bronze":
									chance *= .9
									decrease_rng *= 1.1
								"Silver":
									chance *= .85
									decrease_rng *= 1.15
								"Gold":
									chance *= .8
									decrease_rng *= 1.2
								"Platinum":
									chance *= .75
									decrease_rng *= 1.25
								"Diamond":
									chance *= .7
									decrease_rng *= 1.3
			if randf() <= chance:
				var decrease = 0
				if decrease_rng >= .6:
					decrease = 1
				elif decrease_rng >= .3:
					decrease = 2
				elif decrease_rng >= .1:
					decrease = 3
				else:
					decrease = 4
				player["Rating"] -= decrease

func rank_teams_by_ovr():
	var team_averages = {}
	for team_name in Rosters.team_rosters.keys():
		if team_name != "Free Agent":
			team_averages[team_name] = calculate_team_averages(team_name)["Team_Ovr"]
	
	var teams_with_averages = []
	for team_name in team_averages.keys():
		teams_with_averages.append([team_name, team_averages[team_name]])
	
	teams_with_averages.sort_custom(func(a, b):
		return a[1] < b[1])
	
	var sorted_teams = []
	for team in teams_with_averages:
		sorted_teams.append(team[0])
	return sorted_teams
	
func create_first_drafts():
	var sorted_teams = rank_teams_by_ovr()
	Draft.generate_initial_drafts(sorted_teams)

func print_ranked_teams():
	var sorted_teams = rank_teams_by_ovr()
	print(sorted_teams)

func update_draft_order():
	var sorted_teams = sort_draft_in_season()
	Draft.update_draft_order(sorted_teams)

func sort_draft_in_season():
	var team_list = team_records.keys()
	
	var teams_with_criteria = []
	for team_name in team_list:
		var team_data = team_records[team_name]
		var team_ovr = calculate_team_averages(team_name)["Team_Ovr"]
		teams_with_criteria.append({
			"name": team_name,
			"wins": team_data["Wins"],
			"division_wins": team_data["Division Wins"],
			"conference_wins": team_data["Conference Wins"],
			"team_ovr": team_ovr
		})
	teams_with_criteria.sort_custom(func(a, b):
		if a["wins"] != b["wins"]:
			return a["wins"] < b["wins"]
		if a["division_wins"] != b["division_wins"]:
			return a["division_wins"] < b["division_wins"]
		if a["conference_wins"] != b["conference_wins"]:
			return a["conference_wins"] < b["conference_wins"]
		return a["team_ovr"] < b["team_ovr"]
	)
	var sorted_teams = []
	for team in teams_with_criteria:
		sorted_teams.append(team["name"])
	
	return sorted_teams
	
func set_final_draft_order():
	var sorted_teams = final_draft_sort()
	Draft.update_draft_order(sorted_teams)

func final_draft_sort():
	var team_list = team_records.keys()
	var non_playoff_teams = []
	var sorted_teams = []
	var teams_with_criteria = []
	var wc_losers = []
	var div_losers = []
	var con_losers = []
	var sb_loser = []
	var sb_winner = []
	for team_name in team_list:
		if team_name not in all_playoff_teams:
			var team_data = team_records[team_name]
			var team_ovr = calculate_team_averages(team_name)["Team_Ovr"]
			teams_with_criteria.append({
				"name": team_name,
				"wins": team_data["Wins"],
				"division_wins": team_data["Division Wins"],
				"conference_wins": team_data["Conference Wins"],
				"team_ovr": team_ovr
			})
		else:
			pass
	teams_with_criteria.sort_custom(func(a, b):
			if a["wins"] != b["wins"]:
				return a["wins"] < b["wins"]
			if a["division_wins"] != b["division_wins"]:
				return a["division_wins"] < b["division_wins"]
			if a["conference_wins"] != b["conference_wins"]:
				return a["conference_wins"] < b["conference_wins"]
			return a["team_ovr"] < b["team_ovr"]
	)
	for team in teams_with_criteria:
		sorted_teams.append(team["name"])
	
	for team_name in team_list:
		if team_name  in wild_card_losers:
			var team_data = team_records[team_name]
			var team_ovr = calculate_team_averages(team_name)["Team_Ovr"]
			wc_losers.append({
				"name": team_name,
				"wins": team_data["Wins"],
				"division_wins": team_data["Division Wins"],
				"conference_wins": team_data["Conference Wins"],
				"team_ovr": team_ovr
			})
		else:
			pass
	wc_losers.sort_custom(func(a, b):
			if a["wins"] != b["wins"]:
				return a["wins"] < b["wins"]
			if a["division_wins"] != b["division_wins"]:
				return a["division_wins"] < b["division_wins"]
			if a["conference_wins"] != b["conference_wins"]:
				return a["conference_wins"] < b["conference_wins"]
			return a["team_ovr"] < b["team_ovr"]
	)
	for team in wc_losers:
		sorted_teams.append(team["name"])
	
	for team_name in team_list:
		if team_name  in divisional_losers:
			var team_data = team_records[team_name]
			var team_ovr = calculate_team_averages(team_name)["Team_Ovr"]
			div_losers.append({
				"name": team_name,
				"wins": team_data["Wins"],
				"division_wins": team_data["Division Wins"],
				"conference_wins": team_data["Conference Wins"],
				"team_ovr": team_ovr
			})
		else:
			pass
	div_losers.sort_custom(func(a, b):
			if a["wins"] != b["wins"]:
				return a["wins"] < b["wins"]
			if a["division_wins"] != b["division_wins"]:
				return a["division_wins"] < b["division_wins"]
			if a["conference_wins"] != b["conference_wins"]:
				return a["conference_wins"] < b["conference_wins"]
			return a["team_ovr"] < b["team_ovr"]
	)
	for team in div_losers:
		sorted_teams.append(team["name"])
	
	for team_name in team_list:
		if team_name  in conference_losers:
			var team_data = team_records[team_name]
			var team_ovr = calculate_team_averages(team_name)["Team_Ovr"]
			con_losers.append({
				"name": team_name,
				"wins": team_data["Wins"],
				"division_wins": team_data["Division Wins"],
				"conference_wins": team_data["Conference Wins"],
				"team_ovr": team_ovr
			})
		else:
			pass
	con_losers.sort_custom(func(a, b):
			if a["wins"] != b["wins"]:
				return a["wins"] < b["wins"]
			if a["division_wins"] != b["division_wins"]:
				return a["division_wins"] < b["division_wins"]
			if a["conference_wins"] != b["conference_wins"]:
				return a["conference_wins"] < b["conference_wins"]
			return a["team_ovr"] < b["team_ovr"]
	)
	for team in con_losers:
		sorted_teams.append(team["name"])
	
	for team_name in team_list:
		if team_name  in super_bowl_loser:
			sb_loser.append({
				"name": team_name,
			})
	for team in sb_loser:
		sorted_teams.append(team["name"])
	
	for team_name in team_list:
		if team_name  in super_bowl_winner:
			sb_winner.append({
				"name": team_name,
			})
	for team in sb_winner:
		sorted_teams.append(team["name"])
	
	return sorted_teams

func retirement():
	for team_name in Rosters.team_rosters.keys():
		for player in Rosters.team_rosters[team_name]:
			var potential = player.get("Potential", 0)
			var chance = 0.0
			var youth = ["RB", "R", "WR"]
			var normal = ["TE", "LT", "LG", "C", "RG", "RT", "LE", "RE", "DT", "OLB", "MLB", "CB", "SS", "FS"]
			var old = ["QB", "P", "K"]
			if player["Age"] >= 31 and player["Position"] in youth:
				match player["Age"]:
					31:
						chance = .4
					32:
						chance = .55
					33:
						chance = .7
					34:
						chance = .85
					35:
						chance = .95
					36:
						chance = 1
			elif player["Age"] >= 33 and player["Position"] in normal:
				match player["Age"]:
					33:
						chance = .3
					34:
						chance = .5
					35:
						chance = .7
					36:
						chance = .8
					37:
						chance = .95
					38:
						chance = 1
			elif player["Age"] >= 36 and player["Position"] in old:
				match potential:
					36:
						chance = .5
					37:
						chance = .6
					38:
						chance = .8
					39:
						chance = .9
					40:
						chance = 1
			else:
				pass
			if player["Side"] == "Offense":
				for coach in Coaches.team_ocs:
					if coach["Team"] == team_name:
						if coach["Trait"] == "Youthful Spirit":
							match coach["Rank"]:
								"Copper":
									chance *= .95
								"Bronze":
									chance *= .9
								"Silver":
									chance *= .85
								"Gold":
									chance *= .8
								"Platinum":
									chance *= .75
								"Diamond":
									chance *= .7
			elif player["Side"] == "Defense":
				for coach in Coaches.team_dcs:
					if coach["Team"] == team_name:
						if coach["Trait"] == "Youthful Spirit":
							match coach["Rank"]:
								"Copper":
									chance *= .95
								"Bronze":
									chance *= .9
								"Silver":
									chance *= .85
								"Gold":
									chance *= .8
								"Platinum":
									chance *= .75
								"Diamond":
									chance *= .7
			if randf() <= chance:
				if team_name == selected_team:
					retiring_players.append(player)
				Rosters.team_rosters[team_name].erase(player)
	retirement_scene()

func retirement_scene():
	var current_scene = get_tree().current_scene
	var retirement_scene = load("res://Retire.tscn")
	var retirement_instance = retirement_scene.instantiate()
	retirement_instance.retiring_players = retiring_players
	get_tree().root.add_child(retirement_instance)
	get_tree().current_scene = retirement_instance

func _on_trade_menu_pressed():
	if current_week >= 9 and current_week <= 23:
		trade_deadline_popup()
		return
	var current_scene = get_tree().current_scene
	var trade_scene = load("res://Trade.tscn")
	var trade_instance = trade_scene.instantiate()
	trade_instance.current_week = current_week
	get_tree().root.add_child(trade_instance)
	get_tree().current_scene = trade_instance

func get_mvp():
	var mvp_candidates = []
	var stats = SeasonStats.season_stats
	for player in stats:
		if "pass_yards" in stats[player]:
			stats[player]["PlayerID"] = player
			stats[player]["Score"] = 0
			mvp_candidates.append(stats[player])
	mvp_candidates.sort_custom(func(a, b):
		return a["pass_yards"] > b["pass_yards"])
	var pass_yards_score = 10
	for index in range(len(mvp_candidates)):
		mvp_candidates[index]["Score"] += pass_yards_score
		pass_yards_score -= 1
		if pass_yards_score < 0:
			pass_yards_score = 0
	mvp_candidates.sort_custom(func(a, b):
		return a["pass_tds"] > b["pass_tds"])
	var pass_td_score = 10
	for index in range(len(mvp_candidates)):
		mvp_candidates[index]["Score"] += pass_td_score
		pass_td_score -= 1
		if pass_td_score < 0:
			pass_td_score = 0
	mvp_candidates.sort_custom(func(a, b):
		return a["Score"] > b["Score"])
	if mvp_candidates.size() > 10:
		mvp_candidates = mvp_candidates.slice(0, 10)
	mvp_candidates.sort_custom(func(a, b):
		return a["interceptions"] < b["interceptions"])
	var int_score = 10
	for index in range(len(mvp_candidates)):
		mvp_candidates[index]["Score"] += int_score
		int_score -= 1
		if int_score < 0:
			int_score = 0
	mvp_candidates.sort_custom(func(a, b):
		return a["Score"] > b["Score"])
	var mvp = []
	mvp.append(mvp_candidates[0])
	return mvp

func get_opoy():
	var opoy_candidates = []
	var stats = SeasonStats.season_stats
	for player in stats:
		if "rec_yards" in stats[player]:
			stats[player]["PlayerID"] = player
			stats[player]["Score"] = 0
			opoy_candidates.append(stats[player])
	opoy_candidates.sort_custom(func(a, b):
		return a["rec_yards"] > b["rec_yards"])
	var rec_yards_score = 20
	for index in range(len(opoy_candidates)):
		opoy_candidates[index]["Score"] += rec_yards_score
		rec_yards_score -= 1
		if rec_yards_score < 0:
			break
	opoy_candidates.sort_custom(func(a, b):
		return a["rec_tds"] > b["rec_tds"])
	var rec_td_score = 20
	for index in range(len(opoy_candidates)):
		opoy_candidates[index]["Score"] += rec_td_score
		rec_td_score -= 1
		if rec_td_score < 0:
			break
	opoy_candidates.sort_custom(func(a, b):
		return a["catches"] > b["catches"])
	var catch_score = 20
	for index in range(len(opoy_candidates)):
		opoy_candidates[index]["Score"] += catch_score
		catch_score -= 1
		if catch_score < 0:
			break
	opoy_candidates.sort_custom(func(a, b):
		return a["rush_yards"] > b["rush_yards"])
	var rush_yard_score = 20
	for index in range(len(opoy_candidates)):
		opoy_candidates[index]["Score"] += rush_yard_score
		rush_yard_score -= 1
		if rush_yard_score < 0:
			break
	opoy_candidates.sort_custom(func(a, b):
		return a["rush_tds"] > b["rush_tds"])
	var rush_td_score = 20
	for index in range(len(opoy_candidates)):
		opoy_candidates[index]["Score"] += rush_td_score
		rush_td_score -= 1
		if rush_td_score < 0:
			break
	opoy_candidates.sort_custom(func(a, b):
		return a["rushes"] > b["rushes"])
	var rush_score = 20
	for index in range(len(opoy_candidates)):
		opoy_candidates[index]["Score"] += rush_score
		rush_score -= 1
		if rush_score < 0:
			break
	opoy_candidates.sort_custom(func(a, b):
		return a["Score"] > b["Score"])
	if opoy_candidates.size() > 10:
		opoy_candidates = opoy_candidates.slice(0, 10)
	opoy_candidates.sort_custom(func(a, b):
		return a["fumbles"] < b["fumbles"])
	var fumble_score = 10
	for index in range(len(opoy_candidates)):
		opoy_candidates[index]["Score"] += fumble_score
		fumble_score -= 1
		if fumble_score < 0:
			fumble_score = 0
	opoy_candidates.sort_custom(func(a, b):
		return a["Score"] > b["Score"])
	var opoy = []
	opoy.append(opoy_candidates[0])
	return opoy

func get_oroy():
	var rookies = []
	for team in Rosters.team_rosters.keys():
		if team != "Free Agent":
			for player in Rosters.team_rosters[team]:
				if player["Rookie"] == 1 and player["Position"] in ["QB", "RB", "TE", "RB"]:
					rookies.append(player["PlayerID"])
	var oroy_candidates = []
	var all_stats = SeasonStats.season_stats
	var stats = []
	for player in all_stats:
		if player in rookies:
			stats.append(all_stats[player])
	for player in stats:
		if "Score" in player:
			player["Score"] = 0
			if "rec_yards" in player:
				oroy_candidates.append(player)
	oroy_candidates.sort_custom(func(a, b):
		return a["rec_yards"] > b["rec_yards"])
	var rec_yards_score = 10
	for index in range(len(oroy_candidates)):
		oroy_candidates[index]["Score"] += rec_yards_score
		rec_yards_score -= 2
		if rec_yards_score <= 0:
			break
	oroy_candidates.sort_custom(func(a, b):
		return a["rec_tds"] > b["rec_tds"])
	var rec_td_score = 10
	for index in range(len(oroy_candidates)):
		oroy_candidates[index]["Score"] += rec_td_score
		rec_td_score -= 2
		if rec_td_score <= 0:
			break
	oroy_candidates.sort_custom(func(a, b):
		return a["catches"] > b["catches"])
	var catch_score = 5
	for index in range(len(oroy_candidates)):
		oroy_candidates[index]["Score"] += catch_score
		catch_score -= 1
		if catch_score <= 0:
			break
	oroy_candidates.sort_custom(func(a, b):
		return a["rush_yards"] > b["rush_yards"])
	var rush_yard_score = 10
	for index in range(len(oroy_candidates)):
		oroy_candidates[index]["Score"] += rush_yard_score
		rush_yard_score -= 2
		if rush_yard_score <= 0:
			break
	oroy_candidates.sort_custom(func(a, b):
		return a["rush_tds"] > b["rush_tds"])
	var rush_td_score = 10
	for index in range(len(oroy_candidates)):
		oroy_candidates[index]["Score"] += rush_td_score
		rush_td_score -= 2
		if rush_td_score <= 0:
			break
	oroy_candidates.sort_custom(func(a, b):
		return a["rushes"] > b["rushes"])
	var rush_score = 5
	for index in range(len(oroy_candidates)):
		oroy_candidates[index]["Score"] += rush_score
		rush_score -= 1
		if rush_score <= 0:
			break
	oroy_candidates.sort_custom(func(a, b):
		return a["Score"] > b["Score"])
	if oroy_candidates.size() > 10:
		oroy_candidates = oroy_candidates.slice(0, 10)
	oroy_candidates.sort_custom(func(a, b):
		return a["fumbles"] < b["fumbles"])
	var fumble_score = 15
	for index in range(len(oroy_candidates)):
		oroy_candidates[index]["Score"] += fumble_score
		fumble_score -= 3
		if fumble_score <= 0:
			fumble_score = 0
	
	oroy_candidates.sort_custom(func(a, b):
		return a["Score"] > b["Score"])
	var oroy = []
	var oroy_qb = []
	for player in stats:
		if "Score" in player:
			player["Score"] = 0
			if "pass_yards" in player:
				if player["pass_yards"] >= 3500 and player["pass_tds"] >= 30:
					oroy_qb.append(player)
				if oroy_qb.size() > 1:
					oroy_qb.sort_custom(func(a, b):
						return a["pass_yards"] > b["pass_yards"])
					oroy.append(oroy_qb[0])
					return oroy
				elif oroy_qb.size() == 1:
					oroy.append(oroy_qb[0])
					return oroy
				else:
					oroy.append(oroy_candidates[0])
					return oroy

func get_dpoy():
	var dpoy_candidates = []
	var stats = SeasonStats.season_stats
	for player in stats:
		if "tackles" in stats[player]:
			stats[player]["PlayerID"] = player
			stats[player]["Score"] = 0
			dpoy_candidates.append(stats[player])
	for player in dpoy_candidates:
		player["Score"] += player["touchdowns"] * 15
		player["Score"] += player["tackles"]
		player["Score"] += player["forced_fumbles"] * 10
		player["Score"] += player["sacks"] * 7
		player["Score"] += player["interceptions"] * 10
	dpoy_candidates.sort_custom(func(a, b):
		return a["Score"] > b["Score"])
	var dpoy = []
	dpoy.append(dpoy_candidates[0])
	return dpoy

func get_droy():
	var rookies = []
	for team in Rosters.team_rosters.keys():
		if team != "Free Agent":
			for player in Rosters.team_rosters[team]:
				if player["Rookie"] == 1 and player["Side"] == "Defense":
					rookies.append(player["PlayerID"])
	var droy_candidates = []
	var all_stats = SeasonStats.season_stats
	var stats = []
	for player in all_stats:
		if player in rookies:
			stats.append(all_stats[player])
	for player in stats:
		if "Score" in player:
			player["Score"] = 0
			if "tackles" in player:
				droy_candidates.append(player)
	for player in droy_candidates:
		player["Score"] += player["touchdowns"] * 15
		player["Score"] += player["tackles"]
		player["Score"] += player["forced_fumbles"] * 10
		player["Score"] += player["sacks"] * 7
		player["Score"] += player["interceptions"] * 10
	droy_candidates.sort_custom(func(a, b):
		return a["Score"] > b["Score"])
	var droy = []
	droy.append(droy_candidates[0])
	return droy

func season_end_popup():
	var mvp = get_mvp()
	var opoy = get_opoy()
	var oroy = get_oroy()
	var dpoy = get_dpoy()
	var droy = get_droy()
	var champ = super_bowl_winner
	var current_scene = get_tree().current_scene
	var season_end_scene = load("res://EndOfSeasonPopUp.tscn")
	var season_end_instance = season_end_scene.instantiate()
	season_end_instance.mvp = mvp
	season_end_instance.opoy = opoy
	season_end_instance.champ = champ
	season_end_instance.oroy = oroy
	season_end_instance.dpoy = dpoy
	season_end_instance.droy = droy
	get_tree().root.add_child(season_end_instance)
	get_tree().current_scene = season_end_instance

func salary_cap_popup():
	var popup = get_node("SalaryCapPopup")
	popup.popup_centered()
	
func roster_size_popup():
	var popup = get_node("RosterSizePopup")
	popup.popup_centered()

func position_min_popup(unfilled_positions):
	var popup = get_node("RosterMinPopup")
	var roster_min_popup_label = $RosterMinPopup/RosterMinPopupLabel
	var positions_str = ""
	for i in range(unfilled_positions.size()):
		positions_str += unfilled_positions[i]
		if i < unfilled_positions.size() - 1:
			positions_str += ", "
	roster_min_popup_label.text = "Following Positions Under Minimums: %s" % positions_str
	popup.popup_centered()

func check_position_mins():
	var position_minimums = {
		"QB": 2, "RB": 3, "WR": 4, "TE": 2, "RT": 2, "RG": 2, "C": 1,
		"LG": 2, "LT": 2, "LE": 2, "RE": 2, "DT": 3, "OLB": 3, "MLB": 2,
		"CB": 4, "SS": 2, "FS": 2, "K": 1, "P": 1, "R": 1
	}
	var unfilled_positions = []
	var position_counts = {}
	for position in position_minimums.keys():
		position_counts[position] = 0
	for player in Rosters.team_rosters[selected_team]:
		var player_position = player["Position"]
		if player_position in position_counts:
			position_counts[player_position] += 1
	for position in position_minimums.keys():
		var minimum = position_minimums[position]
		var shortfall = minimum - position_counts[position]
		if shortfall > 0:
			unfilled_positions.append(position)
	if unfilled_positions.size() > 0:
		position_min_popup(unfilled_positions)
		return 0

func check_injury_mins():
	var position_minimums = {
		"QB": 1, "RB": 1, "WR": 3, "TE": 1, "RT": 1, "RG": 1, "C": 1,
		"LG": 1, "LT": 1, "LE": 1, "RE": 1, "DT": 2, "OLB": 1, "MLB": 1,
		"CB": 2, "SS": 1, "FS": 1, "K": 1, "P": 1, "R": 1
	}
	var unfilled_positions = []
	var position_counts = {}
	for position in position_minimums.keys():
		position_counts[position] = 0
	for player in Rosters.team_rosters[selected_team]:
		var player_position = player["Position"]
		if player_position in position_counts and player["Injury"] != 1:
			position_counts[player_position] += 1
	for position in position_minimums.keys():
		var minimum = position_minimums[position]
		var shortfall = minimum - position_counts[position]
		if shortfall > 0:
			unfilled_positions.append(position)
	if unfilled_positions.size() > 0:
		position_min_popup(unfilled_positions)
		return 0

func trade_deadline_popup():
	var popup = get_node("TradeDeadlinePopup")
	popup.popup_centered()

func _on_test_button_pressed():
	print(Rosters.team_rosters["Free Agent"].size())

func injure_players():
	new_injured_players = []
	var oc_boost = 0
	var dc_boost = 0
	for oc in Coaches.team_ocs:
		if oc["Team"] == selected_team:
			if oc["Trait"] == "Safety First":
				match oc["Rank"]:
					"Copper":
						oc_boost = 1
					"Bronze":
						oc_boost = 2
					"Silver":
						oc_boost = 3
					"Gold":
						oc_boost = 4
					"Platinum":
						oc_boost = 5
					"Diamond":
						oc_boost = 6
	for dc in Coaches.team_dcs:
		if dc["Team"] == selected_team:
			if dc["Trait"] == "Safety First":
				match dc["Rank"]:
					"Copper":
						dc_boost = 1
					"Bronze":
						dc_boost = 2
					"Silver":
						dc_boost = 3
					"Gold":
						dc_boost = 4
					"Platinum":
						dc_boost = 5
					"Diamond":
						dc_boost = 6
	for player in Rosters.team_rosters[selected_team]:
		if player["Injury"] == 0:
			var rng = randf()
			var injury_chance = 0
			match player["Position"]:
				"QB":
					injury_chance = .99
				"RB":
					injury_chance = .97
				"WR":
					injury_chance = .975
				"TE":
					injury_chance = .98
				"LT":
					injury_chance = .985
				"LG":
					injury_chance = .985
				"C":
					injury_chance = .985
				"RG":
					injury_chance = .985
				"RT":
					injury_chance = .985
				"LE":
					injury_chance = .985
				"RE":
					injury_chance = .985
				"DT":
					injury_chance = .985
				"MLB":
					injury_chance = .985
				"OLB":
					injury_chance = .985
				"CB":
					injury_chance = .98
				"SS":
					injury_chance = .98
				"FS":
					injury_chance = .98
				"K":
					injury_chance = .9999
				"P":
					injury_chance = .9999
				"R":
					injury_chance = .97
			if player["Side"] == "Offense" and oc_boost != 0:
				var injury_chance_boost = 0
				var injury_chance_minus = 1 - injury_chance
				match oc_boost:
					1:
						injury_chance_boost = injury_chance_minus * .1
					2:
						injury_chance_boost = injury_chance_minus * .2
					3:
						injury_chance_boost = injury_chance_minus * .3
					4:
						injury_chance_boost = injury_chance_minus * .4
					5:
						injury_chance_boost = injury_chance_minus * .5
					6:
						injury_chance_boost = injury_chance_minus * .6
				injury_chance += injury_chance_boost
			if player["Side"] == "Defense" and dc_boost != 0:
				var injury_chance_boost = 0
				var injury_chance_minus = 1 - injury_chance
				match dc_boost:
					1:
						injury_chance_boost = injury_chance_minus * .1
					2:
						injury_chance_boost = injury_chance_minus * .2
					3:
						injury_chance_boost = injury_chance_minus * .3
					4:
						injury_chance_boost = injury_chance_minus * .4
					5:
						injury_chance_boost = injury_chance_minus * .5
					6:
						injury_chance_boost = injury_chance_minus * .6
				injury_chance += injury_chance_boost
			if player["DepthChart"] <= 2:
				var injury_depth_boost = 0
				var injury_depth_minus = 1 - injury_chance
				injury_depth_boost = injury_depth_minus * .5
				injury_chance += injury_depth_boost
			if rng > injury_chance:
				player["Injury"] = 1
				var injury_rng = randf()
				var injury_length = 0
				if injury_rng <= .3:
					injury_length = 2
				elif injury_rng <= .5:
					injury_length = 3
				elif injury_rng <= .55:
					injury_length = 4
				elif injury_rng <= .6:
					injury_length = 5
				elif injury_rng <= .65:
					injury_length = 6
				elif injury_rng <= .7:
					injury_length = 7
				elif injury_rng <= .75:
					injury_length = 8
				elif injury_rng <= .8:
					injury_length = 9
				elif injury_rng <= .85:
					injury_length = 10
				elif injury_rng <= .9:
					injury_length = 11
				elif injury_rng <= .95:
					injury_length = 12
				else:
					injury_length = 21
				player["Injury Length"] = injury_length
				
				new_injured_players.append(player)
				
	for player in Rosters.team_rosters[selected_team]:
		if player["Injury Length"] > 0:
			player["Injury Length"] -= 1
			if player["Injury Length"] == 0:
				player["Injury"] = 0
	
	if new_injured_players.size() > 0:
		new_injuries_popup()

func new_injuries_popup():
	populate_injury_popup("InjuryPopup/InjuryPopupContainer/InjuryPopupBox")
	var popup = get_node("InjuryPopup")
	popup.popup_centered()

func populate_injury_popup(container_path):
	var container = get_node(container_path)
	for child in container.get_children():
		child.queue_free()
	var injured_label = Label.new()
	injured_label.text = "Players Injured This Week"
	injured_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	container.add_child(injured_label)
	new_injured_players.sort_custom(func(a, b):
		return a["Rating"] > b["Rating"])
	for player in new_injured_players:
		var button_text = "%s %s %s OVR %d Age %d Potential %d Length: %d" % [player["Position"], player["FirstName"], player["LastName"], player["Rating"], player["Age"], player["Potential"], player["Injury Length"]]
		var player_button = Button.new()
		player_button.text = button_text
		container.add_child(player_button)

func reset_injuries():
	for player in Rosters.team_rosters[selected_team]:
		if player["Injury"] > 0:
			player["Injury"] = 0
		if player["Injury Length"] > 0:
			player["Injury"] = 0

func is_rivalry_game(team_left_name, team_right_name):
	var cfc_north = ["Louisville Stallions", "Cleveland Blue Jays", "Indianapolis Cougars", "Detroit Motors"]
	var cfc_east = ["Miami Pirates", "Boston Bobcats", "Tampa Wolverines", "Georgia Peaches"]
	var cfc_south = ["Kansas City Badgers", "Houston Bulls", "Nashville Strings", "Dallas Rebels"]
	var cfc_west = ["Seattle Vampires", "Sacramento Golds", "Albuquerque Scorpions", "Phoenix Roadrunners"]
	var ahc_north = ["Columbus Hawks", "Milwaukee Owls", "Chicago Warriors", "Baltimore Bombers"]
	var ahc_east = ["New York Spartans", "Charlotte Beasts", "Philadelphia Suns", "DC Senators"]
	var ahc_south = ["Oklahoma Tornadoes", "New Orleans Voodoo", "Omaha Ducks", "Memphis Pyramids"]
	var ahc_west = ["Las Vegas Aces", "Oregon Sea Lions", "San Diego Spartans", "Los Angeles Stars"]
	
	if team_left_name in cfc_north:
		if team_right_name in cfc_north:
			return 1
	elif team_left_name in cfc_east:
		if team_right_name in cfc_east:
			return 1
	elif team_left_name in cfc_south:
		if team_right_name in cfc_south:
			return 1
	elif team_left_name in cfc_west:
		if team_right_name in cfc_west:
			return 1
	elif team_left_name in ahc_north:
		if team_right_name in ahc_north:
			return 1
	elif team_left_name in ahc_east:
		if team_right_name in ahc_east:
			return 1
	elif team_left_name in ahc_south:
		if team_right_name in ahc_south:
			return 1
	elif team_left_name in ahc_west:
		if team_right_name in ahc_west:
			return 1
	return 0

func _on_season_stats_pressed():
	var current_scene = get_tree().current_scene
	var stats_scene = load("res://SeasonStats.tscn")
	var stats_instance = stats_scene.instantiate()
	
	get_tree().root.add_child(stats_instance)
	get_tree().current_scene = stats_instance

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


func _on_coaches_button_pressed():
	var current_scene = get_tree().current_scene
	var coach_scene = load("res://NewCoaches.tscn")
	var coach_instance = coach_scene.instantiate()
	
	get_tree().root.add_child(coach_instance)
	get_tree().current_scene = coach_instance
