extends Node2D

var selected_player = ""
var selected_team = GameData.selected_team_name
var player_position = ""
var player_change_position = ""
var new_rating = 0

@onready var player_label = $PlayerLabel

func _ready():
	player_position = get_selected_player_position()
	populate_position_change_list("PositionChangeScroll/PositionChangeBox")
	set_player_label_text()

func get_selected_player_position():
	for player in Rosters.team_rosters[selected_team]:
		if player["PlayerID"] == selected_player:
			return player["Position"]

func populate_position_change_list(container_path):
	var container = get_node(container_path)
	for child in container.get_children():
		child.queue_free()
	if player_position == "QB":
		var button_text = "No Eligible Position Changes"
		var position_button = Button.new()
		position_button.text = button_text
		position_button.name = "QB"
		container.add_child(position_button)
	elif player_position == "RB":
		var rating_1 = get_rating_1()
		var rating_2 = get_rating_2()
		var rating_3 = get_rating_3()
		var wr_button = Button.new()
		wr_button.text = "WR New OVR: %d" % rating_2
		wr_button.name = "WR"
		wr_button.pressed.connect(self._on_PlayerButton_pressed.bind(wr_button.name, rating_2))
		container.add_child(wr_button)
		var r_button = Button.new()
		r_button.text = "R New OVR: %d" % rating_3
		r_button.name = "R"
		r_button.pressed.connect(self._on_PlayerButton_pressed.bind(r_button.name, rating_3))
		container.add_child(r_button)
	elif player_position == "WR":
		var rating_1 = get_rating_1()
		var rating_2 = get_rating_2()
		var rating_3 = get_rating_3()
		var rb_button = Button.new()
		rb_button.text = "RB New OVR: %d" % rating_2
		rb_button.name = "RB"
		rb_button.pressed.connect(self._on_PlayerButton_pressed.bind(rb_button.name, rating_2))
		container.add_child(rb_button)
		var r_button = Button.new()
		r_button.text = "R New OVR: %d" % rating_3
		r_button.name = "R"
		r_button.pressed.connect(self._on_PlayerButton_pressed.bind(r_button.name, rating_3))
		container.add_child(r_button)
	elif player_position == "TE":
		var rating_1 = get_rating_1()
		var rating_2 = get_rating_2()
		var rating_3 = get_rating_3()
		var wr_button = Button.new()
		wr_button.text = "WR New OVR: %d" % rating_2
		wr_button.name = "WR"
		wr_button.pressed.connect(self._on_PlayerButton_pressed.bind(wr_button.name, rating_2))
		container.add_child(wr_button)
	elif player_position == "RT":
		var rating_1 = get_rating_1()
		var rating_2 = get_rating_2()
		var rating_3 = get_rating_3()
		var lt_button = Button.new()
		lt_button.text = "LT New OVR: %d" % rating_1
		lt_button.name = "LT"
		lt_button.pressed.connect(self._on_PlayerButton_pressed.bind(lt_button.name, rating_1))
		container.add_child(lt_button)
		var rg_button = Button.new()
		rg_button.text = "RG New OVR: %d" % rating_2
		rg_button.name = "RG"
		rg_button.pressed.connect(self._on_PlayerButton_pressed.bind(rg_button.name, rating_2))
		container.add_child(rg_button)
		var lg_button = Button.new()
		lg_button.text = "LG New OVR: %d" % rating_2
		lg_button.name = "LG"
		lg_button.pressed.connect(self._on_PlayerButton_pressed.bind(lg_button.name, rating_2))
		container.add_child(lg_button)
		var c_button = Button.new()
		c_button.text = "C New OVR: %d" % rating_3
		c_button.name = "C"
		c_button.pressed.connect(self._on_PlayerButton_pressed.bind(c_button.name, rating_3))
		container.add_child(c_button)
	elif player_position == "LT":
		var rating_1 = get_rating_1()
		var rating_2 = get_rating_2()
		var rating_3 = get_rating_3()
		var rt_button = Button.new()
		rt_button.text = "RT New OVR: %d" % rating_1
		rt_button.name = "RT"
		rt_button.pressed.connect(self._on_PlayerButton_pressed.bind(rt_button.name, rating_1))
		container.add_child(rt_button)
		var rg_button = Button.new()
		rg_button.text = "RG New OVR: %d" % rating_2
		rg_button.name = "RG"
		rg_button.pressed.connect(self._on_PlayerButton_pressed.bind(rg_button.name, rating_2))
		container.add_child(rg_button)
		var lg_button = Button.new()
		lg_button.text = "LG New OVR: %d" % rating_2
		lg_button.name = "LG"
		lg_button.pressed.connect(self._on_PlayerButton_pressed.bind(lg_button.name, rating_2))
		container.add_child(lg_button)
		var c_button = Button.new()
		c_button.text = "C New OVR: %d" % rating_3
		c_button.name = "C"
		c_button.pressed.connect(self._on_PlayerButton_pressed.bind(c_button.name, rating_3))
		container.add_child(c_button)
	elif player_position == "RG":
		var rating_1 = get_rating_1()
		var rating_2 = get_rating_2()
		var rating_3 = get_rating_3()
		var lg_button = Button.new()
		lg_button.text = "LG New OVR: %d" % rating_1
		lg_button.name = "LG"
		lg_button.pressed.connect(self._on_PlayerButton_pressed.bind(lg_button.name, rating_1))
		container.add_child(lg_button)
		var rt_button = Button.new()
		rt_button.text = "RT New OVR: %d" % rating_2
		rt_button.name = "RT"
		rt_button.pressed.connect(self._on_PlayerButton_pressed.bind(rt_button.name, rating_2))
		container.add_child(rt_button)
		var lt_button = Button.new()
		lt_button.text = "LT New OVR: %d" % rating_2
		lt_button.name = "LT"
		lt_button.pressed.connect(self._on_PlayerButton_pressed.bind(lt_button.name, rating_2))
		container.add_child(lt_button)
		var c_button = Button.new()
		c_button.text = "C New OVR: %d" % rating_2
		c_button.name = "C"
		c_button.pressed.connect(self._on_PlayerButton_pressed.bind(c_button.name, rating_2))
		container.add_child(c_button)
	elif player_position == "LG":
		var rating_1 = get_rating_1()
		var rating_2 = get_rating_2()
		var rating_3 = get_rating_3()
		var rg_button = Button.new()
		rg_button.text = "RG New OVR: %d" % rating_1
		rg_button.name = "RG"
		rg_button.pressed.connect(self._on_PlayerButton_pressed.bind(rg_button.name, rating_1))
		container.add_child(rg_button)
		var rt_button = Button.new()
		rt_button.text = "RT New OVR: %d" % rating_2
		rt_button.name = "RT"
		rt_button.pressed.connect(self._on_PlayerButton_pressed.bind(rt_button.name, rating_2))
		container.add_child(rt_button)
		var lt_button = Button.new()
		lt_button.text = "LT New OVR: %d" % rating_2
		lt_button.name = "LT"
		lt_button.pressed.connect(self._on_PlayerButton_pressed.bind(lt_button.name, rating_2))
		container.add_child(lt_button)
		var c_button = Button.new()
		c_button.text = "C New OVR: %d" % rating_2
		c_button.name = "C"
		c_button.pressed.connect(self._on_PlayerButton_pressed.bind(c_button.name, rating_2))
		container.add_child(c_button)
	elif player_position == "C":
		var rating_1 = get_rating_1()
		var rating_2 = get_rating_2()
		var rating_3 = get_rating_3()
		var rg_button = Button.new()
		rg_button.text = "RG New OVR: %d" % rating_2
		rg_button.name = "RG"
		rg_button.pressed.connect(self._on_PlayerButton_pressed.bind(rg_button.name, rating_2))
		container.add_child(rg_button)
		var lg_button = Button.new()
		lg_button.text = "LG New OVR: %d" % rating_2
		lg_button.name = "LG"
		lg_button.pressed.connect(self._on_PlayerButton_pressed.bind(lg_button.name, rating_2))
		container.add_child(lg_button)
		var rt_button = Button.new()
		rt_button.text = "RT New OVR: %d" % rating_3
		rt_button.name = "RT"
		rt_button.pressed.connect(self._on_PlayerButton_pressed.bind(rt_button.name, rating_3))
		container.add_child(rt_button)
		var lt_button = Button.new()
		lt_button.text = "LT New OVR: %d" % rating_3
		lt_button.name = "LT"
		lt_button.pressed.connect(self._on_PlayerButton_pressed.bind(lt_button.name, rating_3))
		container.add_child(lt_button)
	elif player_position == "LE":
		var rating_1 = get_rating_1()
		var rating_2 = get_rating_2()
		var rating_3 = get_rating_3()
		var re_button = Button.new()
		re_button.text = "RE New OVR: %d" % rating_1
		re_button.name = "RE"
		re_button.pressed.connect(self._on_PlayerButton_pressed.bind(re_button.name, rating_1))
		container.add_child(re_button)
		var dt_button = Button.new()
		dt_button.text = "DT New OVR: %d" % rating_2
		dt_button.name = "DT"
		dt_button.pressed.connect(self._on_PlayerButton_pressed.bind(dt_button.name, rating_2))
		container.add_child(dt_button)
		var olb_button = Button.new()
		olb_button.text = "OLB New OVR: %d" % rating_3
		olb_button.name = "OLB"
		olb_button.pressed.connect(self._on_PlayerButton_pressed.bind(olb_button.name, rating_3))
		container.add_child(olb_button)
		var mlb_button = Button.new()
		mlb_button.text = "MLB New OVR: %d" % rating_3
		mlb_button.name = "MLB"
		mlb_button.pressed.connect(self._on_PlayerButton_pressed.bind(mlb_button.name, rating_3))
		container.add_child(mlb_button)
	elif player_position == "RE":
		var rating_1 = get_rating_1()
		var rating_2 = get_rating_2()
		var rating_3 = get_rating_3()
		var le_button = Button.new()
		le_button.text = "LE New OVR: %d" % rating_1
		le_button.name = "LE"
		le_button.pressed.connect(self._on_PlayerButton_pressed.bind(le_button.name, rating_1))
		container.add_child(le_button)
		var dt_button = Button.new()
		dt_button.text = "DT New OVR: %d" % rating_2
		dt_button.name = "DT"
		dt_button.pressed.connect(self._on_PlayerButton_pressed.bind(dt_button.name, rating_2))
		container.add_child(dt_button)
		var olb_button = Button.new()
		olb_button.text = "OLB New OVR: %d" % rating_3
		olb_button.name = "OLB"
		olb_button.pressed.connect(self._on_PlayerButton_pressed.bind(olb_button.name, rating_3))
		container.add_child(olb_button)
		var mlb_button = Button.new()
		mlb_button.text = "MLB New OVR: %d" % rating_3
		mlb_button.name = "MLB"
		mlb_button.pressed.connect(self._on_PlayerButton_pressed.bind(mlb_button.name, rating_3))
		container.add_child(mlb_button)
	elif player_position == "DT":
		var rating_1 = get_rating_1()
		var rating_2 = get_rating_2()
		var rating_3 = get_rating_3()
		var re_button = Button.new()
		re_button.text = "RE New OVR: %d" % rating_2
		re_button.name = "RE"
		re_button.pressed.connect(self._on_PlayerButton_pressed.bind(re_button.name, rating_2))
		container.add_child(re_button)
		var le_button = Button.new()
		le_button.text = "LE New OVR: %d" % rating_2
		le_button.name = "LE"
		le_button.pressed.connect(self._on_PlayerButton_pressed.bind(le_button.name, rating_2))
		container.add_child(le_button)
	elif player_position == "OLB":
		var rating_1 = get_rating_1()
		var rating_2 = get_rating_2()
		var rating_3 = get_rating_3()
		var re_button = Button.new()
		re_button.text = "RE New OVR: %d" % rating_2
		re_button.name = "RE"
		re_button.pressed.connect(self._on_PlayerButton_pressed.bind(re_button.name, rating_2))
		container.add_child(re_button)
		var le_button = Button.new()
		le_button.text = "LE New OVR: %d" % rating_2
		le_button.name = "LE"
		le_button.pressed.connect(self._on_PlayerButton_pressed.bind(le_button.name, rating_2))
		container.add_child(le_button)
		var mlb_button = Button.new()
		mlb_button.text = "MLB New OVR: %d" % rating_1
		mlb_button.name = "MLB"
		mlb_button.pressed.connect(self._on_PlayerButton_pressed.bind(mlb_button.name, rating_1))
		container.add_child(mlb_button)
	elif player_position == "MLB":
		var rating_1 = get_rating_1()
		var rating_2 = get_rating_2()
		var rating_3 = get_rating_3()
		var re_button = Button.new()
		re_button.text = "RE New OVR: %d" % rating_2
		re_button.name = "RE"
		re_button.pressed.connect(self._on_PlayerButton_pressed.bind(re_button.name, rating_2))
		container.add_child(re_button)
		var le_button = Button.new()
		le_button.text = "LE New OVR: %d" % rating_2
		le_button.name = "LE"
		le_button.pressed.connect(self._on_PlayerButton_pressed.bind(le_button.name, rating_2))
		container.add_child(le_button)
		var olb_button = Button.new()
		olb_button.text = "OLB New OVR: %d" % rating_1
		olb_button.name = "OLB"
		olb_button.pressed.connect(self._on_PlayerButton_pressed.bind(olb_button.name, rating_1))
		container.add_child(olb_button)
	elif player_position == "CB":
		var rating_1 = get_rating_1()
		var rating_2 = get_rating_2()
		var rating_3 = get_rating_3()
		var fs_button = Button.new()
		fs_button.text = "FS New OVR: %d" % rating_2
		fs_button.name = "FS"
		fs_button.pressed.connect(self._on_PlayerButton_pressed.bind(fs_button.name, rating_2))
		container.add_child(fs_button)
		var ss_button = Button.new()
		ss_button.text = "SS New OVR: %d" % rating_2
		ss_button.name = "SS"
		ss_button.pressed.connect(self._on_PlayerButton_pressed.bind(ss_button.name, rating_2))
		container.add_child(ss_button)
	elif player_position == "SS":
		var rating_1 = get_rating_1()
		var rating_2 = get_rating_2()
		var rating_3 = get_rating_3()
		var fs_button = Button.new()
		fs_button.text = "FS New OVR: %d" % rating_1
		fs_button.name = "FS"
		fs_button.pressed.connect(self._on_PlayerButton_pressed.bind(fs_button.name, rating_1))
		container.add_child(fs_button)
		var cb_button = Button.new()
		cb_button.text = "CB New OVR: %d" % rating_2
		cb_button.name = "CB"
		cb_button.pressed.connect(self._on_PlayerButton_pressed.bind(cb_button.name, rating_2))
		container.add_child(cb_button)
	elif player_position == "FS":
		var rating_1 = get_rating_1()
		var rating_2 = get_rating_2()
		var rating_3 = get_rating_3()
		var ss_button = Button.new()
		ss_button.text = "SS New OVR: %d" % rating_1
		ss_button.name = "SS"
		ss_button.pressed.connect(self._on_PlayerButton_pressed.bind(ss_button.name, rating_1))
		container.add_child(ss_button)
		var cb_button = Button.new()
		cb_button.text = "CB New OVR: %d" % rating_2
		cb_button.name = "CB"
		cb_button.pressed.connect(self._on_PlayerButton_pressed.bind(cb_button.name, rating_2))
		container.add_child(cb_button)
	elif player_position == "K":
		var rating_1 = get_rating_1()
		var rating_2 = get_rating_2()
		var rating_3 = get_rating_3()
		var p_button = Button.new()
		p_button.text = "P New OVR: %d" % rating_3
		p_button.name = "P"
		p_button.pressed.connect(self._on_PlayerButton_pressed.bind(p_button.name, rating_3))
		container.add_child(p_button)
	elif player_position == "P":
		var rating_1 = get_rating_1()
		var rating_2 = get_rating_2()
		var rating_3 = get_rating_3()
		var k_button = Button.new()
		k_button.text = "K New OVR: %d" % rating_3
		k_button.name = "K"
		k_button.pressed.connect(self._on_PlayerButton_pressed.bind(k_button.name, rating_3))
		container.add_child(k_button)
	elif player_position == "R":
		var rating_1 = get_rating_1()
		var rating_2 = get_rating_2()
		var rating_3 = get_rating_3()
		var wr_button = Button.new()
		wr_button.text = "WR New OVR: %d" % rating_3
		wr_button.name = "WR"
		wr_button.pressed.connect(self._on_PlayerButton_pressed.bind(wr_button.name, rating_3))
		container.add_child(wr_button)
		var rb_button = Button.new()
		rb_button.text = "RB New OVR: %d" % rating_3
		rb_button.name = "RB"
		rb_button.pressed.connect(self._on_PlayerButton_pressed.bind(rb_button.name, rating_3))
		container.add_child(rb_button)

func _on_PlayerButton_pressed(position, rating):
	player_change_position = position
	new_rating = rating

func get_rating_1():
	var original_rating = 0
	var new_rating = 0
	for player in Rosters.team_rosters[selected_team]:
		if player["PlayerID"] == selected_player:
			original_rating = player["Rating"]
	var seed = int(str(selected_player)[-1])
	if seed in [0, 1, 2, 3]:
		new_rating = original_rating
	elif seed in [4, 5, 6]:
		new_rating = original_rating + 1
	elif seed in [7, 8, 9]:
		new_rating = original_rating - 1
	return new_rating

func get_rating_2():
	var original_rating = 0
	var new_rating = 0
	for player in Rosters.team_rosters[selected_team]:
		if player["PlayerID"] == selected_player:
			original_rating = player["Rating"]
	var seed = int(str(selected_player)[-1])
	if seed in [0]:
		new_rating = original_rating
	elif seed in [1, 2]:
		new_rating = original_rating - 1
	elif seed in [3, 4, 5, 6]:
		new_rating = original_rating - 2
	elif seed in [7, 8, 9]:
		new_rating = original_rating - 3
	return new_rating

func get_rating_3():
	var original_rating = 0
	var new_rating = 0
	for player in Rosters.team_rosters[selected_team]:
		if player["PlayerID"] == selected_player:
			original_rating = player["Rating"]
	var seed = int(str(selected_player)[-1])
	if seed in [0, 1]:
		new_rating = original_rating - 2
	elif seed in [3, 4, 5]:
		new_rating = original_rating - 3
	elif seed in [2, 6, 7]:
		new_rating = original_rating - 4
	elif seed in [8, 9]:
		new_rating = original_rating - 5
	return new_rating

func set_player_label_text():
	var rating = 0
	var first_name = ""
	var last_name = ""
	var player_position = ""
	for player in Rosters.team_rosters[selected_team]:
		if player["PlayerID"] == selected_player:
			rating = player["Rating"]
			first_name = player["FirstName"]
			last_name = player["LastName"]
			player_position = player["Position"]
	player_label.text = "%s %s %s OVR: %d" % [player_position, first_name, last_name, rating]

signal position_change_done

func _on_back_pressed():
	emit_signal("position_change_done")
	self.queue_free()


func _on_change_pressed():
	if player_change_position == "":
		return
	
	var all_players_at_new_position = []
	
	for player in Rosters.team_rosters[selected_team]:
		if player["PlayerID"] == selected_player:
			player["Position"] = player_change_position
			player["Rating"] = new_rating
	
	for player in Rosters.team_rosters[selected_team]:
		if player["Position"] == player_change_position:
			all_players_at_new_position.append(player)
	
	all_players_at_new_position.sort_custom(func(a, b):
		return a["Rating"] > b["Rating"])
	
	for i in range(all_players_at_new_position.size()):
		all_players_at_new_position[i]["DepthChart"] = i + 1
	
	for player in all_players_at_new_position:
		for player2 in Rosters.team_rosters[selected_team]:
			if player2["PlayerID"] == player["PlayerID"]:
				player2["DepthChart"] = player["DepthChart"]
	
	player_position = get_selected_player_position()
	populate_position_change_list("PositionChangeScroll/PositionChangeBox")
	player_position = ""
	player_change_position = ""
	new_rating = 0
	set_player_label_text()
