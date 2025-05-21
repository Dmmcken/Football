extends Node2D

var player_choice = ""

signal run_button_pressed
signal short_pass_button_pressed
signal medium_pass_button_pressed
signal long_pass_button_pressed
signal field_goal_button_pressed
signal punt_button_pressed

func _on_run_pressed():
	emit_signal("run_button_pressed")

func _on_short_pass_pressed():
	emit_signal("short_pass_button_pressed")
	
func _on_medium_pass_pressed():
	emit_signal("medium_pass_button_pressed")

func _on_long_pass_pressed():
	emit_signal("long_pass_button_pressed")

func _on_field_goal_pressed():
	emit_signal("field_goal_button_pressed")

func _on_punt_pressed():
	emit_signal("punt_button_pressed")

@onready var left_team_name_label = $Panel/LeftTeamNameLabel
@onready var right_team_name_label = $Panel/RightTeamNameLabel
@onready var left_team_score_label = $Panel/LeftTeamScoreLabel
@onready var right_team_score_label = $Panel/RightTeamScoreLabel
@onready var down_to_go_label = $Panel/DownToGoLabel
@onready var time_label = $Panel/TimeLabel
@onready var last_play_label = $Panel/LastPlayLabel



func update_game_ui(game_state, last_play):
	left_team_name_label.text = str(game_state.team_left_name)
	right_team_name_label.text = str(game_state.team_right_name)
	left_team_score_label.text = str(game_state.team_left_score)
	right_team_score_label.text = str(game_state.team_right_score)
	if game_state.los + game_state.to_go >= 100:
		down_to_go_label.text = str(game_state.down, " & Goal")
	else:
		down_to_go_label.text = str(game_state.down, " & ", game_state.to_go)
	var minutes = game_state.time / 60
	var seconds = game_state.time % 60
	if game_state.time > 0:
		time_label.text = "%d:%02d" % [minutes, seconds]
	else:
		time_label.text = "00:00"
	last_play_label.text = last_play

func update_lines(los, to_go, game_state):
	if game_state.offense == game_state.team_left_name:
		var los_line = (228 + (los * 6.95))
		var to_go_line = los_line + (to_go * 6.95)
		$LineOfScrimmage.points = [Vector2(los_line,87), Vector2(los_line, 426)]
		if los + to_go >= 100:
			$DistanceToGo.points = [Vector2(930,87), Vector2(930, 426)]
		else:
			$DistanceToGo.points = [Vector2(to_go_line,87), Vector2(to_go_line, 426)]
	else:
		var los_line = (923 - (los * 6.95))
		var to_go_line = los_line - (to_go * 6.95)
		$LineOfScrimmage.points = [Vector2(los_line,87), Vector2(los_line, 426)]
		if los + to_go >= 100:
			$DistanceToGo.points = [Vector2(224,87), Vector2(224, 426)]
		else:
			$DistanceToGo.points = [Vector2(to_go_line,87), Vector2(to_go_line, 426)]




