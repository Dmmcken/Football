extends Node2D

var selected_stat = "Passing"
var seasonstats = SeasonStats.season_stats
var passing = []
var rushing = []
var receiving = []
var defense = []
var kicking = []


func _ready():
	apply_names()
	create_arrays()
	order_arrays()
	populate_passing_stats()

func update_stats():
	var containers = [$NameScroll/Control/Name, $NameScroll/Control/Team, $NameScroll/Control/SixStat1, $NameScroll/Control/SixStat2, $NameScroll/Control/SixStat3, $NameScroll/Control/SixStat4, $NameScroll/Control/SixStat5, $NameScroll/Control/SixStat6, $NameScroll/Control/FiveStat1, $NameScroll/Control/FiveStat2, $NameScroll/Control/FiveStat3, $NameScroll/Control/FiveStat4, $NameScroll/Control/FiveStat5]
	for container in containers:
		var children = container.get_children()
		for child in children:
			child.queue_free()
	if selected_stat == "Passing":
		activate_6_stat()
		deactivate_5_stat()
		populate_passing_stats()
	elif selected_stat == "Rushing":
		deactivate_6_stat()
		activate_5_stat()
		populate_rushing_stats()
	elif selected_stat == "Receiving":
		deactivate_6_stat()
		activate_5_stat()
		populate_receiving_stats()
	elif selected_stat == "Defense":
		deactivate_6_stat()
		activate_5_stat()
		populate_defense_stats()
	elif selected_stat == "Kicking":
		activate_6_stat()
		deactivate_5_stat()
		populate_kicking_stats()

func create_arrays():
	for player in seasonstats:
		if "pass_yards" in seasonstats[player]:
			passing.append(seasonstats[player])
		if "rush_yards" in seasonstats[player]:
			if seasonstats[player]["rush_yards"] != 0 and seasonstats[player]["rushes"] >= 1:
				rushing.append(seasonstats[player])
		if "rec_yards" in seasonstats[player]:
			if seasonstats[player]["rec_yards"] != 0 and seasonstats[player]["catches"] >= 1:
				receiving.append(seasonstats[player])
		if "tackles" in seasonstats[player]:
			defense.append(seasonstats[player])
		if "xp_makes" in seasonstats[player]:
			kicking.append(seasonstats[player])

func apply_names():
	for player in seasonstats:
		for team in Rosters.team_rosters:
			for player2 in Rosters.team_rosters[team]:
				if player2["PlayerID"] == player:
					seasonstats[player]["FirstName"] = player2["FirstName"]
					seasonstats[player]["LastName"] = player2["LastName"]
					seasonstats[player]["Team"] = team

func order_arrays():
	passing.sort_custom(func(a, b):
		return a["pass_yards"] > b["pass_yards"])
	rushing.sort_custom(func(a, b):
		return a["rush_yards"] > b["rush_yards"])
	receiving.sort_custom(func(a, b):
		return a["rec_yards"] > b["rec_yards"])
	defense.sort_custom(func(a, b):
		return a["tackles"] > b["tackles"])
	kicking.sort_custom(func(a, b):
		return a["under_30_makes"] > b["under_30_makes"])

func activate_6_stat():
	$NameScroll/Control/SixStat1.visible = true
	$NameScroll/Control/SixStat2.visible = true
	$NameScroll/Control/SixStat3.visible = true
	$NameScroll/Control/SixStat4.visible = true
	$NameScroll/Control/SixStat5.visible = true
	$NameScroll/Control/SixStat6.visible = true
	$SixStat1.visible = true
	$SixStat2.visible = true
	$SixStat3.visible = true
	$SixStat4.visible = true
	$SixStat5.visible = true
	$SixStat6.visible = true

func activate_5_stat():
	$NameScroll/Control/FiveStat1.visible = true
	$NameScroll/Control/FiveStat2.visible = true
	$NameScroll/Control/FiveStat3.visible = true
	$NameScroll/Control/FiveStat4.visible = true
	$NameScroll/Control/FiveStat5.visible = true
	$FiveStat1.visible = true
	$FiveStat2.visible = true
	$FiveStat3.visible = true
	$FiveStat4.visible = true
	$FiveStat5.visible = true

func deactivate_6_stat():
	$NameScroll/Control/SixStat1.visible = false
	$NameScroll/Control/SixStat2.visible = false
	$NameScroll/Control/SixStat3.visible = false
	$NameScroll/Control/SixStat4.visible = false
	$NameScroll/Control/SixStat5.visible = false
	$NameScroll/Control/SixStat6.visible = false
	$SixStat1.visible = false
	$SixStat2.visible = false
	$SixStat3.visible = false
	$SixStat4.visible = false
	$SixStat5.visible = false
	$SixStat6.visible = false

func deactivate_5_stat():
	$NameScroll/Control/FiveStat1.visible = false
	$NameScroll/Control/FiveStat2.visible = false
	$NameScroll/Control/FiveStat3.visible = false
	$NameScroll/Control/FiveStat4.visible = false
	$NameScroll/Control/FiveStat5.visible = false
	$FiveStat1.visible = false
	$FiveStat2.visible = false
	$FiveStat3.visible = false
	$FiveStat4.visible = false
	$FiveStat5.visible = false

func populate_passing_stats():
	var y = 0
	for player in passing:
		var name_button = Button.new()
		name_button.text = "%s %s" % [player["FirstName"], player["LastName"]]
		$NameScroll/Control/Name.add_child(name_button)
		var team_button = Button.new()
		var team = ""
		match player["Team"]:
			"Albuquerque Scorpions":
				team = "ABQ"
			"Baltimore Bombers":
				team = "BAL"
			"Boston Wildcats":
				team = "BOS"
			"Charlotte Beasts":
				team = "CHA"
			"Chicago Warriors":
				team = "CHI"
			"Columbus Hawks":
				team = "COL"
			"Cleveland Blue Jays":
				team = "CLE"
			"Dallas Rebels":
				team = "DAL"
			"DC Senators":
				team = "DC"
			"Detroit Motors":
				team = "DET"
			"Georgia Peaches":
				team = "GA"
			"Houston Bulls":
				team = "HOU"
			"Indianapolis Cougars":
				team = "IND"
			"Kansas City Badgers":
				team = "KC"
			"Las Vegas Aces":
				team = "LV"
			"Los Angeles Stars":
				team = "LA"
			"Louisville Stallions":
				team = "LOU"
			"Memphis Pyramids":
				team = "MEM"
			"Miami Pirates":
				team = "MIA"
			"Milwaukee Owls":
				team = "MIL"
			"Nashville Strings":
				team = "NAS"
			"New Orleans Voodoo":
				team = "NOR"
			"New York Spartans":
				team = "NY"
			"Oklahoma Tornadoes":
				team = "OK"
			"Omaha Ducks":
				team = "OMA"
			"Oregon Sea Lions":
				team = "ORE"
			"Philadelphia Suns":
				team = "PHI"
			"Phoenix Roadrunners":
				team = "PHO"
			"Sacramento Golds":
				team = "SAC"
			"San Diego Spartans":
				team = "SD"
			"Seattle Vampires":
				team = "SEA"
			"Tampa Wolverines":
				team = "TAM"
		team_button.text = team
		$NameScroll/Control/Team.add_child(team_button)
		var yards_button = Button.new()
		yards_button.text = str(player["pass_yards"])
		$NameScroll/Control/SixStat1.add_child(yards_button)
		var td_button = Button.new()
		td_button.text = str(player["pass_tds"])
		$NameScroll/Control/SixStat2.add_child(td_button)
		var comp_button = Button.new()
		comp_button.text = str(player["completions"])
		$NameScroll/Control/SixStat3.add_child(comp_button)
		var att_button = Button.new()
		att_button.text = str(player["attempts"])
		$NameScroll/Control/SixStat4.add_child(att_button)
		var percent_button = Button.new()
		var comp = float(player["completions"])
		var att = float(player["attempts"])
		var percent = (comp/att) * 100
		var rounded_percent = round(percent * 10.0) / 10.0
		percent_button.text = str(rounded_percent)
		$NameScroll/Control/SixStat5.add_child(percent_button)
		var int_button = Button.new()
		int_button.text = str(player["interceptions"])
		$NameScroll/Control/SixStat6.add_child(int_button)
		y += 35 
	$NameScroll/Control.custom_minimum_size = Vector2(0, y)

func populate_rushing_stats():
	var y = 0
	$FiveStat1.text = "Yards"
	$FiveStat2.text = "TDs"
	$FiveStat3.text = "Rushes"
	$FiveStat4.text = "Y/Att"
	$FiveStat5.text = "Fumbles"
	for player in rushing:
		var name_button = Button.new()
		name_button.text = "%s %s" % [player["FirstName"], player["LastName"]]
		$NameScroll/Control/Name.add_child(name_button)
		var team_button = Button.new()
		var team = ""
		match player["Team"]:
			"Albuquerque Scorpions":
				team = "ABQ"
			"Baltimore Bombers":
				team = "BAL"
			"Boston Wildcats":
				team = "BOS"
			"Charlotte Beasts":
				team = "CHA"
			"Chicago Warriors":
				team = "CHI"
			"Columbus Hawks":
				team = "COL"
			"Cleveland Blue Jays":
				team = "CLE"
			"Dallas Rebels":
				team = "DAL"
			"DC Senators":
				team = "DC"
			"Detroit Motors":
				team = "DET"
			"Georgia Peaches":
				team = "GA"
			"Houston Bulls":
				team = "HOU"
			"Indianapolis Cougars":
				team = "IND"
			"Kansas City Badgers":
				team = "KC"
			"Las Vegas Aces":
				team = "LV"
			"Los Angeles Stars":
				team = "LA"
			"Louisville Stallions":
				team = "LOU"
			"Memphis Pyramids":
				team = "MEM"
			"Miami Pirates":
				team = "MIA"
			"Milwaukee Owls":
				team = "MIL"
			"Nashville Strings":
				team = "NAS"
			"New Orleans Voodoo":
				team = "NOR"
			"New York Spartans":
				team = "NY"
			"Oklahoma Tornadoes":
				team = "OK"
			"Omaha Ducks":
				team = "OMA"
			"Oregon Sea Lions":
				team = "ORE"
			"Philadelphia Suns":
				team = "PHI"
			"Phoenix Roadrunners":
				team = "PHO"
			"Sacramento Golds":
				team = "SAC"
			"San Diego Spartans":
				team = "SD"
			"Seattle Vampires":
				team = "SEA"
			"Tampa Wolverines":
				team = "TAM"
		team_button.text = team
		$NameScroll/Control/Team.add_child(team_button)
		var yards_button = Button.new()
		yards_button.text = str(player["rush_yards"])
		$NameScroll/Control/FiveStat1.add_child(yards_button)
		var td_button = Button.new()
		td_button.text = str(player["rush_tds"])
		$NameScroll/Control/FiveStat2.add_child(td_button)
		var comp_button = Button.new()
		comp_button.text = str(player["rushes"])
		$NameScroll/Control/FiveStat3.add_child(comp_button)
		var att_button = Button.new()
		var yards = float(player["rush_yards"])
		var atts = float(player["rushes"])
		var y_att = (yards/atts)
		var rounded = round(y_att * 10.0) / 10.0
		att_button.text = str(rounded)
		$NameScroll/Control/FiveStat4.add_child(att_button)
		var percent_button = Button.new()
		percent_button.text = str(player["fumbles"])
		$NameScroll/Control/FiveStat5.add_child(percent_button)
		y += 35 
	$NameScroll/Control.custom_minimum_size = Vector2(0, y)

func populate_receiving_stats():
	var y = 0
	$FiveStat1.text = "Yards"
	$FiveStat2.text = "TDs"
	$FiveStat3.text = "Recs"
	$FiveStat4.text = "Y/Rec"
	$FiveStat5.text = "Fumbles"
	for player in receiving:
		var name_button = Button.new()
		name_button.text = "%s %s" % [player["FirstName"], player["LastName"]]
		$NameScroll/Control/Name.add_child(name_button)
		var team_button = Button.new()
		var team = ""
		match player["Team"]:
			"Albuquerque Scorpions":
				team = "ABQ"
			"Baltimore Bombers":
				team = "BAL"
			"Boston Wildcats":
				team = "BOS"
			"Charlotte Beasts":
				team = "CHA"
			"Chicago Warriors":
				team = "CHI"
			"Columbus Hawks":
				team = "COL"
			"Cleveland Blue Jays":
				team = "CLE"
			"Dallas Rebels":
				team = "DAL"
			"DC Senators":
				team = "DC"
			"Detroit Motors":
				team = "DET"
			"Georgia Peaches":
				team = "GA"
			"Houston Bulls":
				team = "HOU"
			"Indianapolis Cougars":
				team = "IND"
			"Kansas City Badgers":
				team = "KC"
			"Las Vegas Aces":
				team = "LV"
			"Los Angeles Stars":
				team = "LA"
			"Louisville Stallions":
				team = "LOU"
			"Memphis Pyramids":
				team = "MEM"
			"Miami Pirates":
				team = "MIA"
			"Milwaukee Owls":
				team = "MIL"
			"Nashville Strings":
				team = "NAS"
			"New Orleans Voodoo":
				team = "NOR"
			"New York Spartans":
				team = "NY"
			"Oklahoma Tornadoes":
				team = "OK"
			"Omaha Ducks":
				team = "OMA"
			"Oregon Sea Lions":
				team = "ORE"
			"Philadelphia Suns":
				team = "PHI"
			"Phoenix Roadrunners":
				team = "PHO"
			"Sacramento Golds":
				team = "SAC"
			"San Diego Spartans":
				team = "SD"
			"Seattle Vampires":
				team = "SEA"
			"Tampa Wolverines":
				team = "TAM"
		team_button.text = team
		$NameScroll/Control/Team.add_child(team_button)
		var yards_button = Button.new()
		yards_button.text = str(player["rec_yards"])
		$NameScroll/Control/FiveStat1.add_child(yards_button)
		var td_button = Button.new()
		td_button.text = str(player["rec_tds"])
		$NameScroll/Control/FiveStat2.add_child(td_button)
		var comp_button = Button.new()
		comp_button.text = str(player["catches"])
		$NameScroll/Control/FiveStat3.add_child(comp_button)
		var att_button = Button.new()
		var yards = float(player["rec_yards"])
		var atts = float(player["catches"])
		var y_att = (yards/atts)
		var rounded = round(y_att * 10.0) / 10.0
		att_button.text = str(rounded)
		$NameScroll/Control/FiveStat4.add_child(att_button)
		var percent_button = Button.new()
		percent_button.text = str(player["fumbles"])
		$NameScroll/Control/FiveStat5.add_child(percent_button)
		y += 35 
	$NameScroll/Control.custom_minimum_size = Vector2(0, y)

func populate_defense_stats():
	var y = 0
	$FiveStat1.text = "Tkls"
	$FiveStat2.text = "Sacks"
	$FiveStat3.text = "Ints"
	$FiveStat4.text = "FF"
	$FiveStat5.text = "TDs"
	for player in defense:
		var name_button = Button.new()
		name_button.text = "%s %s" % [player["FirstName"], player["LastName"]]
		$NameScroll/Control/Name.add_child(name_button)
		var team_button = Button.new()
		var team = ""
		match player["Team"]:
			"Albuquerque Scorpions":
				team = "ABQ"
			"Baltimore Bombers":
				team = "BAL"
			"Boston Wildcats":
				team = "BOS"
			"Charlotte Beasts":
				team = "CHA"
			"Chicago Warriors":
				team = "CHI"
			"Columbus Hawks":
				team = "COL"
			"Cleveland Blue Jays":
				team = "CLE"
			"Dallas Rebels":
				team = "DAL"
			"DC Senators":
				team = "DC"
			"Detroit Motors":
				team = "DET"
			"Georgia Peaches":
				team = "GA"
			"Houston Bulls":
				team = "HOU"
			"Indianapolis Cougars":
				team = "IND"
			"Kansas City Badgers":
				team = "KC"
			"Las Vegas Aces":
				team = "LV"
			"Los Angeles Stars":
				team = "LA"
			"Louisville Stallions":
				team = "LOU"
			"Memphis Pyramids":
				team = "MEM"
			"Miami Pirates":
				team = "MIA"
			"Milwaukee Owls":
				team = "MIL"
			"Nashville Strings":
				team = "NAS"
			"New Orleans Voodoo":
				team = "NOR"
			"New York Spartans":
				team = "NY"
			"Oklahoma Tornadoes":
				team = "OK"
			"Omaha Ducks":
				team = "OMA"
			"Oregon Sea Lions":
				team = "ORE"
			"Philadelphia Suns":
				team = "PHI"
			"Phoenix Roadrunners":
				team = "PHO"
			"Sacramento Golds":
				team = "SAC"
			"San Diego Spartans":
				team = "SD"
			"Seattle Vampires":
				team = "SEA"
			"Tampa Wolverines":
				team = "TAM"
		team_button.text = team
		$NameScroll/Control/Team.add_child(team_button)
		var yards_button = Button.new()
		yards_button.text = str(player["tackles"])
		$NameScroll/Control/FiveStat1.add_child(yards_button)
		var td_button = Button.new()
		td_button.text = str(player["sacks"])
		$NameScroll/Control/FiveStat2.add_child(td_button)
		var comp_button = Button.new()
		comp_button.text = str(player["interceptions"])
		$NameScroll/Control/FiveStat3.add_child(comp_button)
		var att_button = Button.new()
		att_button.text = str(player["forced_fumbles"])
		$NameScroll/Control/FiveStat4.add_child(att_button)
		var percent_button = Button.new()
		percent_button.text = str(player["touchdowns"])
		$NameScroll/Control/FiveStat5.add_child(percent_button)
		y += 35 
	$NameScroll/Control.custom_minimum_size = Vector2(0, y)

func populate_kicking_stats():
	var y = 0
	$SixStat1.text = "Under 30"
	$SixStat2.text = "30-40"
	$SixStat3.text = "41-50"
	$SixStat4.text = "51-60"
	$SixStat5.text = "Over 61"
	$SixStat6.text = "XP"
	for player in kicking:
		var name_button = Button.new()
		name_button.text = "%s %s" % [player["FirstName"], player["LastName"]]
		$NameScroll/Control/Name.add_child(name_button)
		var team_button = Button.new()
		var team = ""
		match player["Team"]:
			"Albuquerque Scorpions":
				team = "ABQ"
			"Baltimore Bombers":
				team = "BAL"
			"Boston Wildcats":
				team = "BOS"
			"Charlotte Beasts":
				team = "CHA"
			"Chicago Warriors":
				team = "CHI"
			"Columbus Hawks":
				team = "COL"
			"Cleveland Blue Jays":
				team = "CLE"
			"Dallas Rebels":
				team = "DAL"
			"DC Senators":
				team = "DC"
			"Detroit Motors":
				team = "DET"
			"Georgia Peaches":
				team = "GA"
			"Houston Bulls":
				team = "HOU"
			"Indianapolis Cougars":
				team = "IND"
			"Kansas City Badgers":
				team = "KC"
			"Las Vegas Aces":
				team = "LV"
			"Los Angeles Stars":
				team = "LA"
			"Louisville Stallions":
				team = "LOU"
			"Memphis Pyramids":
				team = "MEM"
			"Miami Pirates":
				team = "MIA"
			"Milwaukee Owls":
				team = "MIL"
			"Nashville Strings":
				team = "NAS"
			"New Orleans Voodoo":
				team = "NOR"
			"New York Spartans":
				team = "NY"
			"Oklahoma Tornadoes":
				team = "OK"
			"Omaha Ducks":
				team = "OMA"
			"Oregon Sea Lions":
				team = "ORE"
			"Philadelphia Suns":
				team = "PHI"
			"Phoenix Roadrunners":
				team = "PHO"
			"Sacramento Golds":
				team = "SAC"
			"San Diego Spartans":
				team = "SD"
			"Seattle Vampires":
				team = "SEA"
			"Tampa Wolverines":
				team = "TAM"
		team_button.text = team
		$NameScroll/Control/Team.add_child(team_button)
		var yards_button = Button.new()
		yards_button.text = "%d/%d" % [player["under_30_makes"], player["under_30_attempts"]]
		$NameScroll/Control/SixStat1.add_child(yards_button)
		var td_button = Button.new()
		td_button.text = "%d/%d" % [player["makes_30_40"], player["attempts_30_40"]]
		$NameScroll/Control/SixStat2.add_child(td_button)
		var comp_button = Button.new()
		comp_button.text = "%d/%d" % [player["makes_41_50"], player["attempts_41_50"]]
		$NameScroll/Control/SixStat3.add_child(comp_button)
		var att_button = Button.new()
		att_button.text = "%d/%d" % [player["makes_51_60"], player["attempts_51_60"]]
		$NameScroll/Control/SixStat4.add_child(att_button)
		var percent_button = Button.new()
		percent_button.text = "%d/%d" % [player["makes_61"], player["attempts_61"]]
		$NameScroll/Control/SixStat5.add_child(percent_button)
		var int_button = Button.new()
		int_button.text = "%d/%d" % [player["xp_makes"], player["xp_attempts"]]
		$NameScroll/Control/SixStat6.add_child(int_button)
		y += 35 
	$NameScroll/Control.custom_minimum_size = Vector2(0, y)

func _on_pass_pressed():
	selected_stat = "Passing"
	update_stats()

func _on_rush_pressed():
	selected_stat = "Rushing"
	update_stats()

func _on_rec_pressed():
	selected_stat = "Receiving"
	update_stats()

func _on_def_pressed():
	selected_stat = "Defense"
	update_stats()

func _on_kick_pressed():
	selected_stat = "Kicking"
	update_stats()


func _on_back_pressed():
	self.queue_free()
