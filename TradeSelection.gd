extends Node2D

var selected_team = GameData.selected_team_name
var team_roster = Rosters.team_rosters[selected_team]
var selected_player = ""
var roster_array = []
var draft_array = []
var draft_picks = Draft.drafts
var selected_pick = ""
var current_week = 1

signal selection_made(selection)

func _ready():
	roster_array = convert_roster_to_array()
	draft_array = convert_draft_to_array()
	get_trade_values()
	get_pick_values()
	populate_test("TradeScroll/TradeBox")


func populate_test(container_path):
	var container = get_node(container_path)
	for child in container.get_children():
		child.queue_free()
	populate_qb_list(container)
	populate_rb_list(container)
	populate_wr_list(container)
	populate_te_list(container)
	populate_lt_list(container)
	populate_lg_list(container)
	populate_c_list(container)
	populate_rg_list(container)
	populate_rt_list(container)
	populate_le_list(container)
	populate_re_list(container)
	populate_dt_list(container)
	populate_olb_list(container)
	populate_mlb_list(container)
	populate_cb_list(container)
	populate_ss_list(container)
	populate_fs_list(container)
	populate_k_list(container)
	populate_p_list(container)
	populate_r_list(container)
	populate_draft_list(container)
	

func populate_qb_list(container):
	var position_label = Label.new()
	position_label.text = "QB's"
	container.add_child(position_label)
	var qb_array = []
	for player in roster_array:
		if player["Position"] == "QB":
			qb_array.append(player)
	qb_array.sort_custom(func(a, b):
		return a["DepthChart"] < b["DepthChart"])
	for player in qb_array:
		if player["Position"] == "QB":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			container.add_child(player_button)

func populate_rb_list(container):
	var position_label = Label.new()
	position_label.text = "RB's"
	container.add_child(position_label)
	var rb_array = []
	for player in roster_array:
		if player["Position"] == "RB":
			rb_array.append(player)
	rb_array.sort_custom(func(a, b):
		return a["DepthChart"] < b["DepthChart"])
	for player in rb_array:
		if player["Position"] == "RB":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			container.add_child(player_button)

func populate_wr_list(container):
	var position_label = Label.new()
	position_label.text = "WR's"
	container.add_child(position_label)
	var wr_array = []
	for player in roster_array:
		if player["Position"] == "WR":
			wr_array.append(player)
	wr_array.sort_custom(func(a, b):
		return a["DepthChart"] < b["DepthChart"])
	for player in wr_array:
		if player["Position"] == "WR":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			container.add_child(player_button)

func populate_te_list(container):
	var position_label = Label.new()
	position_label.text = "TE's"
	container.add_child(position_label)
	var te_array = []
	for player in roster_array:
		if player["Position"] == "TE":
			te_array.append(player)
	te_array.sort_custom(func(a, b):
		return a["DepthChart"] < b["DepthChart"])
	for player in te_array:
		if player["Position"] == "TE":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			container.add_child(player_button)

func populate_lt_list(container):
	var position_label = Label.new()
	position_label.text = "LT's"
	container.add_child(position_label)
	var lt_array = []
	for player in roster_array:
		if player["Position"] == "LT":
			lt_array.append(player)
	lt_array.sort_custom(func(a, b):
		return a["DepthChart"] < b["DepthChart"])
	for player in lt_array:
		if player["Position"] == "LT":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			container.add_child(player_button)

func populate_lg_list(container):
	var position_label = Label.new()
	position_label.text = "LG's"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "LG":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		return a["DepthChart"] < b["DepthChart"])
	for player in player_array:
		if player["Position"] == "LG":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			container.add_child(player_button)

func populate_c_list(container):
	var position_label = Label.new()
	position_label.text = "C's"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "C":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		return a["DepthChart"] < b["DepthChart"])
	for player in player_array:
		if player["Position"] == "C":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			container.add_child(player_button)

func populate_rg_list(container):
	var position_label = Label.new()
	position_label.text = "RG's"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "RG":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		return a["DepthChart"] < b["DepthChart"])
	for player in player_array:
		if player["Position"] == "RG":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			container.add_child(player_button)

func populate_rt_list(container):
	var position_label = Label.new()
	position_label.text = "RT's"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "RT":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		return a["DepthChart"] < b["DepthChart"])
	for player in player_array:
		if player["Position"] == "RT":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			container.add_child(player_button)

func populate_le_list(container):
	var position_label = Label.new()
	position_label.text = "LE's"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "LE":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		return a["DepthChart"] < b["DepthChart"])
	for player in player_array:
		if player["Position"] == "LE":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			container.add_child(player_button)

func populate_re_list(container):
	var position_label = Label.new()
	position_label.text = "RE's"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "RE":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		return a["DepthChart"] < b["DepthChart"])
	for player in player_array:
		if player["Position"] == "RE":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			container.add_child(player_button)

func populate_dt_list(container):
	var position_label = Label.new()
	position_label.text = "DT's"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "DT":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		return a["DepthChart"] < b["DepthChart"])
	for player in player_array:
		if player["Position"] == "DT":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			container.add_child(player_button)

func populate_olb_list(container):
	var position_label = Label.new()
	position_label.text = "OLB's"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "OLB":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		return a["DepthChart"] < b["DepthChart"])
	for player in player_array:
		if player["Position"] == "OLB":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			container.add_child(player_button)

func populate_mlb_list(container):
	var position_label = Label.new()
	position_label.text = "MLB's"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "MLB":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		return a["DepthChart"] < b["DepthChart"])
	for player in player_array:
		if player["Position"] == "MLB":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			container.add_child(player_button)

func populate_cb_list(container):
	var position_label = Label.new()
	position_label.text = "CB's"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "CB":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		return a["DepthChart"] < b["DepthChart"])
	for player in player_array:
		if player["Position"] == "CB":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			container.add_child(player_button)

func populate_ss_list(container):
	var position_label = Label.new()
	position_label.text = "SS's"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "SS":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		return a["DepthChart"] < b["DepthChart"])
	for player in player_array:
		if player["Position"] == "SS":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			container.add_child(player_button)

func populate_fs_list(container):
	var position_label = Label.new()
	position_label.text = "FS's"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "FS":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		return a["DepthChart"] < b["DepthChart"])
	for player in player_array:
		if player["Position"] == "FS":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			container.add_child(player_button)

func populate_k_list(container):
	var position_label = Label.new()
	position_label.text = "K's"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "K":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		return a["DepthChart"] < b["DepthChart"])
	for player in player_array:
		if player["Position"] == "K":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			container.add_child(player_button)

func populate_p_list(container):
	var position_label = Label.new()
	position_label.text = "P's"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "P":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		return a["DepthChart"] < b["DepthChart"])
	for player in player_array:
		if player["Position"] == "P":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			container.add_child(player_button)

func populate_r_list(container):
	var position_label = Label.new()
	position_label.text = "R's"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "R":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		return a["DepthChart"] < b["DepthChart"])
	for player in player_array:
		if player["Position"] == "R":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Trade Value %d" % [player["FirstName"], player["LastName"], round(player["Rating"]), player["Age"], player["Potential"], player["Salary"], player["Trade Value"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			container.add_child(player_button)

func populate_draft_list(container):
	var position_label = Label.new()
	position_label.text = "Picks"
	container.add_child(position_label)
	var team_picks_array = []
	for pick in draft_array:
		if pick["current_team"] == selected_team:
			team_picks_array.append(pick)
	for pick in team_picks_array:
		var button_text = "Year %d Round %d Pick %d Trade Value %d" % [pick["year"], pick["round"], pick["pick_number"], pick["Trade Value"]]
		var pick_button = Button.new()
		pick_button.text = button_text
		pick_button.name = pick["pick_id"]
		pick_button.pressed.connect(self._on_PickButton_pressed.bind(pick_button.name))
		container.add_child(pick_button)


func _on_PlayerButton_pressed(player_id):
	selected_pick = ""
	selected_player = player_id

func _on_PickButton_pressed(pick_id):
	selected_player = ""
	selected_pick = pick_id

func convert_roster_to_array():
	var roster_array = []
	for player_data in team_roster:
		roster_array.append(player_data)
	return roster_array

func convert_draft_to_array():
	var draft_array = []
	for year in Draft.drafts.keys():
		for pick_number in Draft.drafts[year].keys():
			var pick = Draft.drafts[year][pick_number].duplicate()
			pick["year"] = year
			pick["pick_number"] = pick_number
			draft_array.append(pick)
	return draft_array

func compare_by_depth(player1, player2):
	if player1["DepthChart"] <= player2["DepthChart"]:
		return true
	else:
		return false


func sort_rating(position_group):
	position_group.sort_custom(compare_by_rating)

func compare_by_rating(player1, player2):
	if player1["Rating"] >= player2["Rating"]:
		return true
	else:
		false

func _on_select_pressed():
	var selection = []
	if selected_player != "":
		for i in range(len(roster_array)):
			if roster_array[i]["PlayerID"] == selected_player:
				selection.append(roster_array[i])
	elif selected_pick != "":
		for i in range(len(draft_array)):
			if draft_array[i]["pick_id"] == selected_pick:
				selection.append(draft_array[i])
	else:
		pass
	emit_signal("selection_made", selection)
	Rosters.team_rosters[selected_team] = roster_array
	var master_trade_scene = get_tree().current_scene
	master_trade_scene.visible = true
	self.queue_free()

func get_trade_values():
	var youth = ["RB", "R", "WR"]
	var normal = ["TE", "LT", "LG", "C", "RG", "RT", "LE", "RE", "DT", "OLB", "MLB", "CB", "SS", "FS"]
	var old = ["QB", "P", "K"]
	for player in roster_array:
		var value = 35000
		var pos_mult = 1
		var rating_mult = get_rating_mult(player["Rating"])
		var age_mult = 1
		var pot_mult = 1
		match player["Position"]:
			"QB":
				pos_mult = 1
			"RB":
				pos_mult = .5
			"WR":
				pos_mult = .5
			"LG":
				pos_mult = .3
			"LT":
				pos_mult = .3
			"C":
				pos_mult = .3
			"RG":
				pos_mult = .3
			"RT":
				pos_mult = .3
			"TE":
				pos_mult = .4
			"LE":
				pos_mult = .4
			"RE":
				pos_mult = .4
			"DT":
				pos_mult = .3
			"OLB":
				pos_mult = .3
			"MLB":
				pos_mult = .35
			"CB":
				pos_mult = .35
			"SS":
				pos_mult = .35
			"FS":
				pos_mult = .35
			"K":
				pos_mult = .1
			"P":
				pos_mult = .08
			"R":
				pos_mult = .08
		match player["Potential"]:
			5:
				pot_mult = 1
			4:
				pot_mult = .75
			3:
				pot_mult = .6
			2:
				pot_mult = .45
			1:
				pot_mult = .25
		var age_min = 20
		var age_max = 35
		if player["Position"] in old:
			age_max = 38
		elif player["Position"] in youth:
			age_max = 32
		else:
			age_max = 35
		
		if player["Age"] <= age_min:
			age_mult = 1
		elif player["Age"] >= age_max:
			age_mult = 0
		else:
			age_mult = (1.0 - (float(player["Age"] - age_min) * float(1 / float(age_max - age_min))))
		var trade_value = value * age_mult * pos_mult * pot_mult * rating_mult
		player["Trade Value"] = trade_value

func get_rating_mult(rating):
	if rating >= 99:
		return 1
	elif rating <= 70:
		return 0
	else:
		var fraction = float(rating - 70) / (99-70)
		return fraction

func get_pick_values():
	var value = 0
	var week_mult = 1
	for pick in draft_array:
		var max_value = 1933
		var min_value = 50
		var min_pick = 33
		var max_pick = 224
		var drop = 9.911
		var year_mult = 1
		if pick["pick_number"] <= 32:
			match pick["pick_number"]:
				1:
					value = 10000
				2:
					value = 9000
				3:
					value = 8250
				4:
					value = 7100
				5:
					value = 6300
				6:
					value = 5750
				7:
					value = 5300
				8: 
					value = 5000
				9:
					value = 4700
				10:
					value = 4500
				11:
					value = 4300
				12:
					value = 4150
				13:
					value = 4000
				14:
					value = 3800
				15:
					value = 3650
				16:
					value = 3400
				17:
					value = 3200
				18:
					value = 3000
				19:
					value = 2916
				20:
					value = 2833
				21:
					value = 2666
				22:
					value = 2600
				23:
					value = 2533
				24:
					value = 2466
				25:
					value = 2400
				26:
					value = 2333
				27:
					value = 2266
				28:
					value = 2200
				29:
					value = 2133
				30:
					value = 2067
				31:
					value = 2000
				32:
					value = 1966
		elif pick["pick_number"] <= 224:
			value = max_value - ((pick["pick_number"] - min_pick) * drop)
		var lowest_year = get_lowest_year()
		if pick["year"] == lowest_year:
			year_mult = 1
		elif pick["year"] == lowest_year + 1:
			year_mult = .85
		elif pick["year"] == lowest_year + 2:
			year_mult = .7
		if current_week <= 8:
			week_mult = .85
		else:
			week_mult = 1
		pick["Trade Value"] = value * year_mult * week_mult

func get_lowest_year():
	var years = []
	for pick in draft_array:
		years.append(pick["year"])
	years.sort()
	return years[0]


func _on_back_pressed():
	var master_trade_scene = get_tree().current_scene
	master_trade_scene.visible = true
	self.queue_free()
