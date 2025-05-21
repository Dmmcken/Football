#extends Node

#class_name GameSimulator

#func calculate_team_averages(team_roster):
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

#func simulate_game(team_left_name, team_right_name, roster_data):
	var team_left_roster = roster_data[team_left_name + "Roster"]
	var team_right_roster = roster_data[team_right_name + "Roster"]
	var team_left_averages = calculate_team_averages(team_left_roster)
	var team_right_averages = calculate_team_averages(team_right_roster)
	print("Simulating Game")
	var winner = team_left_name if team_left_averages["Team_Ovr"] > team_right_averages["Team_Ovr"] else team_right_name
	print("Winner: %s" % winner)
