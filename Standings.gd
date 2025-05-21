extends Node2D

var team_records = {}
var records = []

func _ready():
	await get_tree().create_timer(.01).timeout
	create_records_array()
	shorten_names()
	populate_cfc_north()
	populate_cfc_east()
	populate_cfc_south()
	populate_cfc_west()
	populate_ahc_north()
	populate_ahc_east()
	populate_ahc_south()
	populate_ahc_west()

func create_records_array():
	records = convert_records_to_array()

func shorten_names():
	for team_data in records:
		match team_data["name"]:
			"Albuquerque Scorpions":
				team_data["name"] = "Albuquerque"
			"Baltimore Bombers":
				team_data["name"] = "Baltimore"
			"Boston Wildcats":
				team_data["name"] = "Boston"
			"Charlotte Beasts":
				team_data["name"] = "Charlotte"
			"Chicago Warriors":
				team_data["name"] = "Chicago"
			"Columbus Hawks":
				team_data["name"] = "Columbus"
			"Cleveland Blue Jays":
				team_data["name"] = "Cleveland"
			"Dallas Rebels":
				team_data["name"] = "Dallas"
			"DC Senators":
				team_data["name"] = "DC"
			"Detroit Motors":
				team_data["name"] = "Detroit"
			"Georgia Peaches":
				team_data["name"] = "Georgia"
			"Houston Bulls":
				team_data["name"] = "Houston"
			"Indianapolis Cougars":
				team_data["name"] = "Indianapolis"
			"Kansas City Badgers":
				team_data["name"] = "Kansas City"
			"Las Vegas Aces":
				team_data["name"] = "Las Vegas"
			"Los Angeles Stars":
				team_data["name"] = "Los Angeles"
			"Louisville Stallions":
				team_data["name"] = "Louisville"
			"Memphis Pyramids":
				team_data["name"] = "Memphis"
			"Miami Pirates":
				team_data["name"] = "Miami"
			"Milwaukee Owls":
				team_data["name"] = "Milwaukee"
			"Nashville Strings":
				team_data["name"] = "Nashville"
			"New Orleans Voodoo":
				team_data["name"] = "New Orleans"
			"New York Spartans":
				team_data["name"] = "New York"
			"Oklahoma Tornadoes":
				team_data["name"] = "Oklahoma"
			"Omaha Ducks":
				team_data["name"] = "Omaha"
			"Oregon Sea Lions":
				team_data["name"] = "Oregon"
			"Philadelphia Suns":
				team_data["name"] = "Philadelphia"
			"Phoenix Roadrunners":
				team_data["name"] = "Phoenix"
			"Sacramento Golds":
				team_data["name"] = "Sacramento"
			"San Diego Spartans":
				team_data["name"] = "San Diego"
			"Seattle Vampires":
				team_data["name"] = "Seattle"
			"Tampa Wolverines":
				team_data["name"] = "Tampa"

func compare_teams(team1, team2):
	if team1["Wins"] != team2["Wins"]:
		if team1["Wins"] > team2["Wins"]:
			return true
		else:
			return false
	elif team1["Division Wins"] != team2["Division Wins"]:
		if team1["Division Wins"] > team2["Division Wins"]:
			return true
		else:
			return false
	else:
		if team1["Conference Wins"] > team2["Conference Wins"]:
			return true
		else:
			return false
			
func sort_teams(teams_array):
	teams_array.sort_custom(compare_teams)
	
func convert_records_to_array():
	var records_array = []
	for team_name in team_records.keys():
		var team_data = team_records[team_name]
		team_data["name"] = team_name
		records_array.append(team_data)
	return records_array

func populate_cfc_north():
	var cfc_north = []
	for team_data in records:
		if team_data["Conference"] == "CFC":
			if team_data["Division"] == "North":
				cfc_north.append(team_data)
	sort_teams(cfc_north)
	var team_1_label = $Panel/CFCNTeam1
	var team_1_wl = $Panel/CFCN1WL
	var team_1_div = $Panel/CFCN1DIV
	var team_1_con = $Panel/CFCN1CON
	team_1_label.text = str(cfc_north[0]["name"])
	team_1_wl.text = "%d - %d" % [cfc_north[0]["Wins"], cfc_north[0]["Losses"]]
	team_1_div.text = "%d - %d" % [cfc_north[0]["Division Wins"], cfc_north[0]["Division Losses"]]
	team_1_con.text = "%d - %d" % [cfc_north[0]["Conference Wins"], cfc_north[0]["Conference Losses"]]
	var team_2_label = $Panel/CFCNTeam2
	var team_2_wl = $Panel/CFCN2WL
	var team_2_div = $Panel/CFCN2DIV
	var team_2_con = $Panel/CFCN2CON
	team_2_label.text = str(cfc_north[1]["name"])
	team_2_wl.text = "%d - %d" % [cfc_north[1]["Wins"], cfc_north[1]["Losses"]]
	team_2_div.text = "%d - %d" % [cfc_north[1]["Division Wins"], cfc_north[1]["Division Losses"]]
	team_2_con.text = "%d - %d" % [cfc_north[1]["Conference Wins"], cfc_north[1]["Conference Losses"]]
	var team_3_label = $Panel/CFCNTeam3
	var team_3_wl = $Panel/CFCN3WL
	var team_3_div = $Panel/CFCN3DIV
	var team_3_con = $Panel/CFCN3CON
	team_3_label.text = str(cfc_north[2]["name"])
	team_3_wl.text = "%d - %d" % [cfc_north[2]["Wins"], cfc_north[2]["Losses"]]
	team_3_div.text = "%d - %d" % [cfc_north[2]["Division Wins"], cfc_north[2]["Division Losses"]]
	team_3_con.text = "%d - %d" % [cfc_north[2]["Conference Wins"], cfc_north[2]["Conference Losses"]]
	var team_4_label = $Panel/CFCNTeam4
	var team_4_wl = $Panel/CFCN4WL
	var team_4_div = $Panel/CFCN4DIV
	var team_4_con = $Panel/CFCN4CON
	team_4_label.text = str(cfc_north[3]["name"])
	team_4_wl.text = "%d - %d" % [cfc_north[3]["Wins"], cfc_north[3]["Losses"]]
	team_4_div.text = "%d - %d" % [cfc_north[3]["Division Wins"], cfc_north[3]["Division Losses"]]
	team_4_con.text = "%d - %d" % [cfc_north[3]["Conference Wins"], cfc_north[3]["Conference Losses"]]

func populate_cfc_east():
	var cfc_east = []
	for team_data in records:
		if team_data["Conference"] == "CFC":
			if team_data["Division"] == "East":
				cfc_east.append(team_data)
	sort_teams(cfc_east)
	var team_1_label = $Panel/CFCETeam1
	var team_1_wl = $Panel/CFCE1WL
	var team_1_div = $Panel/CFCE1DIV
	var team_1_con = $Panel/CFCE1CON
	team_1_label.text = str(cfc_east[0]["name"])
	team_1_wl.text = "%d - %d" % [cfc_east[0]["Wins"], cfc_east[0]["Losses"]]
	team_1_div.text = "%d - %d" % [cfc_east[0]["Division Wins"], cfc_east[0]["Division Losses"]]
	team_1_con.text = "%d - %d" % [cfc_east[0]["Conference Wins"], cfc_east[0]["Conference Losses"]]
	var team_2_label = $Panel/CFCETeam2
	var team_2_wl = $Panel/CFCE2WL
	var team_2_div = $Panel/CFCE2DIV
	var team_2_con = $Panel/CFCE2CON
	team_2_label.text = str(cfc_east[1]["name"])
	team_2_wl.text = "%d - %d" % [cfc_east[1]["Wins"], cfc_east[1]["Losses"]]
	team_2_div.text = "%d - %d" % [cfc_east[1]["Division Wins"], cfc_east[1]["Division Losses"]]
	team_2_con.text = "%d - %d" % [cfc_east[1]["Conference Wins"], cfc_east[1]["Conference Losses"]]
	var team_3_label = $Panel/CFCETeam3
	var team_3_wl = $Panel/CFCE3WL
	var team_3_div = $Panel/CFCE3DIV
	var team_3_con = $Panel/CFCE3CON
	team_3_label.text = str(cfc_east[2]["name"])
	team_3_wl.text = "%d - %d" % [cfc_east[2]["Wins"], cfc_east[2]["Losses"]]
	team_3_div.text = "%d - %d" % [cfc_east[2]["Division Wins"], cfc_east[2]["Division Losses"]]
	team_3_con.text = "%d - %d" % [cfc_east[2]["Conference Wins"], cfc_east[2]["Conference Losses"]]
	var team_4_label = $Panel/CFCETeam4
	var team_4_wl = $Panel/CFCE4WL
	var team_4_div = $Panel/CFCE4DIV
	var team_4_con = $Panel/CFCE4CON
	team_4_label.text = str(cfc_east[3]["name"])
	team_4_wl.text = "%d - %d" % [cfc_east[3]["Wins"], cfc_east[3]["Losses"]]
	team_4_div.text = "%d - %d" % [cfc_east[3]["Division Wins"], cfc_east[3]["Division Losses"]]
	team_4_con.text = "%d - %d" % [cfc_east[3]["Conference Wins"], cfc_east[3]["Conference Losses"]]

func populate_cfc_south():
	var cfc_south = []
	for team_data in records:
		if team_data["Conference"] == "CFC":
			if team_data["Division"] == "South":
				cfc_south.append(team_data)
	sort_teams(cfc_south)
	var team_1_label = $Panel/CFCSTeam1
	var team_1_wl = $Panel/CFCS1WL
	var team_1_div = $Panel/CFCS1DIV
	var team_1_con = $Panel/CFCS1CON
	team_1_label.text = str(cfc_south[0]["name"])
	team_1_wl.text = "%d - %d" % [cfc_south[0]["Wins"], cfc_south[0]["Losses"]]
	team_1_div.text = "%d - %d" % [cfc_south[0]["Division Wins"], cfc_south[0]["Division Losses"]]
	team_1_con.text = "%d - %d" % [cfc_south[0]["Conference Wins"], cfc_south[0]["Conference Losses"]]
	var team_2_label = $Panel/CFCSTeam2
	var team_2_wl = $Panel/CFCS2WL
	var team_2_div = $Panel/CFCS2DIV
	var team_2_con = $Panel/CFCS2CON
	team_2_label.text = str(cfc_south[1]["name"])
	team_2_wl.text = "%d - %d" % [cfc_south[1]["Wins"], cfc_south[1]["Losses"]]
	team_2_div.text = "%d - %d" % [cfc_south[1]["Division Wins"], cfc_south[1]["Division Losses"]]
	team_2_con.text = "%d - %d" % [cfc_south[1]["Conference Wins"], cfc_south[1]["Conference Losses"]]
	var team_3_label = $Panel/CFCSTeam3
	var team_3_wl = $Panel/CFCS3WL
	var team_3_div = $Panel/CFCS3DIV
	var team_3_con = $Panel/CFCS3CON
	team_3_label.text = str(cfc_south[2]["name"])
	team_3_wl.text = "%d - %d" % [cfc_south[2]["Wins"], cfc_south[2]["Losses"]]
	team_3_div.text = "%d - %d" % [cfc_south[2]["Division Wins"], cfc_south[2]["Division Losses"]]
	team_3_con.text = "%d - %d" % [cfc_south[2]["Conference Wins"], cfc_south[2]["Conference Losses"]]
	var team_4_label = $Panel/CFCSTeam4
	var team_4_wl = $Panel/CFCS4WL
	var team_4_div = $Panel/CFCS4DIV
	var team_4_con = $Panel/CFCS4CON
	team_4_label.text = str(cfc_south[3]["name"])
	team_4_wl.text = "%d - %d" % [cfc_south[3]["Wins"], cfc_south[3]["Losses"]]
	team_4_div.text = "%d - %d" % [cfc_south[3]["Division Wins"], cfc_south[3]["Division Losses"]]
	team_4_con.text = "%d - %d" % [cfc_south[3]["Conference Wins"], cfc_south[3]["Conference Losses"]]

func populate_cfc_west():
	var cfc_west = []
	for team_data in records:
		if team_data["Conference"] == "CFC":
			if team_data["Division"] == "West":
				cfc_west.append(team_data)
	sort_teams(cfc_west)
	var team_1_label = $Panel/CFCWTeam1
	var team_1_wl = $Panel/CFCW1WL
	var team_1_div = $Panel/CFCW1DIV
	var team_1_con = $Panel/CFCW1CON
	team_1_label.text = str(cfc_west[0]["name"])
	team_1_wl.text = "%d - %d" % [cfc_west[0]["Wins"], cfc_west[0]["Losses"]]
	team_1_div.text = "%d - %d" % [cfc_west[0]["Division Wins"], cfc_west[0]["Division Losses"]]
	team_1_con.text = "%d - %d" % [cfc_west[0]["Conference Wins"], cfc_west[0]["Conference Losses"]]
	var team_2_label = $Panel/CFCWTeam2
	var team_2_wl = $Panel/CFCW2WL
	var team_2_div = $Panel/CFCW2DIV
	var team_2_con = $Panel/CFCW2CON
	team_2_label.text = str(cfc_west[1]["name"])
	team_2_wl.text = "%d - %d" % [cfc_west[1]["Wins"], cfc_west[1]["Losses"]]
	team_2_div.text = "%d - %d" % [cfc_west[1]["Division Wins"], cfc_west[1]["Division Losses"]]
	team_2_con.text = "%d - %d" % [cfc_west[1]["Conference Wins"], cfc_west[1]["Conference Losses"]]
	var team_3_label = $Panel/CFCWTeam3
	var team_3_wl = $Panel/CFCW3WL
	var team_3_div = $Panel/CFCW3DIV
	var team_3_con = $Panel/CFCW3CON
	team_3_label.text = str(cfc_west[2]["name"])
	team_3_wl.text = "%d - %d" % [cfc_west[2]["Wins"], cfc_west[2]["Losses"]]
	team_3_div.text = "%d - %d" % [cfc_west[2]["Division Wins"], cfc_west[2]["Division Losses"]]
	team_3_con.text = "%d - %d" % [cfc_west[2]["Conference Wins"], cfc_west[2]["Conference Losses"]]
	var team_4_label = $Panel/CFCWTeam4
	var team_4_wl = $Panel/CFCW4WL
	var team_4_div = $Panel/CFCW4DIV
	var team_4_con = $Panel/CFCW4CON
	team_4_label.text = str(cfc_west[3]["name"])
	team_4_wl.text = "%d - %d" % [cfc_west[3]["Wins"], cfc_west[3]["Losses"]]
	team_4_div.text = "%d - %d" % [cfc_west[3]["Division Wins"], cfc_west[3]["Division Losses"]]
	team_4_con.text = "%d - %d" % [cfc_west[3]["Conference Wins"], cfc_west[3]["Conference Losses"]]

func populate_ahc_north():
	var ahc_north = []
	for team_data in records:
		if team_data["Conference"] == "AHC":
			if team_data["Division"] == "North":
				ahc_north.append(team_data)
	sort_teams(ahc_north)
	var team_1_label = $Panel/AHCNTeam1
	var team_1_wl = $Panel/AHCN1WL
	var team_1_div = $Panel/AHCN1DIV
	var team_1_con = $Panel/AHCN1CON
	team_1_label.text = str(ahc_north[0]["name"])
	team_1_wl.text = "%d - %d" % [ahc_north[0]["Wins"], ahc_north[0]["Losses"]]
	team_1_div.text = "%d - %d" % [ahc_north[0]["Division Wins"], ahc_north[0]["Division Losses"]]
	team_1_con.text = "%d - %d" % [ahc_north[0]["Conference Wins"], ahc_north[0]["Conference Losses"]]
	var team_2_label = $Panel/AHCNTeam2
	var team_2_wl = $Panel/AHCN2WL
	var team_2_div = $Panel/AHCN2DIV
	var team_2_con = $Panel/AHCN2CON
	team_2_label.text = str(ahc_north[1]["name"])
	team_2_wl.text = "%d - %d" % [ahc_north[1]["Wins"], ahc_north[1]["Losses"]]
	team_2_div.text = "%d - %d" % [ahc_north[1]["Division Wins"], ahc_north[1]["Division Losses"]]
	team_2_con.text = "%d - %d" % [ahc_north[1]["Conference Wins"], ahc_north[1]["Conference Losses"]]
	var team_3_label = $Panel/AHCNTeam3
	var team_3_wl = $Panel/AHCN3WL
	var team_3_div = $Panel/AHCN3DIV
	var team_3_con = $Panel/AHCN3CON
	team_3_label.text = str(ahc_north[2]["name"])
	team_3_wl.text = "%d - %d" % [ahc_north[2]["Wins"], ahc_north[2]["Losses"]]
	team_3_div.text = "%d - %d" % [ahc_north[2]["Division Wins"], ahc_north[2]["Division Losses"]]
	team_3_con.text = "%d - %d" % [ahc_north[2]["Conference Wins"], ahc_north[2]["Conference Losses"]]
	var team_4_label = $Panel/AHCNTeam4
	var team_4_wl = $Panel/AHCN4WL
	var team_4_div = $Panel/AHCN4DIV
	var team_4_con = $Panel/AHCN4CON
	team_4_label.text = str(ahc_north[3]["name"])
	team_4_wl.text = "%d - %d" % [ahc_north[3]["Wins"], ahc_north[3]["Losses"]]
	team_4_div.text = "%d - %d" % [ahc_north[3]["Division Wins"], ahc_north[3]["Division Losses"]]
	team_4_con.text = "%d - %d" % [ahc_north[3]["Conference Wins"], ahc_north[3]["Conference Losses"]]

func populate_ahc_east():
	var ahc_east = []
	for team_data in records:
		if team_data["Conference"] == "AHC":
			if team_data["Division"] == "East":
				ahc_east.append(team_data)
	sort_teams(ahc_east)
	var team_1_label = $Panel/AHCETeam1
	var team_1_wl = $Panel/AHCE1WL
	var team_1_div = $Panel/AHCE1DIV
	var team_1_con = $Panel/AHCE1CON
	team_1_label.text = str(ahc_east[0]["name"])
	team_1_wl.text = "%d - %d" % [ahc_east[0]["Wins"], ahc_east[0]["Losses"]]
	team_1_div.text = "%d - %d" % [ahc_east[0]["Division Wins"], ahc_east[0]["Division Losses"]]
	team_1_con.text = "%d - %d" % [ahc_east[0]["Conference Wins"], ahc_east[0]["Conference Losses"]]
	var team_2_label = $Panel/AHCETeam2
	var team_2_wl = $Panel/AHCE2WL
	var team_2_div = $Panel/AHCE2DIV
	var team_2_con = $Panel/AHCE2CON
	team_2_label.text = str(ahc_east[1]["name"])
	team_2_wl.text = "%d - %d" % [ahc_east[1]["Wins"], ahc_east[1]["Losses"]]
	team_2_div.text = "%d - %d" % [ahc_east[1]["Division Wins"], ahc_east[1]["Division Losses"]]
	team_2_con.text = "%d - %d" % [ahc_east[1]["Conference Wins"], ahc_east[1]["Conference Losses"]]
	var team_3_label = $Panel/AHCETeam3
	var team_3_wl = $Panel/AHCE3WL
	var team_3_div = $Panel/AHCE3DIV
	var team_3_con = $Panel/AHCE3CON
	team_3_label.text = str(ahc_east[2]["name"])
	team_3_wl.text = "%d - %d" % [ahc_east[2]["Wins"], ahc_east[2]["Losses"]]
	team_3_div.text = "%d - %d" % [ahc_east[2]["Division Wins"], ahc_east[2]["Division Losses"]]
	team_3_con.text = "%d - %d" % [ahc_east[2]["Conference Wins"], ahc_east[2]["Conference Losses"]]
	var team_4_label = $Panel/AHCETeam4
	var team_4_wl = $Panel/AHCE4WL
	var team_4_div = $Panel/AHCE4DIV
	var team_4_con = $Panel/AHCE4CON
	team_4_label.text = str(ahc_east[3]["name"])
	team_4_wl.text = "%d - %d" % [ahc_east[3]["Wins"], ahc_east[3]["Losses"]]
	team_4_div.text = "%d - %d" % [ahc_east[3]["Division Wins"], ahc_east[3]["Division Losses"]]
	team_4_con.text = "%d - %d" % [ahc_east[3]["Conference Wins"], ahc_east[3]["Conference Losses"]]

func populate_ahc_south():
	var ahc_south = []
	for team_data in records:
		if team_data["Conference"] == "AHC":
			if team_data["Division"] == "South":
				ahc_south.append(team_data)
	sort_teams(ahc_south)
	var team_1_label = $Panel/AHCSTeam1
	var team_1_wl = $Panel/AHCS1WL
	var team_1_div = $Panel/AHCS1DIV
	var team_1_con = $Panel/AHCS1CON
	team_1_label.text = str(ahc_south[0]["name"])
	team_1_wl.text = "%d - %d" % [ahc_south[0]["Wins"], ahc_south[0]["Losses"]]
	team_1_div.text = "%d - %d" % [ahc_south[0]["Division Wins"], ahc_south[0]["Division Losses"]]
	team_1_con.text = "%d - %d" % [ahc_south[0]["Conference Wins"], ahc_south[0]["Conference Losses"]]
	var team_2_label = $Panel/AHCSTeam2
	var team_2_wl = $Panel/AHCS2WL
	var team_2_div = $Panel/AHCS2DIV
	var team_2_con = $Panel/AHCS2CON
	team_2_label.text = str(ahc_south[1]["name"])
	team_2_wl.text = "%d - %d" % [ahc_south[1]["Wins"], ahc_south[1]["Losses"]]
	team_2_div.text = "%d - %d" % [ahc_south[1]["Division Wins"], ahc_south[1]["Division Losses"]]
	team_2_con.text = "%d - %d" % [ahc_south[1]["Conference Wins"], ahc_south[1]["Conference Losses"]]
	var team_3_label = $Panel/AHCSTeam3
	var team_3_wl = $Panel/AHCS3WL
	var team_3_div = $Panel/AHCS3DIV
	var team_3_con = $Panel/AHCS3CON
	team_3_label.text = str(ahc_south[2]["name"])
	team_3_wl.text = "%d - %d" % [ahc_south[2]["Wins"], ahc_south[2]["Losses"]]
	team_3_div.text = "%d - %d" % [ahc_south[2]["Division Wins"], ahc_south[2]["Division Losses"]]
	team_3_con.text = "%d - %d" % [ahc_south[2]["Conference Wins"], ahc_south[2]["Conference Losses"]]
	var team_4_label = $Panel/AHCSTeam4
	var team_4_wl = $Panel/AHCS4WL
	var team_4_div = $Panel/AHCS4DIV
	var team_4_con = $Panel/AHCS4CON
	team_4_label.text = str(ahc_south[3]["name"])
	team_4_wl.text = "%d - %d" % [ahc_south[3]["Wins"], ahc_south[3]["Losses"]]
	team_4_div.text = "%d - %d" % [ahc_south[3]["Division Wins"], ahc_south[3]["Division Losses"]]
	team_4_con.text = "%d - %d" % [ahc_south[3]["Conference Wins"], ahc_south[3]["Conference Losses"]]

func populate_ahc_west():
	var ahc_west = []
	for team_data in records:
		if team_data["Conference"] == "AHC":
			if team_data["Division"] == "West":
				ahc_west.append(team_data)
	sort_teams(ahc_west)
	var team_1_label = $Panel/AHCWTeam1
	var team_1_wl = $Panel/AHCW1WL
	var team_1_div = $Panel/AHCW1DIV
	var team_1_con = $Panel/AHCW1CON
	team_1_label.text = str(ahc_west[0]["name"])
	team_1_wl.text = "%d - %d" % [ahc_west[0]["Wins"], ahc_west[0]["Losses"]]
	team_1_div.text = "%d - %d" % [ahc_west[0]["Division Wins"], ahc_west[0]["Division Losses"]]
	team_1_con.text = "%d - %d" % [ahc_west[0]["Conference Wins"], ahc_west[0]["Conference Losses"]]
	var team_2_label = $Panel/AHCWTeam2
	var team_2_wl = $Panel/AHCW2WL
	var team_2_div = $Panel/AHCW2DIV
	var team_2_con = $Panel/AHCW2CON
	team_2_label.text = str(ahc_west[1]["name"])
	team_2_wl.text = "%d - %d" % [ahc_west[1]["Wins"], ahc_west[1]["Losses"]]
	team_2_div.text = "%d - %d" % [ahc_west[1]["Division Wins"], ahc_west[1]["Division Losses"]]
	team_2_con.text = "%d - %d" % [ahc_west[1]["Conference Wins"], ahc_west[1]["Conference Losses"]]
	var team_3_label = $Panel/AHCWTeam3
	var team_3_wl = $Panel/AHCW3WL
	var team_3_div = $Panel/AHCW3DIV
	var team_3_con = $Panel/AHCW3CON
	team_3_label.text = str(ahc_west[2]["name"])
	team_3_wl.text = "%d - %d" % [ahc_west[2]["Wins"], ahc_west[2]["Losses"]]
	team_3_div.text = "%d - %d" % [ahc_west[2]["Division Wins"], ahc_west[2]["Division Losses"]]
	team_3_con.text = "%d - %d" % [ahc_west[2]["Conference Wins"], ahc_west[2]["Conference Losses"]]
	var team_4_label = $Panel/AHCWTeam4
	var team_4_wl = $Panel/AHCW4WL
	var team_4_div = $Panel/AHCW4DIV
	var team_4_con = $Panel/AHCW4CON
	team_4_label.text = str(ahc_west[3]["name"])
	team_4_wl.text = "%d - %d" % [ahc_west[3]["Wins"], ahc_west[3]["Losses"]]
	team_4_div.text = "%d - %d" % [ahc_west[3]["Division Wins"], ahc_west[3]["Division Losses"]]
	team_4_con.text = "%d - %d" % [ahc_west[3]["Conference Wins"], ahc_west[3]["Conference Losses"]]

func _on_close_button_pressed():
	queue_free()
