var team_data = []

class Team:
	var name = ""
	var division = ""
	var conference = ""
	
	func _init(_name, _division, _conference):
		name = _name
		division = _division
		conference = _conference

func read_teams(json_file_path):
	var team_file = FileAccess.open("res://JSON Files/TeamsOvr.json", FileAccess.READ)
	var team_json = JSON.new()
	team_json.parse(team_file.get_as_text())
	team_file.close()
	team_data = team_json.get_data()
	for team_info in team_data:
		var team = Team.new(team_data["name"], team_data["Division"], team_data["Conference"])
		teams.append(team)
	return teams

var teams = read_teams("res://JSON Files/TeamsOvr.json")
