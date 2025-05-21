extends Node2D

var team_left_name = ""
var team_right_name = ""
var team_left_score = 0
var team_right_score = 0
var team_left_stats = []
var team_right_stats = []

@onready var team_left_name_label = $TeamLeftName
@onready var team_left_score_label = $TeamLeftScore
@onready var team_right_name_label = $TeamRightName
@onready var team_right_score_label = $TeamRightScore
@onready var team_left_qb_label = $TeamLeftQB
@onready var team_right_qb_label = $TeamRightQB
@onready var team_left_rb_label = $TeamLeftRB
@onready var team_right_rb_label = $TeamRightRB
@onready var team_left_wr_label_1 = $TeamLeftWR
@onready var team_left_wr_label_2 = $TeamLeftWR2
@onready var team_right_wr_label_1 = $TeamRightWR
@onready var team_right_wr_label_2 = $TeamRightWR2
@onready var team_left_def_label_1 = $TeamLeftDef
@onready var team_left_def_label_2 = $TeamLeftDef2
@onready var team_right_def_label_1 = $TeamRightDef
@onready var team_right_def_label_2 = $TeamRightDef2
@onready var team_left_kick_label = $TeamLeftKick
@onready var team_right_kick_label = $TeamRightKick

func _ready():
	set_left_team()
	set_right_team()

func set_left_team():
	team_left_name_label.text = team_left_name
	team_left_score_label.text = str(team_left_score)
	var team_left_qb = []
	var qb_first_name = ""
	var qb_last_name = ""
	var qb_id = ""
	var qb_stats = []
	for player in team_left_stats:
		if "pass_yards" in player:
			qb_id = player["PlayerID"]
			qb_stats.append(player)
	for player in Rosters.team_rosters[team_left_name]:
		if player["PlayerID"] == qb_id:
			qb_first_name = player["FirstName"]
			qb_last_name = player["LastName"]
	team_left_qb_label.text = "%s %s Pass Yards: %d Pass TD's: %d Ints: %d" % [qb_first_name, qb_last_name, qb_stats[0]["pass_yards"], qb_stats[0]["pass_tds"], qb_stats[0]["interceptions"]]
	var team_left_rb = []
	var rb_first_name = ""
	var rb_last_name = ""
	var rb_id = ""
	var rb_stats = []
	for player in team_left_stats:
		if "rush_yards" in player:
			rb_stats.append(player)
	rb_stats.sort_custom(func(a, b):
		return a["rush_yards"] > b["rush_yards"])
	rb_id = rb_stats[0]["PlayerID"]
	for player in Rosters.team_rosters[team_left_name]:
		if player["PlayerID"] == rb_id:
			rb_first_name = player["FirstName"]
			rb_last_name = player["LastName"]
	team_left_rb_label.text = "%s %s Rush Yards: %d Rush TD's: %d Fumbles: %d" % [rb_first_name, rb_last_name, rb_stats[0]["rush_yards"], rb_stats[0]["rush_tds"], rb_stats[0]["fumbles"]]
	var team_left_wr = []
	var wr_first_name = ""
	var wr_last_name = ""
	var wr_id = ""
	var wr_first_name_2 = ""
	var wr_last_name_2 = ""
	var wr_id_2 = ""
	var wr_stats = []
	for player in team_left_stats:
		if "rush_yards" in player:
			wr_stats.append(player)
	wr_stats.sort_custom(func(a, b):
		return a["rec_yards"] > b["rec_yards"])
	wr_id = wr_stats[0]["PlayerID"]
	wr_id_2 = wr_stats[1]["PlayerID"]
	for player in Rosters.team_rosters[team_left_name]:
		if player["PlayerID"] == wr_id:
			wr_first_name = player["FirstName"]
			wr_last_name = player["LastName"]
		if player["PlayerID"] == wr_id_2:
			wr_first_name_2 = player["FirstName"]
			wr_last_name_2 = player["LastName"]
	team_left_wr_label_1.text = "%s %s Rec Yards: %d Rec TD's: %d Fumbles: %d" % [wr_first_name, wr_last_name, wr_stats[0]["rec_yards"], wr_stats[0]["rec_tds"], wr_stats[0]["fumbles"]]
	team_left_wr_label_2.text = "%s %s Rec Yards: %d Rec TD's: %d Fumbles: %d" % [wr_first_name_2, wr_last_name_2, wr_stats[1]["rec_yards"], wr_stats[1]["rec_tds"], wr_stats[1]["fumbles"]]
	var team_left_def = []
	var def_first_name = ""
	var def_last_name = ""
	var def_id = ""
	var def_first_name_2 = ""
	var def_last_name_2 = ""
	var def_id_2 = ""
	var def_stats = []
	for player in team_left_stats:
		if "tackles" in player:
			player["Score"] = 0
			def_stats.append(player)
	for player in def_stats:
		player["Score"] += player["tackles"]
		player["Score"] += player["interceptions"] * 5
		player["Score"] += player["forced_fumbles"] * 5
		player["Score"] += player["touchdowns"] * 5
		player["Score"] += player["sacks"] * 3
	def_stats.sort_custom(func(a, b):
		return a["Score"] > b["Score"])
	for player in def_stats:
		def_id = def_stats[0]["PlayerID"]
		def_id_2 = def_stats[1]["PlayerID"]
	for player in Rosters.team_rosters[team_left_name]:
		if player["PlayerID"] == def_id:
			def_first_name = player["FirstName"]
			def_last_name = player["LastName"]
		if player["PlayerID"] == def_id_2:
			def_first_name_2 = player["FirstName"]
			def_last_name_2 = player["LastName"]
	team_left_def_label_1.text = "%s %s Tkls: %d INTs: %d FF: %d Sacks: %d TD: %d" % [def_first_name, def_last_name, def_stats[0]["tackles"], def_stats[0]["interceptions"], def_stats[0]["forced_fumbles"], def_stats[0]["sacks"], def_stats[0]["touchdowns"]]
	team_left_def_label_2.text = "%s %s Tkls: %d INTs: %d FF: %d Sacks: %d TD: %d" % [def_first_name_2, def_last_name_2, def_stats[1]["tackles"], def_stats[1]["interceptions"], def_stats[1]["forced_fumbles"], def_stats[1]["sacks"], def_stats[1]["touchdowns"]]
	var team_left_k = []
	var k_first_name = ""
	var k_last_name = ""
	var k_id = ""
	var k_stats = []
	for player in team_left_stats:
		if "xp_makes" in player:
			k_id = player["PlayerID"]
			k_stats.append(player)
	if k_stats.size() != 0:
		for player in Rosters.team_rosters[team_left_name]:
			if player["PlayerID"] == k_id:
				k_first_name = player["FirstName"]
				k_last_name = player["LastName"]
		var kick_att = k_stats[0]["under_30_attempts"] +  k_stats[0]["attempts_30_40"] +  k_stats[0]["attempts_41_50"] +  k_stats[0]["attempts_51_60"] +  k_stats[0]["attempts_61"]
		var kick_comp = k_stats[0]["under_30_makes"] +  k_stats[0]["makes_30_40"] +  k_stats[0]["makes_41_50"] +  k_stats[0]["makes_51_60"] +  k_stats[0]["makes_61"]
		team_left_kick_label.text = "%s %s FGs: %d/%d XPs: %d/%d" % [k_first_name, k_last_name, kick_comp, kick_att, k_stats[0]["xp_makes"], k_stats[0]["xp_attempts"]]


func set_right_team():
	team_right_name_label.text = team_right_name
	team_right_score_label.text = str(team_right_score)
	var team_right_qb = []
	var qb_first_name = ""
	var qb_last_name = ""
	var qb_id = ""
	var qb_stats = []
	for player in team_right_stats:
		if "pass_yards" in player:
			qb_id = player["PlayerID"]
			qb_stats.append(player)
	for player in Rosters.team_rosters[team_right_name]:
		if player["PlayerID"] == qb_id:
			qb_first_name = player["FirstName"]
			qb_last_name = player["LastName"]
	team_right_qb_label.text = "%s %s Pass Yards: %d Pass TD's: %d Ints: %d" % [qb_first_name, qb_last_name, qb_stats[0]["pass_yards"], qb_stats[0]["pass_tds"], qb_stats[0]["interceptions"]]
	var team_right_rb = []
	var rb_first_name = ""
	var rb_last_name = ""
	var rb_id = ""
	var rb_stats = []
	for player in team_right_stats:
		if "rush_yards" in player:
			rb_id = player["PlayerID"]
			rb_stats.append(player)
	for player in Rosters.team_rosters[team_right_name]:
		if player["PlayerID"] == rb_id:
			rb_first_name = player["FirstName"]
			rb_last_name = player["LastName"]
	rb_stats.sort_custom(func(a, b):
		return a["rush_yards"] > b["rush_yards"])
	team_right_rb_label.text = "%s %s Rush Yards: %d Rush TD's: %d Fumbles: %d" % [rb_first_name, rb_last_name, rb_stats[0]["rush_yards"], rb_stats[0]["rush_tds"], rb_stats[0]["fumbles"]]
	var team_right_wr = []
	var wr_first_name = ""
	var wr_last_name = ""
	var wr_id = ""
	var wr_first_name_2 = ""
	var wr_last_name_2 = ""
	var wr_id_2 = ""
	var wr_stats = []
	for player in team_right_stats:
		if "rush_yards" in player:
			wr_stats.append(player)
	wr_stats.sort_custom(func(a, b):
		return a["rec_yards"] > b["rec_yards"])
	wr_id = wr_stats[0]["PlayerID"]
	wr_id_2 = wr_stats[1]["PlayerID"]
	for player in Rosters.team_rosters[team_right_name]:
		if player["PlayerID"] == wr_id:
			wr_first_name = player["FirstName"]
			wr_last_name = player["LastName"]
		if player["PlayerID"] == wr_id_2:
			wr_first_name_2 = player["FirstName"]
			wr_last_name_2 = player["LastName"]
	team_right_wr_label_1.text = "%s %s Rec Yards: %d Rec TD's: %d Fumbles: %d" % [wr_first_name, wr_last_name, wr_stats[0]["rec_yards"], wr_stats[0]["rec_tds"], wr_stats[0]["fumbles"]]
	team_right_wr_label_2.text = "%s %s Rec Yards: %d Rec TD's: %d Fumbles: %d" % [wr_first_name_2, wr_last_name_2, wr_stats[1]["rec_yards"], wr_stats[1]["rec_tds"], wr_stats[1]["fumbles"]]
	var team_right_def = []
	var def_first_name = ""
	var def_last_name = ""
	var def_id = ""
	var def_first_name_2 = ""
	var def_last_name_2 = ""
	var def_id_2 = ""
	var def_stats = []
	for player in team_right_stats:
		if "tackles" in player:
			player["Score"] = 0
			def_stats.append(player)
	for player in def_stats:
		player["Score"] += player["tackles"]
		player["Score"] += player["interceptions"] * 5
		player["Score"] += player["forced_fumbles"] * 5
		player["Score"] += player["touchdowns"] * 5
		player["Score"] += player["sacks"] * 3
	def_stats.sort_custom(func(a, b):
		return a["Score"] > b["Score"])
	for player in def_stats:
		def_id = def_stats[0]["PlayerID"]
		def_id_2 = def_stats[1]["PlayerID"]
	for player in Rosters.team_rosters[team_right_name]:
		if player["PlayerID"] == def_id:
			def_first_name = player["FirstName"]
			def_last_name = player["LastName"]
		if player["PlayerID"] == def_id_2:
			def_first_name_2 = player["FirstName"]
			def_last_name_2 = player["LastName"]
	team_right_def_label_1.text = "%s %s Tkls: %d INTs: %d FF: %d Sacks: %d TD: %d" % [def_first_name, def_last_name, def_stats[0]["tackles"], def_stats[0]["interceptions"], def_stats[0]["forced_fumbles"], def_stats[0]["sacks"], def_stats[0]["touchdowns"]]
	team_right_def_label_2.text = "%s %s Tkls: %d INTs: %d FF: %d Sacks: %d TD: %d" % [def_first_name_2, def_last_name_2, def_stats[1]["tackles"], def_stats[1]["interceptions"], def_stats[1]["forced_fumbles"], def_stats[1]["sacks"], def_stats[1]["touchdowns"]]
	var team_right_k = []
	var k_first_name = ""
	var k_last_name = ""
	var k_id = ""
	var k_stats = []
	for player in team_right_stats:
		if "xp_makes" in player:
			k_id = player["PlayerID"]
			k_stats.append(player)
	if k_stats.size() != 0:
		for player in Rosters.team_rosters[team_right_name]:
			if player["PlayerID"] == k_id:
				k_first_name = player["FirstName"]
				k_last_name = player["LastName"]
		var kick_att = k_stats[0]["under_30_attempts"] +  k_stats[0]["attempts_30_40"] +  k_stats[0]["attempts_41_50"] +  k_stats[0]["attempts_51_60"] +  k_stats[0]["attempts_61"]
		var kick_comp = k_stats[0]["under_30_makes"] +  k_stats[0]["makes_30_40"] +  k_stats[0]["makes_41_50"] +  k_stats[0]["makes_51_60"] +  k_stats[0]["makes_61"]
		team_right_kick_label.text = "%s %s FGs: %d/%d XPs: %d/%d" % [k_first_name, k_last_name, kick_comp, kick_att, k_stats[0]["xp_makes"], k_stats[0]["xp_attempts"]]

func _on_continue_pressed():
	self.queue_free()
