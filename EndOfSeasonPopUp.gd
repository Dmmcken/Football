extends Node2D

var mvp = []
var champ = []
var opoy = []
var oroy = []
var dpoy = []
var droy = []

@onready var champ_label = $Panel/ChampLabel
@onready var mvp_label = $Panel/MVPLabel
@onready var opoy_label = $Panel/OPOYLabel
@onready var oroy_label = $Panel/OROYLabel
@onready var dpoy_label = $Panel/DPOYLabel
@onready var droy_label = $Panel/DROYLabel


func _ready():
	set_champ_label()
	set_mvp_label()
	set_opoy_label()
	set_oroy_label()
	set_dpoy_label()
	set_droy_label()

func set_champ_label():
	for team in champ:
		var label_text = team
		champ_label.text = label_text

func set_mvp_label():
	var mvp_id = mvp[0]["PlayerID"]
	var first_name = ""
	var last_name = ""
	var mvp_team = ""
	for team in Rosters.team_rosters:
		for player in Rosters.team_rosters[team]:
			if player["PlayerID"] == mvp_id:
				first_name = player["FirstName"]
				last_name = player["LastName"]
				mvp_team = team
	mvp_label.text = "%s %s %s Pass Yards: %d Pass TD's: %d Ints: %d" % [mvp_team, first_name, last_name, mvp[0]["pass_yards"], mvp[0]["pass_tds"], mvp[0]["interceptions"]]

func set_opoy_label():
	var opoy_id = opoy[0]["PlayerID"]
	var first_name = ""
	var last_name = ""
	var opoy_team = ""
	for team in Rosters.team_rosters:
		for player in Rosters.team_rosters[team]:
			if player["PlayerID"] == opoy_id:
				first_name = player["FirstName"]
				last_name = player["LastName"]
				opoy_team = team
	if opoy[0]["rush_yards"] >= opoy[0]["rec_yards"]:
		opoy_label.text = "%s %s %s Rush Yards: %d Rush TD's: %d Fumbles: %d" % [opoy_team, first_name, last_name, opoy[0]["rush_yards"], opoy[0]["rush_tds"], opoy[0]["fumbles"]]
	else:
		opoy_label.text = "%s %s %s Rec Yards: %d Rec TD's: %d Fumbles: %d" % [opoy_team, first_name, last_name, opoy[0]["rec_yards"], opoy[0]["rec_tds"], opoy[0]["fumbles"]]

func set_oroy_label():
	var oroy_id = oroy[0]["PlayerID"]
	var first_name = ""
	var last_name = ""
	var oroy_team = ""
	for team in Rosters.team_rosters:
		for player in Rosters.team_rosters[team]:
			if player["PlayerID"] == oroy_id:
				first_name = player["FirstName"]
				last_name = player["LastName"]
				oroy_team = team
	if "pass_yards" in oroy[0]:
		oroy_label.text = "%s %s %s Pass Yards: %d Pass TD's: %d Interceptions: %d" % [oroy_team, first_name, last_name, oroy[0]["pass_yards"], oroy[0]["pass_tds"], oroy[0]["interceptions"]]
	else:
		if oroy[0]["rush_yards"] >= oroy[0]["rec_yards"]:
			oroy_label.text = "%s %s %s Rush Yards: %d Rush TD's: %d Fumbles: %d" % [oroy_team, first_name, last_name, oroy[0]["rush_yards"], oroy[0]["rush_tds"], oroy[0]["fumbles"]]
		else:
			oroy_label.text = "%s %s %s Rec Yards: %d Rec TD's: %d Fumbles: %d" % [oroy_team, first_name, last_name, oroy[0]["rec_yards"], oroy[0]["rec_tds"], oroy[0]["fumbles"]]

func set_dpoy_label():
	var dpoy_id = dpoy[0]["PlayerID"]
	print(dpoy_id)
	var first_name = ""
	var last_name = ""
	var dpoy_team = ""
	for team in Rosters.team_rosters:
		for player in Rosters.team_rosters[team]:
			if player["PlayerID"] == dpoy_id:
				first_name = player["FirstName"]
				last_name = player["LastName"]
				dpoy_team = team
	dpoy_label.text = "%s %s %s Tackles: %d Sacks: %d FF: %d INTs: %d TDs: %d" % [dpoy_team, first_name, last_name, dpoy[0]["tackles"], dpoy[0]["sacks"], dpoy[0]["forced_fumbles"], dpoy[0]["interceptions"], dpoy[0]["touchdowns"]]

func set_droy_label():
	var droy_id = droy[0]["PlayerID"]
	print(droy_id)
	var first_name = ""
	var last_name = ""
	var droy_team = ""
	for team in Rosters.team_rosters:
		for player in Rosters.team_rosters[team]:
			if player["PlayerID"] == droy_id:
				first_name = player["FirstName"]
				last_name = player["LastName"]
				droy_team = team
	droy_label.text = "%s %s %s Tackles: %d Sacks: %d FF: %d INTs: %d TDs: %d" % [droy_team, first_name, last_name, droy[0]["tackles"], droy[0]["sacks"], droy[0]["forced_fumbles"], droy[0]["interceptions"], droy[0]["touchdowns"]]

func _on_continue_pressed():
	get_tree().current_scene.queue_free()
