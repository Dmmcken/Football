extends Node2D

var selected_team = GameData.selected_team_name

var trade_team = ""
var player_offer = []
var cpu_offer = []
var player_one_slot = []
var player_two_slot = []
var player_three_slot = []
var player_four_slot = []
var player_five_slot = []
var cpu_one_slot = []
var cpu_two_slot = []
var cpu_three_slot = []
var cpu_four_slot = []
var cpu_five_slot = []
var my_value_total = 0
var cpu_value_total = 0
var current_week = 1

@onready var my_value_total_label = $MyValueTotal
@onready var cpu_value_total_label = $CPUValueTotal

var abq = load("res://Themes/ABQ.tres")
var bal = load("res://Themes/BAL.tres")
var bos = load("res://Themes/BOS.tres")
var cha = load("res://Themes/CHA.tres")
var chi = load("res://Themes/CHI.tres")
var cle = load("res://Themes/CLE.tres")
var col = load("res://Themes/COL.tres")
var dal = load("res://Themes/DAL.tres")
var dc = load("res://Themes/DC.tres")
var det = load("res://Themes/DET.tres")
var ga = load("res://Themes/GA.tres")
var hou = load("res://Themes/HOU.tres")
var ind = load("res://Themes/IND.tres")
var kc = load("res://Themes/KC.tres")
var la = load("res://Themes/LA.tres")
var lou = load("res://Themes/LOU.tres")
var lv = load("res://Themes/LV.tres")
var mem = load("res://Themes/MEM.tres")
var mia = load("res://Themes/MIA.tres")
var mil = load("res://Themes/MIL.tres")
var nas = load("res://Themes/NAS.tres")
var nor = load("res://Themes/NOR.tres")
var ny = load("res://Themes/NY.tres")
var ok = load("res://Themes/OK.tres")
var oma = load("res://Themes/OMA.tres")
var ore = load("res://Themes/OR.tres")
var phi = load("res://Themes/PHI.tres")
var pho = load("res://Themes/PHO.tres")
var sac = load("res://Themes/SAC.tres")
var sd = load("res://Themes/SD.tres")
var sea = load("res://Themes/SEA.tres")
var tam = load("res://Themes/TAM.tres")

func _ready():
	$CPUTeam.connect("item_selected", Callable(self, "_on_TeamFilter_changed"))
	populate_position_dropdown()
	set_player_button_theme()
	set_opponent_button_theme()
	

func populate_position_dropdown():
	var dropdown = $CPUTeam
	var teams = []
	for team_name in Rosters.team_rosters.keys():
		if team_name != selected_team and team_name != "Free Agent":
			teams.append(team_name)
	for team_name in teams:
		dropdown.add_item(team_name)
	dropdown.selected = 0
	trade_team = dropdown.get_item_text(0)

func _on_TeamFilter_changed(selected_index):
	var dropdown = $CPUTeam
	trade_team = dropdown.get_item_text(selected_index)
	clear_cpu_offer()
	update_buttons()
	update_total_values()

func _on_player_1_pressed():
	instantiate_trade_selection()

func instantiate_trade_selection():
	var root = get_tree().root
	var trade_selection_scene = load("res://TradeSelection.tscn")
	var trade_selection_instance = trade_selection_scene.instantiate()
	trade_selection_instance.connect("selection_made", _on_selection_made)
	trade_selection_instance.current_week = current_week
	root.add_child(trade_selection_instance)
	var current_scene = get_tree().current_scene
	current_scene.visible = false

func _on_selection_made(selection):
	if player_offer.size() <= 4:
		for player in selection:
			if player not in player_offer:
				player_offer.append(player)
				if player_one_slot.size() == 0:
					player_one_slot = selection
				elif player_two_slot.size() == 0:
					player_two_slot = selection
				elif player_three_slot.size() == 0:
					player_three_slot = selection
				elif player_four_slot.size() == 0:
					player_four_slot = selection
				elif player_five_slot.size() == 0:
					player_five_slot = selection
				else:
					pass
				for item in selection:
					my_value_total += round(item["Trade Value"])
	else:
		pass
	update_total_values()
	update_buttons()

func _on_cpu_selection_made(selection):
	if cpu_offer.size() <= 4:
		for player in selection:
			if player not in cpu_offer:
				cpu_offer.append(player)
				if cpu_one_slot.size() == 0:
					cpu_one_slot = selection
				elif cpu_two_slot.size() == 0:
					cpu_two_slot = selection
				elif cpu_three_slot.size() == 0:
					cpu_three_slot = selection
				elif cpu_four_slot.size() == 0:
					cpu_four_slot = selection
				elif cpu_five_slot.size() == 0:
					cpu_five_slot = selection
				else:
					pass
				for item in selection:
					cpu_value_total += round(item["Trade Value"])
	else:
		pass
	update_total_values()
	update_buttons()

func update_buttons():
	var player_one = $Player1
	var player_two = $Player2
	var player_three = $Player3
	var player_four = $Player4
	var player_five = $Player5
	var cpu_one = $CPU1
	var cpu_two = $CPU2
	var cpu_three = $CPU3
	var cpu_four = $CPU4
	var cpu_five = $CPU5
	if player_one_slot.size() > 0:
		for player in player_one_slot:
			if "FirstName" in player:
				var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
				player_one.text = button_text
			else:
				var button_text = "Year %d Round %d Pick %d Trade Value %d" % [player["year"], player["round"], player["pick_number"], player["Trade Value"]]
				player_one.text = button_text
	if player_two_slot.size() > 0:
		for player in player_two_slot:
			if "FirstName" in player:
				var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
				player_two.text = button_text
			else:
				var button_text = "Year %d Round %d Pick %d Trade Value %d" % [player["year"], player["round"], player["pick_number"], player["Trade Value"]]
				player_two.text = button_text
	if player_three_slot.size() > 0:
		for player in player_three_slot:
			if "FirstName" in player:
				var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
				player_three.text = button_text
			else:
				var button_text = "Year %d Round %d Pick %d Trade Value %d" % [player["year"], player["round"], player["pick_number"], player["Trade Value"]]
				player_three.text = button_text
	if player_four_slot.size() > 0:
		for player in player_four_slot:
			if "FirstName" in player:
				var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
				player_four.text = button_text
			else:
				var button_text = "Year %d Round %d Pick %d Trade Value %d" % [player["year"], player["round"], player["pick_number"], player["Trade Value"]]
				player_four.text = button_text
	if player_five_slot.size() > 0:
		for player in player_five_slot:
			if "FirstName" in player:
				var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
				player_five.text = button_text
			else:
				var button_text = "Year %d Round %d Pick %d Trade Value %d" % [player["year"], player["round"], player["pick_number"], player["Trade Value"]]
				player_five.text = button_text
	if cpu_one_slot.size() > 0:
		for player in cpu_one_slot:
			if "FirstName" in player:
				var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
				cpu_one.text = button_text
			else:
				var button_text = "Year %d Round %d Pick %d Trade Value %d" % [player["year"], player["round"], player["pick_number"], player["Trade Value"]]
				cpu_one.text = button_text
	if cpu_two_slot.size() > 0:
		for player in cpu_two_slot:
			if "FirstName" in player:
				var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
				cpu_two.text = button_text
			else:
				var button_text = "Year %d Round %d Pick %d Trade Value %d" % [player["year"], player["round"], player["pick_number"], player["Trade Value"]]
				cpu_two.text = button_text
	if cpu_three_slot.size() > 0:
		for player in cpu_three_slot:
			if "FirstName" in player:
				var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
				cpu_three.text = button_text
			else:
				var button_text = "Year %d Round %d Pick %d Trade Value %d" % [player["year"], player["round"], player["pick_number"], player["Trade Value"]]
				cpu_three.text = button_text
	if cpu_four_slot.size() > 0:
		for player in cpu_four_slot:
			if "FirstName" in player:
				var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
				cpu_four.text = button_text
			else:
				var button_text = "Year %d Round %d Pick %d Trade Value %d" % [player["year"], player["round"], player["pick_number"], player["Trade Value"]]
				cpu_four.text = button_text
	if cpu_five_slot.size() > 0:
		for player in cpu_five_slot:
			if "FirstName" in player:
				var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
				cpu_five.text = button_text
			else:
				var button_text = "Year %d Round %d Pick %d Trade Value %d" % [player["year"], player["round"], player["pick_number"], player["Trade Value"]]
				cpu_five.text = button_text
	var theme = abq
	match trade_team:
		"Albuquerque Scorpions":
			theme = abq
		"Baltimore Bombers":
			theme = bal
		"Boston Wildcats":
			theme = bos
		"Charlotte Beasts":
			theme = cha
		"Chicago Warriors":
			theme = chi
		"Columbus Hawks":
			theme = col
		"Cleveland Blue Jays":
			theme = cle
		"Dallas Rebels":
			theme = dal
		"DC Senators":
			theme = dc
		"Detroit Motors":
			theme = det
		"Georgia Peaches":
			theme = ga
		"Houston Bulls":
			theme = hou
		"Indianapolis Cougars":
			theme = ind
		"Kansas City Badgers":
			theme = kc
		"Las Vegas Aces":
			theme = lv
		"Los Angeles Stars":
			theme = la
		"Louisville Stallions":
			theme = lou
		"Memphis Pyramids":
			theme = mem
		"Miami Pirates":
			theme = mia
		"Milwaukee Owls":
			theme = mil
		"Nashville Strings":
			theme = nas
		"New Orleans Voodoo":
			theme = nor
		"New York Spartans":
			theme = ny
		"Oklahoma Tornadoes":
			theme = ok
		"Omaha Ducks":
			theme = oma
		"Oregon Sea Lions":
			theme = ore
		"Philadelphia Suns":
			theme = phi
		"Phoenix Roadrunners":
			theme = pho
		"Sacramento Golds":
			theme = sac
		"San Diego Spartans":
			theme = sd
		"Seattle Vampires":
			theme = sea
		"Tampa Wolverines":
			theme = tam
	$CPU1.theme = theme
	$CPU2.theme = theme
	$CPU3.theme = theme
	$CPU4.theme = theme
	$CPU5.theme = theme

func _on_player_2_pressed():
	instantiate_trade_selection()

func _on_player_3_pressed():
	instantiate_trade_selection()

func _on_player_4_pressed():
	instantiate_trade_selection()

func _on_player_5_pressed():
	instantiate_trade_selection()

func set_opponent_button_theme():
	if selected_team != "New York Spartans":
		$CPU1.theme = ny
		$CPU2.theme = ny
		$CPU3.theme = ny
		$CPU4.theme = ny
		$CPU5.theme = ny
	else:
		$CPU1.theme = cha
		$CPU2.theme = cha
		$CPU3.theme = cha
		$CPU4.theme = cha
		$CPU5.theme = cha

func set_player_button_theme():
	var theme = abq
	match selected_team:
		"Albuquerque Scorpions":
			theme = abq
		"Baltimore Bombers":
			theme = bal
		"Boston Wildcats":
			theme = bos
		"Charlotte Beasts":
			theme = cha
		"Chicago Warriors":
			theme = chi
		"Columbus Hawks":
			theme = col
		"Cleveland Blue Jays":
			theme = cle
		"Dallas Rebels":
			theme = dal
		"DC Senators":
			theme = dc
		"Detroit Motors":
			theme = det
		"Georgia Peaches":
			theme = ga
		"Houston Bulls":
			theme = hou
		"Indianapolis Cougars":
			theme = ind
		"Kansas City Badgers":
			theme = kc
		"Las Vegas Aces":
			theme = lv
		"Los Angeles Stars":
			theme = la
		"Louisville Stallions":
			theme = lou
		"Memphis Pyramids":
			theme = mem
		"Miami Pirates":
			theme = mia
		"Milwaukee Owls":
			theme = mil
		"Nashville Strings":
			theme = nas
		"New Orleans Voodoo":
			theme = nor
		"New York Spartans":
			theme = ny
		"Oklahoma Tornadoes":
			theme = ok
		"Omaha Ducks":
			theme = oma
		"Oregon Sea Lions":
			theme = ore
		"Philadelphia Suns":
			theme = phi
		"Phoenix Roadrunners":
			theme = pho
		"Sacramento Golds":
			theme = sac
		"San Diego Spartans":
			theme = sd
		"Seattle Vampires":
			theme = sea
		"Tampa Wolverines":
			theme = tam
	$Player1.theme = theme
	$Player2.theme = theme
	$Player3.theme = theme
	$Player4.theme = theme
	$Player5.theme = theme

func instantiate_cpu_trade_selection():
	var root = get_tree().root
	var cpu_trade_selection_scene = load("res://CPUTradeSelection.tscn")
	var cpu_trade_selection_instance = cpu_trade_selection_scene.instantiate()
	cpu_trade_selection_instance.connect("cpu_selection_made", _on_cpu_selection_made)
	cpu_trade_selection_instance.selected_team = str(trade_team)
	root.add_child(cpu_trade_selection_instance)
	var current_scene = get_tree().current_scene
	current_scene.visible = false

func instantiate_cpu_trade_selection_old():
	var current_scene = get_tree().current_scene
	var cpu_trade_selection_scene = load("res://CPUTradeSelection.tscn")
	var cpu_trade_selection_instance = cpu_trade_selection_scene.instantiate()
	cpu_trade_selection_instance.connect("cpu_selection_made", _on_cpu_selection_made)
	cpu_trade_selection_instance.selected_team = str(trade_team)
	get_tree().root.add_child(cpu_trade_selection_instance)
	get_tree().current_scene = cpu_trade_selection_instance

func _on_cpu_1_pressed():
	instantiate_cpu_trade_selection()

func _on_cpu_2_pressed():
	instantiate_cpu_trade_selection()

func _on_cpu_3_pressed():
	instantiate_cpu_trade_selection()

func _on_cpu_4_pressed():
	instantiate_cpu_trade_selection()

func _on_cpu_5_pressed():
	instantiate_cpu_trade_selection()

func update_total_values():
	my_value_total_label.text = str(my_value_total)
	cpu_value_total_label.text = str(cpu_value_total)

func clear_cpu_offer():
	cpu_one_slot = []
	cpu_two_slot = []
	cpu_three_slot = []
	cpu_four_slot = []
	cpu_five_slot = []
	cpu_offer = []
	cpu_value_total = 0
	var cpu_one = $CPU1
	var cpu_two = $CPU2
	var cpu_three = $CPU3
	var cpu_four = $CPU4
	var cpu_five = $CPU5
	cpu_one.text = ""
	cpu_two.text = ""
	cpu_three.text = ""
	cpu_four.text = ""
	cpu_five.text = ""

func clear_player_offer():
	player_one_slot = []
	player_two_slot = []
	player_three_slot = []
	player_four_slot = []
	player_five_slot = []
	player_offer = []
	my_value_total = 0
	var player_one = $Player1
	var player_two = $Player2
	var player_three = $Player3
	var player_four = $Player4
	var player_five = $Player5
	player_one.text = ""
	player_two.text = ""
	player_three.text = ""
	player_four.text = ""
	player_five.text = ""

func _on_clear_player_1_pressed():
	for item in player_one_slot:
		if "pick_id" in item:
			var pick_id_to_remove = item["pick_id"]
			for i in range(player_offer.size()):
				if player_offer[i].get("pick_id", null) == pick_id_to_remove:
					player_offer.remove_at(i)
					player_one_slot = []
					my_value_total -= round(item["Trade Value"])
					break
		elif "PlayerID" in item:
			var player_id_to_remove = item["PlayerID"]
			for i in range(player_offer.size()):
				if player_offer[i].get("PlayerID", null) == player_id_to_remove:
					player_offer.remove_at(i)
					player_one_slot = []
					my_value_total -= round(item["Trade Value"])
					break
		else:
			pass
	var player_one = $Player1
	player_one.text = ""
	update_buttons()
	update_total_values()

func _on_clear_player_2_pressed():
	for item in player_two_slot:
		if "pick_id" in item:
			var pick_id_to_remove = item["pick_id"]
			for i in range(player_offer.size()):
				if player_offer[i].get("pick_id", null) == pick_id_to_remove:
					player_offer.remove_at(i)
					player_two_slot = []
					my_value_total -= round(item["Trade Value"])
					break
		elif "PlayerID" in item:
			var player_id_to_remove = item["PlayerID"]
			for i in range(player_offer.size()):
				if player_offer[i].get("PlayerID", null) == player_id_to_remove:
					player_offer.remove_at(i)
					player_two_slot = []
					my_value_total -= round(item["Trade Value"])
					break
		else:
			pass
	var player_two = $Player2
	player_two.text = ""
	update_buttons()
	update_total_values()

func _on_clear_player_3_pressed():
	for item in player_three_slot:
		if "pick_id" in item:
			var pick_id_to_remove = item["pick_id"]
			for i in range(player_offer.size()):
				if player_offer[i].get("pick_id", null) == pick_id_to_remove:
					player_offer.remove_at(i)
					player_three_slot = []
					my_value_total -= round(item["Trade Value"])
					break
		elif "PlayerID" in item:
			var player_id_to_remove = item["PlayerID"]
			for i in range(player_offer.size()):
				if player_offer[i].get("PlayerID", null) == player_id_to_remove:
					player_offer.remove_at(i)
					player_three_slot = []
					my_value_total -= round(item["Trade Value"])
					break
		else:
			pass
	var player_three = $Player3
	player_three.text = ""
	update_buttons()
	update_total_values()

func _on_clear_player_4_pressed():
	for item in player_four_slot:
		if "pick_id" in item:
			var pick_id_to_remove = item["pick_id"]
			for i in range(player_offer.size()):
				if player_offer[i].get("pick_id", null) == pick_id_to_remove:
					player_offer.remove_at(i)
					player_four_slot = []
					my_value_total -= round(item["Trade Value"])
					break
		elif "PlayerID" in item:
			var player_id_to_remove = item["PlayerID"]
			for i in range(player_offer.size()):
				if player_offer[i].get("PlayerID", null) == player_id_to_remove:
					player_offer.remove_at(i)
					player_four_slot = []
					my_value_total -= round(item["Trade Value"])
					break
		else:
			pass
	var player_four = $Player4
	player_four.text = ""
	update_buttons()
	update_total_values()

func _on_clear_player_5_pressed():
	for item in player_five_slot:
		if "pick_id" in item:
			var pick_id_to_remove = item["pick_id"]
			for i in range(player_offer.size()):
				if player_offer[i].get("pick_id", null) == pick_id_to_remove:
					player_offer.remove_at(i)
					player_five_slot = []
					my_value_total -= round(item["Trade Value"])
					break
		elif "PlayerID" in item:
			var player_id_to_remove = item["PlayerID"]
			for i in range(player_offer.size()):
				if player_offer[i].get("PlayerID", null) == player_id_to_remove:
					player_offer.remove_at(i)
					player_five_slot = []
					my_value_total -= round(item["Trade Value"])
					break
		else:
			pass
	var player_five = $Player5
	player_five.text = ""
	update_buttons()
	update_total_values()

func _on_clear_cpu_1_pressed():
	for item in cpu_one_slot:
		if "pick_id" in item:
			var pick_id_to_remove = item["pick_id"]
			for i in range(cpu_offer.size()):
				if cpu_offer[i].get("pick_id", null) == pick_id_to_remove:
					cpu_offer.remove_at(i)
					cpu_one_slot = []
					cpu_value_total -= round(item["Trade Value"])
					break
		elif "PlayerID" in item:
			var player_id_to_remove = item["PlayerID"]
			for i in range(cpu_offer.size()):
				if cpu_offer[i].get("PlayerID", null) == player_id_to_remove:
					cpu_offer.remove_at(i)
					cpu_one_slot = []
					cpu_value_total -= round(item["Trade Value"])
					break
		else:
			pass
	var cpu_one = $CPU1
	cpu_one.text = ""
	update_buttons()
	update_total_values()

func _on_clear_cpu_2_pressed():
	for item in cpu_two_slot:
		if "pick_id" in item:
			var pick_id_to_remove = item["pick_id"]
			for i in range(cpu_offer.size()):
				if cpu_offer[i].get("pick_id", null) == pick_id_to_remove:
					cpu_offer.remove_at(i)
					cpu_two_slot = []
					cpu_value_total -= round(item["Trade Value"])
					break
		elif "PlayerID" in item:
			var player_id_to_remove = item["PlayerID"]
			for i in range(cpu_offer.size()):
				if cpu_offer[i].get("PlayerID", null) == player_id_to_remove:
					cpu_offer.remove_at(i)
					cpu_two_slot = []
					cpu_value_total -= round(item["Trade Value"])
					break
		else:
			pass
	var cpu_two = $CPU2
	cpu_two.text = ""
	update_buttons()
	update_total_values()

func _on_clear_cpu_3_pressed():
	for item in cpu_three_slot:
		if "pick_id" in item:
			var pick_id_to_remove = item["pick_id"]
			for i in range(cpu_offer.size()):
				if cpu_offer[i].get("pick_id", null) == pick_id_to_remove:
					cpu_offer.remove_at(i)
					cpu_three_slot = []
					cpu_value_total -= round(item["Trade Value"])
					break
		elif "PlayerID" in item:
			var player_id_to_remove = item["PlayerID"]
			for i in range(cpu_offer.size()):
				if cpu_offer[i].get("PlayerID", null) == player_id_to_remove:
					cpu_offer.remove_at(i)
					cpu_three_slot = []
					cpu_value_total -= round(item["Trade Value"])
					break
		else:
			pass
	var cpu_three = $CPU3
	cpu_three.text = ""
	update_buttons()
	update_total_values()

func _on_clear_cpu_4_pressed():
	for item in cpu_four_slot:
		if "pick_id" in item:
			var pick_id_to_remove = item["pick_id"]
			for i in range(cpu_offer.size()):
				if cpu_offer[i].get("pick_id", null) == pick_id_to_remove:
					cpu_offer.remove_at(i)
					cpu_four_slot = []
					cpu_value_total -= round(item["Trade Value"])
					break
		elif "PlayerID" in item:
			var player_id_to_remove = item["PlayerID"]
			for i in range(cpu_offer.size()):
				if cpu_offer[i].get("PlayerID", null) == player_id_to_remove:
					cpu_offer.remove_at(i)
					cpu_four_slot = []
					cpu_value_total -= round(item["Trade Value"])
					break
		else:
			pass
	var cpu_four = $CPU4
	cpu_four.text = ""
	update_buttons()
	update_total_values()

func _on_clear_cpu_5_pressed():
	for item in cpu_five_slot:
		if "pick_id" in item:
			var pick_id_to_remove = item["pick_id"]
			for i in range(cpu_offer.size()):
				if cpu_offer[i].get("pick_id", null) == pick_id_to_remove:
					cpu_offer.remove_at(i)
					cpu_five_slot = []
					cpu_value_total -= round(item["Trade Value"])
					break
		elif "PlayerID" in item:
			var player_id_to_remove = item["PlayerID"]
			for i in range(cpu_offer.size()):
				if cpu_offer[i].get("PlayerID", null) == player_id_to_remove:
					cpu_offer.remove_at(i)
					cpu_five_slot = []
					cpu_value_total -= round(item["Trade Value"])
					break
		else:
			pass
	var cpu_five = $CPU5
	cpu_five.text = ""
	update_buttons()
	update_total_values()

func _on_make_trade_pressed():
	if my_value_total >= cpu_value_total:
		var selected_team_roster = Rosters.team_rosters[selected_team]
		var trade_team_roster = Rosters.team_rosters[trade_team]
		var draft_picks = Draft.drafts
		if player_one_slot.size() == 1:
			player_slot_trade(player_one_slot, selected_team_roster, trade_team_roster, draft_picks)
		if player_two_slot.size() == 1:
			player_slot_trade(player_two_slot, selected_team_roster, trade_team_roster, draft_picks)
		if player_three_slot.size() == 1:
			player_slot_trade(player_three_slot, selected_team_roster, trade_team_roster, draft_picks)
		if player_four_slot.size() == 1:
			player_slot_trade(player_four_slot, selected_team_roster, trade_team_roster, draft_picks)
		if player_five_slot.size() == 1:
			player_slot_trade(player_five_slot, selected_team_roster, trade_team_roster, draft_picks)
		if cpu_one_slot.size() == 1:
			cpu_slot_trade(cpu_one_slot, selected_team_roster, trade_team_roster, draft_picks)
		if cpu_two_slot.size() == 1:
			cpu_slot_trade(cpu_two_slot, selected_team_roster, trade_team_roster, draft_picks)
		if cpu_three_slot.size() == 1:
			cpu_slot_trade(cpu_three_slot, selected_team_roster, trade_team_roster, draft_picks)
		if cpu_four_slot.size() == 1:
			cpu_slot_trade(cpu_four_slot, selected_team_roster, trade_team_roster, draft_picks)
		if cpu_five_slot.size() == 1:
			cpu_slot_trade(cpu_five_slot, selected_team_roster, trade_team_roster, draft_picks)
		clear_cpu_offer()
		clear_player_offer()
		update_buttons()
		update_total_values()
	else:
		pass

func player_slot_trade(slot, selected_team_roster, trade_team_roster, draft_picks):
	for item in slot:
			if "PlayerID" in item:
				for player in selected_team_roster:
					if player["PlayerID"] == item["PlayerID"]:
						trade_team_roster.append(player)
						selected_team_roster.erase(player)
			elif "pick_id" in item:
				for year in draft_picks:
					for pick in draft_picks[year]:
						if item["pick_id"] == draft_picks[year][pick]["pick_id"]:
							Draft.drafts[year][pick]["current_team"] = trade_team

func cpu_slot_trade(slot, selected_team_roster, trade_team_roster, draft_picks):
	for item in slot:
		if "PlayerID" in item:
			for player in trade_team_roster:
				if player["PlayerID"] == item["PlayerID"]:
					selected_team_roster.append(player)
					trade_team_roster.erase(player)
		elif "pick_id" in item:
			for year in draft_picks:
				for pick in draft_picks[year]:
					if item["pick_id"] == draft_picks[year][pick]["pick_id"]:
						Draft.drafts[year][pick]["current_team"] = selected_team


signal trade_made

func _on_back_pressed():
	emit_signal("trade_made")
	self.queue_free()
