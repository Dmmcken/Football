extends Node2D

var selected_team = GameData.selected_team_name
var fa_roster = Rosters.team_rosters["Free Agent"]
var team_roster = Rosters.team_rosters[selected_team]
var fa_array = []
var selected_player = ""
var roster_array = []

func _ready():
	roster_array = convert_roster_to_array()
	fa_array = convert_fa_to_array()
	populate_test("DepthChart/QBDepth")

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

func get_boosted_rating(player):
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
	var rating = player["Rating"]
	if player["Position"] in coach_boosts:
		if player["Side"] == "Offense":
			rating += offensive_coach_boost
			return rating
		if player["Side"] == "Defense":
			rating += defensive_coach_boost
			return rating
	else:
		return rating

func populate_qb_list(container):
	var position_label = Label.new()
	position_label.text = "QB's (1 Starter / 2 Min)"
	container.add_child(position_label)
	var qb_array = []
	for player in roster_array:
		if player["Position"] == "QB":
			qb_array.append(player)
	qb_array.sort_custom(func(a, b):
		if a["Injury"] == b["Injury"]:
			return a["DepthChart"] < b["DepthChart"]
		return a["Injury"] < b["Injury"])
	
	for player in qb_array:
		if player["Position"] == "QB":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Years %d/%d" % [player["FirstName"], player["LastName"], round(get_boosted_rating(player)), player["Age"], player["Potential"], player["Salary"], player["Remaining Contract"], player["Guaranteed Years"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			if player["Injury"] == 1:
				player_button.modulate = Color(1, 0, 0)
			container.add_child(player_button)

func populate_rb_list(container):
	var position_label = Label.new()
	position_label.text = "RB's (1 Starter / 3 Min)"
	container.add_child(position_label)
	var rb_array = []
	for player in roster_array:
		if player["Position"] == "RB":
			rb_array.append(player)
	rb_array.sort_custom(func(a, b):
		if a["Injury"] == b["Injury"]:
			return a["DepthChart"] < b["DepthChart"]
		return a["Injury"] < b["Injury"])
	for player in rb_array:
		if player["Position"] == "RB":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Years %d/%d" % [player["FirstName"], player["LastName"], round(get_boosted_rating(player)), player["Age"], player["Potential"], player["Salary"], player["Remaining Contract"], player["Guaranteed Years"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			if player["Injury"] == 1:
				player_button.modulate = Color(1, 0, 0)
			container.add_child(player_button)

func populate_wr_list(container):
	var position_label = Label.new()
	position_label.text = "WR's (3 Starters / 4 Min)"
	container.add_child(position_label)
	var wr_array = []
	for player in roster_array:
		if player["Position"] == "WR":
			wr_array.append(player)
	wr_array.sort_custom(func(a, b):
		if a["Injury"] == b["Injury"]:
			return a["DepthChart"] < b["DepthChart"]
		return a["Injury"] < b["Injury"])
	for player in wr_array:
		if player["Position"] == "WR":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Years %d/%d" % [player["FirstName"], player["LastName"], round(get_boosted_rating(player)), player["Age"], player["Potential"], player["Salary"], player["Remaining Contract"], player["Guaranteed Years"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			if player["Injury"] == 1:
				player_button.modulate = Color(1, 0, 0)
			container.add_child(player_button)

func populate_te_list(container):
	var position_label = Label.new()
	position_label.text = "TE's (1 Starter / 2 Min)"
	container.add_child(position_label)
	var te_array = []
	for player in roster_array:
		if player["Position"] == "TE":
			te_array.append(player)
	te_array.sort_custom(func(a, b):
		if a["Injury"] == b["Injury"]:
			return a["DepthChart"] < b["DepthChart"]
		return a["Injury"] < b["Injury"])
	for player in te_array:
		if player["Position"] == "TE":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Years %d/%d" % [player["FirstName"], player["LastName"], round(get_boosted_rating(player)), player["Age"], player["Potential"], player["Salary"], player["Remaining Contract"], player["Guaranteed Years"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			if player["Injury"] == 1:
				player_button.modulate = Color(1, 0, 0)
			container.add_child(player_button)

func populate_lt_list(container):
	var position_label = Label.new()
	position_label.text = "LT's (1 Starter / 2 Min)"
	container.add_child(position_label)
	var lt_array = []
	for player in roster_array:
		if player["Position"] == "LT":
			lt_array.append(player)
	lt_array.sort_custom(func(a, b):
		if a["Injury"] == b["Injury"]:
			return a["DepthChart"] < b["DepthChart"]
		return a["Injury"] < b["Injury"])
	for player in lt_array:
		if player["Position"] == "LT":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Years %d/%d" % [player["FirstName"], player["LastName"], round(get_boosted_rating(player)), player["Age"], player["Potential"], player["Salary"], player["Remaining Contract"], player["Guaranteed Years"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			if player["Injury"] == 1:
				player_button.modulate = Color(1, 0, 0)
			container.add_child(player_button)

func populate_lg_list(container):
	var position_label = Label.new()
	position_label.text = "LG's (1 Starter / 2 Min)"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "LG":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		if a["Injury"] == b["Injury"]:
			return a["DepthChart"] < b["DepthChart"]
		return a["Injury"] < b["Injury"])
	for player in player_array:
		if player["Position"] == "LG":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Years %d/%d" % [player["FirstName"], player["LastName"], round(get_boosted_rating(player)), player["Age"], player["Potential"], player["Salary"], player["Remaining Contract"], player["Guaranteed Years"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			if player["Injury"] == 1:
				player_button.modulate = Color(1, 0, 0)
			container.add_child(player_button)

func populate_c_list(container):
	var position_label = Label.new()
	position_label.text = "C's (1 Starter / 1 Min)"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "C":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		if a["Injury"] == b["Injury"]:
			return a["DepthChart"] < b["DepthChart"]
		return a["Injury"] < b["Injury"])
	for player in player_array:
		if player["Position"] == "C":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Years %d/%d" % [player["FirstName"], player["LastName"], round(get_boosted_rating(player)), player["Age"], player["Potential"], player["Salary"], player["Remaining Contract"], player["Guaranteed Years"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			if player["Injury"] == 1:
				player_button.modulate = Color(1, 0, 0)
			container.add_child(player_button)

func populate_rg_list(container):
	var position_label = Label.new()
	position_label.text = "RG's (1 Starter / 2 Min)"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "RG":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		if a["Injury"] == b["Injury"]:
			return a["DepthChart"] < b["DepthChart"]
		return a["Injury"] < b["Injury"])
	for player in player_array:
		if player["Position"] == "RG":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Years %d/%d" % [player["FirstName"], player["LastName"], round(get_boosted_rating(player)), player["Age"], player["Potential"], player["Salary"], player["Remaining Contract"], player["Guaranteed Years"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			if player["Injury"] == 1:
				player_button.modulate = Color(1, 0, 0)
			container.add_child(player_button)

func populate_rt_list(container):
	var position_label = Label.new()
	position_label.text = "RT's (1 Starter / 2 Min)"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "RT":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		if a["Injury"] == b["Injury"]:
			return a["DepthChart"] < b["DepthChart"]
		return a["Injury"] < b["Injury"])
	for player in player_array:
		if player["Position"] == "RT":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Years %d/%d" % [player["FirstName"], player["LastName"], round(get_boosted_rating(player)), player["Age"], player["Potential"], player["Salary"], player["Remaining Contract"], player["Guaranteed Years"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			if player["Injury"] == 1:
				player_button.modulate = Color(1, 0, 0)
			container.add_child(player_button)

func populate_le_list(container):
	var position_label = Label.new()
	position_label.text = "LE's (1 Starter / 2 Min)"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "LE":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		if a["Injury"] == b["Injury"]:
			return a["DepthChart"] < b["DepthChart"]
		return a["Injury"] < b["Injury"])
	for player in player_array:
		if player["Position"] == "LE":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Years %d/%d" % [player["FirstName"], player["LastName"], round(get_boosted_rating(player)), player["Age"], player["Potential"], player["Salary"], player["Remaining Contract"], player["Guaranteed Years"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			if player["Injury"] == 1:
				player_button.modulate = Color(1, 0, 0)
			container.add_child(player_button)

func populate_re_list(container):
	var position_label = Label.new()
	position_label.text = "RE's (1 Starter / 2 Min)"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "RE":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		if a["Injury"] == b["Injury"]:
			return a["DepthChart"] < b["DepthChart"]
		return a["Injury"] < b["Injury"])
	for player in player_array:
		if player["Position"] == "RE":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Years %d/%d" % [player["FirstName"], player["LastName"], round(get_boosted_rating(player)), player["Age"], player["Potential"], player["Salary"], player["Remaining Contract"], player["Guaranteed Years"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			if player["Injury"] == 1:
				player_button.modulate = Color(1, 0, 0)
			container.add_child(player_button)

func populate_dt_list(container):
	var position_label = Label.new()
	position_label.text = "DT's (2 Starters / 3 Min)"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "DT":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		if a["Injury"] == b["Injury"]:
			return a["DepthChart"] < b["DepthChart"]
		return a["Injury"] < b["Injury"])
	for player in player_array:
		if player["Position"] == "DT":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Years %d/%d" % [player["FirstName"], player["LastName"], round(get_boosted_rating(player)), player["Age"], player["Potential"], player["Salary"], player["Remaining Contract"], player["Guaranteed Years"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			if player["Injury"] == 1:
				player_button.modulate = Color(1, 0, 0)
			container.add_child(player_button)

func populate_olb_list(container):
	var position_label = Label.new()
	position_label.text = "OLB's (1 Starter / 2 Min)"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "OLB":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		if a["Injury"] == b["Injury"]:
			return a["DepthChart"] < b["DepthChart"]
		return a["Injury"] < b["Injury"])
	for player in player_array:
		if player["Position"] == "OLB":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Years %d/%d" % [player["FirstName"], player["LastName"], round(get_boosted_rating(player)), player["Age"], player["Potential"], player["Salary"], player["Remaining Contract"], player["Guaranteed Years"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			if player["Injury"] == 1:
				player_button.modulate = Color(1, 0, 0)
			container.add_child(player_button)

func populate_mlb_list(container):
	var position_label = Label.new()
	position_label.text = "MLB's (1 Starter / 2 Min)"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "MLB":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		if a["Injury"] == b["Injury"]:
			return a["DepthChart"] < b["DepthChart"]
		return a["Injury"] < b["Injury"])
	for player in player_array:
		if player["Position"] == "MLB":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Years %d/%d" % [player["FirstName"], player["LastName"], round(get_boosted_rating(player)), player["Age"], player["Potential"], player["Salary"], player["Remaining Contract"], player["Guaranteed Years"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			if player["Injury"] == 1:
				player_button.modulate = Color(1, 0, 0)
			container.add_child(player_button)

func populate_cb_list(container):
	var position_label = Label.new()
	position_label.text = "CB's (3 Starters / 4 Min)"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "CB":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		if a["Injury"] == b["Injury"]:
			return a["DepthChart"] < b["DepthChart"]
		return a["Injury"] < b["Injury"])
	for player in player_array:
		if player["Position"] == "CB":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Years %d/%d" % [player["FirstName"], player["LastName"], round(get_boosted_rating(player)), player["Age"], player["Potential"], player["Salary"], player["Remaining Contract"], player["Guaranteed Years"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			if player["Injury"] == 1:
				player_button.modulate = Color(1, 0, 0)
			container.add_child(player_button)

func populate_ss_list(container):
	var position_label = Label.new()
	position_label.text = "SS's (1 Starter / 2 Min)"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "SS":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		if a["Injury"] == b["Injury"]:
			return a["DepthChart"] < b["DepthChart"]
		return a["Injury"] < b["Injury"])
	for player in player_array:
		if player["Position"] == "SS":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Years %d/%d" % [player["FirstName"], player["LastName"], round(get_boosted_rating(player)), player["Age"], player["Potential"], player["Salary"], player["Remaining Contract"], player["Guaranteed Years"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			if player["Injury"] == 1:
				player_button.modulate = Color(1, 0, 0)
			container.add_child(player_button)

func populate_fs_list(container):
	var position_label = Label.new()
	position_label.text = "FS's (1 Starter / 2 Min)"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "FS":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		if a["Injury"] == b["Injury"]:
			return a["DepthChart"] < b["DepthChart"]
		return a["Injury"] < b["Injury"])
	for player in player_array:
		if player["Position"] == "FS":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Years %d/%d" % [player["FirstName"], player["LastName"], round(get_boosted_rating(player)), player["Age"], player["Potential"], player["Salary"], player["Remaining Contract"], player["Guaranteed Years"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			if player["Injury"] == 1:
				player_button.modulate = Color(1, 0, 0)
			container.add_child(player_button)

func populate_k_list(container):
	var position_label = Label.new()
	position_label.text = "K's (1 Starter / 1 Min)"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "K":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		if a["Injury"] == b["Injury"]:
			return a["DepthChart"] < b["DepthChart"]
		return a["Injury"] < b["Injury"])
	for player in player_array:
		if player["Position"] == "K":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Years %d/%d" % [player["FirstName"], player["LastName"], round(get_boosted_rating(player)), player["Age"], player["Potential"], player["Salary"], player["Remaining Contract"], player["Guaranteed Years"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			if player["Injury"] == 1:
				player_button.modulate = Color(1, 0, 0)
			container.add_child(player_button)

func populate_p_list(container):
	var position_label = Label.new()
	position_label.text = "P's (1 Starter / 1 Min)"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "P":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		if a["Injury"] == b["Injury"]:
			return a["DepthChart"] < b["DepthChart"]
		return a["Injury"] < b["Injury"])
	for player in player_array:
		if player["Position"] == "P":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Years %d/%d" % [player["FirstName"], player["LastName"], round(get_boosted_rating(player)), player["Age"], player["Potential"], player["Salary"], player["Remaining Contract"], player["Guaranteed Years"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			if player["Injury"] == 1:
				player_button.modulate = Color(1, 0, 0)
			container.add_child(player_button)

func populate_r_list(container):
	var position_label = Label.new()
	position_label.text = "R's (1 Starter / 1 Min)"
	container.add_child(position_label)
	var player_array = []
	for player in roster_array:
		if player["Position"] == "R":
			player_array.append(player)
	player_array.sort_custom(func(a, b):
		if a["Injury"] == b["Injury"]:
			return a["DepthChart"] < b["DepthChart"]
		return a["Injury"] < b["Injury"])
	for player in player_array:
		if player["Position"] == "R":
			var button_text = "%s %s OVR %d Age %d Potential %d Salary %.2f M Years %d/%d" % [player["FirstName"], player["LastName"], round(get_boosted_rating(player)), player["Age"], player["Potential"], player["Salary"], player["Remaining Contract"], player["Guaranteed Years"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			if player["Injury"] == 1:
				player_button.modulate = Color(1, 0, 0)
			container.add_child(player_button)

func _on_PlayerButton_pressed(player_id):
	selected_player = player_id

func convert_fa_to_array():
	var fa_array = []
	for player_data in fa_roster:
		fa_array.append(player_data)
	return fa_array

func convert_roster_to_array():
	var roster_array = []
	for player_data in team_roster:
		roster_array.append(player_data)
	return roster_array

func compare_by_depth(player1, player2):
	if player1["DepthChart"] <= player2["DepthChart"]:
		return true
	else:
		return false

func sort_position(position_group):
	position_group.sort_custom(compare_by_depth)
	
func sort_rating(position_group):
	position_group.sort_custom(compare_by_rating)
	
func compare_by_rating(player1, player2):
	if player1["Rating"] >= player2["Rating"]:
		return true
	else:
		false

func _on_up_pressed():
	if selected_player == "":
		return
	
	var currentPlayerIndex = -1
	for i in range(len(roster_array)):
		if roster_array[i]["PlayerID"] == selected_player:
			currentPlayerIndex = i
			break
	
	var currentPlayer = roster_array[currentPlayerIndex]
	var currentPlayerDepth = roster_array[currentPlayerIndex]["DepthChart"]
	var currentPlayerPosition = currentPlayer["Position"]
	
	if currentPlayerDepth == 1:
		return
	var playerAboveIndex = -1
	var playerAboveDepth = currentPlayerDepth - 1
	
	for i in range(len(roster_array)):
		if roster_array[i]["DepthChart"] == playerAboveDepth and roster_array[i]["Position"] == currentPlayerPosition:
			playerAboveIndex = i
			break
	
	if playerAboveIndex != -1:
		roster_array[currentPlayerIndex]["DepthChart"] = playerAboveDepth
		roster_array[playerAboveIndex]["DepthChart"] = currentPlayerDepth
	populate_test("DepthChart/QBDepth")

func _on_down_pressed():
	if selected_player == "":
		return
	var currentPlayerIndex = -1
	for i in range(len(roster_array)):
		if roster_array[i]["PlayerID"] == selected_player:
			currentPlayerIndex = i
			break
	
	var currentPlayer = roster_array[currentPlayerIndex]
	var currentPlayerDepth = currentPlayer["DepthChart"]
	var currentPlayerPosition = currentPlayer["Position"]
	
	var playerBelowIndex = -1
	var playerBelowDepth = currentPlayerDepth + 1
	
	for i in range(len(roster_array)):
		if roster_array[i]["DepthChart"] == playerBelowDepth and roster_array[i]["Position"] == currentPlayerPosition:
			playerBelowIndex = i
			break
	if playerBelowIndex != -1:
		roster_array[currentPlayerIndex]["DepthChart"] = playerBelowDepth
		roster_array[playerBelowIndex]["DepthChart"] = currentPlayerDepth
		
	populate_test("DepthChart/QBDepth")

func _on_back_pressed():
	Rosters.team_rosters[selected_team] = roster_array
	Rosters.team_rosters["Free Agent"] = fa_array
	self.queue_free()

func _on_auto_reorder_pressed():
	var positions = ["QB", "RB", "WR", "TE", "LT", "LG", "C", "RG", "RT", "LE", "RE", "DT", "OLB", "MLB", "CB", "SS", "FS", "K", "P", "R"]
	for position in positions:
		auto_reorder_position(position)
	populate_test("DepthChart/QBDepth")

func auto_reorder_position(position):
	var position_array = []
	for player in roster_array:
		if player["Position"] == position:
			position_array.append(player)
	sort_rating(position_array)
	for i in range(len(position_array)):
		position_array[i]["DepthChart"] = i + 1

func _on_release_pressed():
	if selected_player == "":
		return
	var player2 = {}
	for player in roster_array:
		if player["PlayerID"] == selected_player:
			player2 = player
			break
	add_dead_cap(player2)
	fa_array.append(player2)
	roster_array.erase(player2)
	selected_player = ""
	populate_test("DepthChart/QBDepth")

func add_dead_cap(player):
	var current_season = 0
	Rosters.dead_cap.sort_custom(func(a, b):
		return a["Year"] < b["Year"])
	current_season = Rosters.dead_cap[0]["Year"]
	if player["Guaranteed Years"] == 1:
		var current_season_dead_cap = player["Salary"] * .5
		for cap in Rosters.dead_cap:
			if cap["Year"] == current_season:
				cap["Dead Cap"] += current_season_dead_cap
	elif player["Guaranteed Years"] == 2:
		var current_season_dead_cap = player["Salary"] * .75
		var next_season_dead_cap = player["Salary"] * .5
		for cap in Rosters.dead_cap:
			if cap["Year"] == current_season:
				cap["Dead Cap"] += current_season_dead_cap
		for cap in Rosters.dead_cap:
			if cap["Year"] == current_season + 1:
				cap["Dead Cap"] += next_season_dead_cap
	elif player["Guaranteed Years"] == 3:
		var current_season_dead_cap = player["Salary"]
		var next_season_dead_cap = player["Salary"] * .75
		var three_season_dead_cap = player["Salary"] * .5
		for cap in Rosters.dead_cap:
			if cap["Year"] == current_season:
				cap["Dead Cap"] += current_season_dead_cap
		for cap in Rosters.dead_cap:
			if cap["Year"] == current_season + 1:
				cap["Dead Cap"] += next_season_dead_cap
		for cap in Rosters.dead_cap:
			if cap["Year"] == current_season + 2:
				cap["Dead Cap"] += three_season_dead_cap
	elif player["Guaranteed Years"] == 4:
		var current_season_dead_cap = player["Salary"] * 1.25
		var next_season_dead_cap = player["Salary"]
		var three_season_dead_cap = player["Salary"] * .75
		var four_season_dead_cap = player["Salary"] * .5
		for cap in Rosters.dead_cap:
			if cap["Year"] == current_season:
				cap["Dead Cap"] += current_season_dead_cap
		for cap in Rosters.dead_cap:
			if cap["Year"] == current_season + 1:
				cap["Dead Cap"] += next_season_dead_cap
		for cap in Rosters.dead_cap:
			if cap["Year"] == current_season + 2:
				cap["Dead Cap"] += three_season_dead_cap
		for cap in Rosters.dead_cap:
			if cap["Year"] == current_season + 3:
				cap["Dead Cap"] += four_season_dead_cap
	else:
		if player["Remaining Contract"] == 1 or player["Remaining Contract"] == 2:
			return
		elif player["Remaining Contract"] == 3:
			var current_season_dead_cap = player["Salary"] * .25
			for cap in Rosters.dead_cap:
				if cap["Year"] == current_season:
					cap["Dead Cap"] += current_season_dead_cap
		elif player["Remaining Contract"] == 4:
			var current_season_dead_cap = player["Salary"] * .4
			var next_season_dead_cap = player["Salary"] * .25
			for cap in Rosters.dead_cap:
				if cap["Year"] == current_season:
					cap["Dead Cap"] += current_season_dead_cap
			for cap in Rosters.dead_cap:
				if cap["Year"] == current_season + 1:
					cap["Dead Cap"] += next_season_dead_cap
		elif player["Remaining Contract"] == 5:
			var current_season_dead_cap = player["Salary"] * .6
			var next_season_dead_cap = player["Salary"] * .4
			var three_season_dead_cap = player["Salary"] * .25
			for cap in Rosters.dead_cap:
				if cap["Year"] == current_season:
					cap["Dead Cap"] += current_season_dead_cap
			for cap in Rosters.dead_cap:
				if cap["Year"] == current_season + 1:
					cap["Dead Cap"] += next_season_dead_cap
			for cap in Rosters.dead_cap:
				if cap["Year"] == current_season + 2:
					cap["Dead Cap"] += three_season_dead_cap
	

func _on_change_position_pressed():
	if selected_player == "":
		return
	var root = get_tree().root
	var position_change_scene = load("res://PositionChange.tscn")
	var position_change_instance = position_change_scene.instantiate()
	position_change_instance.selected_player = selected_player
	position_change_instance.connect("position_change_done", _on_position_change_done)
	root.add_child(position_change_instance)
	var current_scene = get_tree().current_scene

func _on_position_change_done():
	populate_test("DepthChart/QBDepth")
